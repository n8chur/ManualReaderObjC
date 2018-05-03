//
//  AUTJSONStringTransformer.m
//  ManualReader
//
//  Created by Westin Newell on 11/22/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

#import "AUTExtObjC.h"
#import "AUTDictionaryTransformer.h"
#import "AUTValidatingValueTransformer.h"

#import "AUTJSONStringTransformer.h"

NS_ASSUME_NONNULL_BEGIN

@interface AUTJSONStringTransformer()

@property (readonly, nonatomic) AUTDictionaryTransformer *dictionaryTransformer;
@property (readonly, nonatomic) AUTValidatingValueTransformer *stringTransformer;

@end

@implementation AUTJSONStringTransformer

- (instancetype)init {
    self = [super init];

    _stringTransformer = [AUTValidatingValueTransformer nonnullValidatingTransformerForClass:NSString.class];
    _dictionaryTransformer = [[AUTDictionaryTransformer alloc] initWithKeyTransformer:_stringTransformer valueTransformer:nil];

    return self;
}

#pragma mark - NSValueTransformer

+ (Class)transformedValueClass {
    return NSDictionary.class;
}

- (nullable id)transformedValue:(nullable id)value {
    return [self transformedValue:value success:NULL error:NULL];
}

- (nullable id)reverseTransformedValue:(nullable id)value {
    return [self reverseTransformedValue:value success:NULL error:NULL];
}

#pragma mark - AUTJSONStringTransformer <MTLTransformerErrorHandling>

- (nullable NSDictionary *)transformedValue:(nullable id)value success:(BOOL *)success error:(NSError **)error {
    if (value == nil) {
        if (success != NULL) {
            *success = YES;
        }
        return nil;
    }

    let stringValue = (NSString *)[self.stringTransformer transformedValue:value success:success error:error];
    if (stringValue == nil) return nil;

    if ([stringValue.lowercaseString isEqualToString:@"null"] || stringValue.length == 0) {
        if (success != NULL) {
            *success = YES;
        }
        return nil;
    }

    let data = [stringValue dataUsingEncoding:NSUTF8StringEncoding];
    if (data == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:MTLTransformerErrorHandlingErrorDomain code:MTLTransformerErrorHandlingErrorInvalidInput userInfo: @{
                NSLocalizedDescriptionKey: NSLocalizedString(@"JSON string was unable to be converted to data.", @""),
                NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedString(@"Expected %1$@ to be convertable to NSData", @""), stringValue],
                MTLTransformerErrorHandlingInputValueErrorKey : AUTNotNil(stringValue),
            }];
        }

        if (success != NULL) {
            *success = NO;
        }

        return nil;
    }

    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    if (json == nil) {
        if (success != NULL) {
            *success = YES;
        }
        return nil;
    }

    if (success != NULL) {
        *success = YES;
    }

    return json;
}

@end

NS_ASSUME_NONNULL_END
