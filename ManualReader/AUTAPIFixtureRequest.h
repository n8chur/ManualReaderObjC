//
//  AUTAPIFixtureRequest.h
//  ManualReader
//
//  Created by Westin Newell on 5/5/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import Mantle;

@class AUTAPIFixtureRequestParameters;

NS_ASSUME_NONNULL_BEGIN

@interface AUTAPIFixtureRequest : MTLModel <MTLJSONSerializing>

- (instancetype)init NS_UNAVAILABLE;

@property (readonly, nonatomic, copy) NSString *method;

@property (readonly, nonatomic, copy) NSString *path;

/// The value is nullable.
@property (readonly, nonatomic, copy) NSDictionary<NSString *, NSString *> *headers;

@property (readonly, nonatomic, nullable, copy) NSDictionary<NSString *, id> *jsonBody;

@property (readonly, nonatomic, copy) NSString *body;

@property (readonly, nonatomic, copy) NSURL *URL;

@property (readonly, nonatomic) AUTAPIFixtureRequestParameters *parameters;

@end

NS_ASSUME_NONNULL_END
