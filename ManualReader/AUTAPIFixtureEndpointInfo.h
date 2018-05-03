//
//  AUTAPIFixtureEndpointInfo.h
//  ManualReader
//
//  Created by Westin Newell on 5/5/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import Mantle;

@class AUTAPIFixture;

NS_ASSUME_NONNULL_BEGIN

@interface AUTAPIFixtureEndpointInfo: MTLModel <MTLJSONSerializing>

- (instancetype)init NS_UNAVAILABLE;

@property (readonly, nonatomic, copy) NSString *pathTemplate;

/// A dictionary with keys that match filename of the fixture (e.g. "GET-200").
@property (readonly, nonatomic, copy) NSDictionary<NSString *, AUTAPIFixture *> *fixtures;

@end

NS_ASSUME_NONNULL_END
