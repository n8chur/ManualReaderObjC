//
//  AUTURLValueTransformer.h
//  ManualReader
//
//  Created by Eric Horacek on 11/18/15.
//  Copyright © 2015 Automatic Labs. All rights reserved.
//

@import Mantle;

#import <ManualReader/AUTValidatingValueTransformer.h>

NS_ASSUME_NONNULL_BEGIN

/// Transforms between NSString and NSURL.
@interface AUTURLValueTransformer : NSValueTransformer

- (instancetype)init NS_UNAVAILABLE;

/// @param nullabilityBehavior Whether an error should be generated if the
///        transformed or reversed-transformed input value is nil.
- (instancetype)initWithNullabilityBehavior:(AUTValidatingValueTransformerNullabilityBehavior)nullabilityBehavior NS_DESIGNATED_INITIALIZER;

/// Creates a value transformer that errors if its transformed or reverse-
/// transformed values are nil.
+ (instancetype)nonnullValueTransformer;

/// Creates a value transformer that allows its transformed or reverse-
/// transformed values to be nil.
+ (instancetype)nullableValueTransformer;

@end

NS_ASSUME_NONNULL_END
