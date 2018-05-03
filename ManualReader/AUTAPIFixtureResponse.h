//
//  AUTAPIFixtureResponse.h
//  ManualReader
//
//  Created by Westin Newell on 5/5/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import Mantle;

NS_ASSUME_NONNULL_BEGIN

@interface AUTAPIFixtureResponse : MTLModel <MTLJSONSerializing>

- (instancetype)init NS_UNAVAILABLE;

@property (readonly, nonatomic) NSUInteger statusCode;

@property (readonly, nonatomic, copy) NSDictionary<NSString *, NSString *> *headers;

@property (readonly, nonatomic, nullable, copy) NSDictionary<NSString *, id> *jsonBody;

@property (readonly, nonatomic, copy) NSString *body;

@end

NS_ASSUME_NONNULL_END
