//
//  AUTDictionaryTransformer.m
//  ManualReader
//
//  Created by Westin Newell on 5/5/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

#import "AUTValidatingValueTransformer.h"

#import "AUTDictionaryTransformer.h"

NS_ASSUME_NONNULL_BEGIN

@interface AUTDictionaryTransformer ()

@property (readonly, nonatomic) NSValueTransformer<MTLTransformerErrorHandling> *keyTransformer;
@property (readonly, nonatomic, nullable) NSValueTransformer<MTLTransformerErrorHandling> *valueTransformer;
@property (readonly, nonatomic) AUTValidatingValueTransformer *dictionaryTransformer;

@end

@implementation AUTDictionaryTransformer

#pragma mark - Lifecycle

- (instancetype)initWithKeyTransformer:(NSValueTransformer<MTLTransformerErrorHandling> *)keyTransformer valueTransformer:(nullable NSValueTransformer<MTLTransformerErrorHandling> *)valueTransformer {
    self = [super init];

    _keyTransformer = keyTransformer;
    _valueTransformer = valueTransformer;
    _dictionaryTransformer = [AUTValidatingValueTransformer nullableValidatingTransformerForClass:NSDictionary.class];

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

#pragma mark - AUTDictionaryTransformer <MTLTransformerErrorHandling>

- (nullable NSDictionary *)transformedValue:(nullable id)value success:(BOOL *)success error:(NSError **)error {
    NSDictionary *validatedDictionary = [self.dictionaryTransformer transformedValue:value success:success error:error];
    if (validatedDictionary == nil) return nil;
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:validatedDictionary.count];
    
    for (id key in validatedDictionary.allKeys) {
        id transformedKey = [self.keyTransformer transformedValue:key success:success error:error];
        if (transformedKey == nil) return nil;

        id dictionaryValue = validatedDictionary[key];
        if (self.valueTransformer == nil) {
            result[transformedKey] = dictionaryValue;
            continue;
        }

        id transformedValue = [self.valueTransformer transformedValue:dictionaryValue success:success error:error];
        if (*error != nil) return nil;
        if (transformedValue == nil) {
            transformedValue = NSNull.null;
        }

        result[transformedKey] = transformedValue;
    }
    
    *success = YES;

    return result;
}

@end

NS_ASSUME_NONNULL_END
