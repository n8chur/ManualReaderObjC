//
//  AUTValidatingValueTransformer.m
//  ManualReader
//
//  Created by Eric Horacek on 11/18/15.
//  Copyright © 2015 Automatic Labs. All rights reserved.
//

#import "AUTExtObjC.h"

#import "AUTValidatingValueTransformer.h"

NS_ASSUME_NONNULL_BEGIN

@interface AUTValidatingValueTransformer ()

@property (readonly, nonatomic, strong) Class valueClass;
@property (readonly, nonatomic, assign) AUTValidatingValueTransformerNullabilityBehavior nullabilityBehavior;

@end

@implementation AUTValidatingValueTransformer

#pragma mark - Lifecycle

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Use the designated initializer instead" userInfo:nil];
}

- (instancetype)initWithValueClass:(Class)valueClass nullabilityBehavior:(AUTValidatingValueTransformerNullabilityBehavior)nullabilityBehavior {
    NSParameterAssert(valueClass != Nil);

    self = [super init];

    _valueClass = valueClass;
    _nullabilityBehavior = nullabilityBehavior;

    return self;
}

+ (instancetype)nullableValidatingTransformerForClass:(Class)valueClass {
    return [[self alloc] initWithValueClass:valueClass nullabilityBehavior:AUTValidatingValueTransformerNullabilityBehaviorNullable];
}

+ (instancetype)nonnullValidatingTransformerForClass:(Class)valueClass {
    return [[self alloc] initWithValueClass:valueClass nullabilityBehavior:AUTValidatingValueTransformerNullabilityBehaviorNonnull];
}

#pragma mark - NSValueTransformer

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return NSObject.class;
}

- (nullable id)transformedValue:(nullable id)value {
    return [self transformedValue:value success:NULL error:NULL];
}

- (nullable id)reverseTransformedValue:(nullable id)value {
    return [self reverseTransformedValue:value success:NULL error:NULL];
}

#pragma mark - NSValueTransformer <MTLTransformerErrorHandling>

- (nullable id)transformedValue:(nullable id)value success:(BOOL *)success error:(NSError **)error {
    if (value == nil && self.nullabilityBehavior == AUTValidatingValueTransformerNullabilityBehaviorNonnull) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:MTLTransformerErrorHandlingErrorDomain code:MTLTransformerErrorHandlingErrorInvalidInput userInfo:@{
                NSLocalizedDescriptionKey: NSLocalizedString(@"Nonnull value was nil", @""),
                NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedString(@"Expected value of class %@ to be nonnull but got nil", @""), self.valueClass],
            }];
        }

        if (success != NULL) {
            *success = NO;
        }

        return nil;
    }

    if (value != nil && ![value isKindOfClass:self.valueClass]) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:MTLTransformerErrorHandlingErrorDomain code:MTLTransformerErrorHandlingErrorInvalidInput userInfo: @{
                NSLocalizedDescriptionKey: NSLocalizedString(@"Value did not match expected type", @""),
                NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedString(@"Expected %1$@ to be of class %2$@ but got %3$@", @""), value, self.valueClass, [value class]],
                MTLTransformerErrorHandlingInputValueErrorKey : AUTNotNil(value),
            }];
        }

        if (success != NULL) {
            *success = NO;
        }

        return nil;
    }

    if (success != NULL) {
        *success = YES;
    }

    return value;
}

- (nullable id)reverseTransformedValue:(id)value success:(BOOL *)success error:(NSError *__autoreleasing *)error {
    return [self transformedValue:value success:success error:error];
}

@end

NS_ASSUME_NONNULL_END
