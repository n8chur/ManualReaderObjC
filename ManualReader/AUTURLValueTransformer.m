//
//  AUTURLValueTransformer.m
//  ManualReader
//
//  Created by Eric Horacek on 11/18/15.
//  Copyright © 2015 Automatic Labs. All rights reserved.
//

#import "AUTURLValueTransformer.h"

NS_ASSUME_NONNULL_BEGIN

@interface AUTURLValueTransformer ()

@property (readonly, nonatomic, strong) AUTValidatingValueTransformer *stringValidatingTransformer;
@property (readonly, nonatomic, strong) AUTValidatingValueTransformer *URLValidatingTransformer;
@property (readonly, nonatomic, strong) NSValueTransformer<MTLTransformerErrorHandling> *URLValueTransformer;

@end

@implementation AUTURLValueTransformer

#pragma mark - Lifecycle

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use the designated initializer instead" userInfo:nil];
}

- (instancetype)initWithNullabilityBehavior:(AUTValidatingValueTransformerNullabilityBehavior)nullabilityBehavior {
    self = [super init];

    _stringValidatingTransformer = [[AUTValidatingValueTransformer alloc] initWithValueClass:NSString.class nullabilityBehavior:nullabilityBehavior];
    _URLValidatingTransformer = [[AUTValidatingValueTransformer alloc] initWithValueClass:NSURL.class nullabilityBehavior:nullabilityBehavior];

    _URLValueTransformer = (NSValueTransformer<MTLTransformerErrorHandling> *)[NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
    NSParameterAssert(_URLValueTransformer != nil);

    return self;
}

+ (instancetype)nonnullValueTransformer {
    return [[self alloc] initWithNullabilityBehavior:AUTValidatingValueTransformerNullabilityBehaviorNonnull];
}

+ (instancetype)nullableValueTransformer {
    return [[self alloc] initWithNullabilityBehavior:AUTValidatingValueTransformerNullabilityBehaviorNullable];
}

#pragma mark - NSValueTransformer

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return NSURL.class;
}

- (nullable id)transformedValue:(nullable id)value {
    return [self transformedValue:value success:NULL error:NULL];
}

- (nullable id)reverseTransformedValue:(nullable id)value {
    return [self reverseTransformedValue:value success:NULL error:NULL];
}

#pragma mark - NSValueTransformer <MTLTransformerErrorHandling>

- (nullable NSURL *)transformedValue:(nullable NSString *)value success:(BOOL * _Nullable)success error:(NSError **)error {
    NSString *validatedString = [self.stringValidatingTransformer transformedValue:value success:success error:error];
    if (validatedString == nil) return nil;

    if (validatedString.length == 0) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:MTLTransformerErrorHandlingErrorDomain code:MTLTransformerErrorHandlingErrorInvalidInput userInfo: @{
                NSLocalizedDescriptionKey: NSLocalizedString(@"URL string length is invalid", @""),
                NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"URL string is empty", @""),
                MTLTransformerErrorHandlingInputValueErrorKey : validatedString,
            }];
        }

        if (success != NULL) {
            *success = NO;
        }

        return nil;
    }

    return [self.URLValueTransformer transformedValue:validatedString success:success error:error];
}

- (nullable NSString *)reverseTransformedValue:(nullable NSURL *)value success:(BOOL * _Nullable)success error:(NSError **)error {
    NSURL *validatedURL = [self.URLValidatingTransformer transformedValue:value success:success error:error];
    if (validatedURL == nil) return nil;

    return [self.URLValueTransformer reverseTransformedValue:validatedURL success:success error:error];
}

@end

NS_ASSUME_NONNULL_END
