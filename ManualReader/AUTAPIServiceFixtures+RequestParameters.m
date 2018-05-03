//
//  AUTAPIServiceFixtures+RequestParameters.m
//  ManualReader
//
//  Created by Westin Newell on 5/5/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

#import "AUTAPIFixtureEndpointInfo.h"
#import "AUTAPIFixture.h"
#import "AUTAPIFixtureRequest.h"
#import "AUTExtObjC.h"

#import "AUTAPIServiceFixtures+RequestParameters.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AUTAPIServiceFixtures (RequestParameters)

- (nullable AUTAPIFixtureRequestParameters *)requestParametersForMethod:(NSString *)method pathTemplate:(NSString *)pathTemplate statusCode:(NSUInteger)statusCode {
    AUTAssertNotNil(method, pathTemplate);
    
    let fixtureName = [AUTAPIFixture nameWithMethod:method statusCode:statusCode];
    
    let endpoint = self.endpoints[pathTemplate];
    AUTAssertNotNil(endpoint);
    
    let fixture = endpoint.fixtures[fixtureName];
    AUTAssertNotNil(fixture);
    
    return fixture.request.parameters;
}

@end

NS_ASSUME_NONNULL_END
