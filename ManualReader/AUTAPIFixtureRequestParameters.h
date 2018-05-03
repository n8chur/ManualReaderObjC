//
//  AUTAPIFixtureRequestParameters.h
//  ManualReader
//
//  Created by Westin Newell on 5/5/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import Mantle;

NS_ASSUME_NONNULL_BEGIN

@interface AUTAPIFixtureRequestParameters : MTLModel <MTLJSONSerializing>

- (instancetype)init NS_UNAVAILABLE;

/// The value is nullable.
@property (readonly, nonatomic, copy) NSDictionary<NSString *, NSString *> *query;

/// The value is nullable.
@property (readonly, nonatomic, copy) NSDictionary<NSString *, NSString *> *path;

@end

NS_ASSUME_NONNULL_END
