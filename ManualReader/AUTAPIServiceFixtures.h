//
//  AUTAPIServiceFixtures.h
//  ManualReader
//
//  Created by Westin Newell on 5/4/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import Mantle;

NS_ASSUME_NONNULL_BEGIN

@class AUTAPIFixtureEndpointInfo;

/// A collection of fixtures for a specific service, indexed by endpoint.
@interface AUTAPIServiceFixtures: MTLModel <MTLJSONSerializing>

- (instancetype)init NS_UNAVAILABLE;

@property (readonly, nonatomic, copy) NSString *scheme;

@property (readonly, nonatomic, copy) NSString *host;

@property (readonly, nonatomic, copy, nullable) NSString *basePath;

/// A dictionary where the key is the endpoint path template
/// (e.g. "vehicles/{vehicle_id}/activity/").
@property (readonly, nonatomic, copy) NSDictionary<NSString *, AUTAPIFixtureEndpointInfo *> *endpoints;

/// A dictionary where the key is the object name, and the value is an example
/// of that object (if concrete), otherwise an array of possible examples (if
/// abstract).
@property (readonly, nonatomic, copy) NSDictionary<NSString *, id> *examples;

@end

NS_ASSUME_NONNULL_END
