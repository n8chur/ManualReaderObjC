//
//  AUTAPIServiceFixtures+RequestParameters.h
//  ManualReader
//
//  Created by Westin Newell on 5/5/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

#import "AUTAPIServiceFixtures.h"

@class AUTAPIFixtureRequestParameters;

NS_ASSUME_NONNULL_BEGIN

@interface AUTAPIServiceFixtures (RequestParameters)

- (nullable AUTAPIFixtureRequestParameters *)requestParametersForMethod:(NSString *)method pathTemplate:(NSString *)pathTemplate statusCode:(NSUInteger)statusCode;

@end

NS_ASSUME_NONNULL_END
