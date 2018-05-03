//
//  AUTDictionaryTransformer.h
//  ManualReader
//
//  Created by Westin Newell on 5/5/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import Mantle;

NS_ASSUME_NONNULL_BEGIN

/// Transforms a dictionary using the provided transformers for keys and values.
@interface AUTDictionaryTransformer : NSValueTransformer <MTLTransformerErrorHandling>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithKeyTransformer:(NSValueTransformer<MTLTransformerErrorHandling> *)keyTransformer valueTransformer:(nullable NSValueTransformer<MTLTransformerErrorHandling> *)valueTransformer NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
