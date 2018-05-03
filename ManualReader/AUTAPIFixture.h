//
//  AUTAPIFixture.h
//  ManualReader
//
//  Created by Westin Newell on 5/5/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import Mantle;

@class AUTAPIFixtureRequest;
@class AUTAPIFixtureResponse;

NS_ASSUME_NONNULL_BEGIN

@interface AUTAPIFixture : MTLModel <MTLJSONSerializing>

- (instancetype)init NS_UNAVAILABLE;

@property (readonly, nonatomic) AUTAPIFixtureRequest *request;

@property (readonly, nonatomic) AUTAPIFixtureResponse *response;

+ (NSString *)nameWithMethod:(NSString *)method statusCode:(NSUInteger)statusCode;

@end

NS_ASSUME_NONNULL_END
