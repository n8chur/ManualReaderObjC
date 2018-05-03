//
//  AUTAPIServiceFixtures+Stub.m
//  ManualReader
//
//  Created by Westin Newell on 5/5/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import Expecta;
@import AUTTestKit;

#import "AUTAPIFixtureEndpointInfo.h"
#import "AUTAPIFixture.h"
#import "AUTAPIFixtureRequest.h"
#import "AUTAPIFixtureRequestParameters.h"
#import "AUTAPIFixtureResponse.h"
#import "AUTExtObjC.h"

#import "AUTAPIServiceFixtures+Stub.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AUTAPIServiceFixtures (Stub)

- (LSStubResponseDSL *)stubRequestWithMethod:(NSString *)method pathTemplate:(NSString *)pathTemplate statusCode:(NSInteger)statusCode {
    AUTAssertNotNil(method, pathTemplate);

    let fixtureName = [AUTAPIFixture nameWithMethod:method statusCode:statusCode];
    
    let fixture = self.endpoints[pathTemplate].fixtures[fixtureName];
    AUTAssertNotNil(fixture);
    
    let url = fixture.request.URL.absoluteString;
    AUTAssertNotNil(url);
    
    return stubRequest(method, url)
        .withHeaders(fixture.request.headers)
        .andReturn(statusCode)
        .withHeaders(fixture.response.headers)
        .withJSONString(fixture.response.body);
}

- (LSStubResponseDSL *)stubRequestNillingInnerPageCursorsWithMethod:(NSString *)method pathTemplate:(NSString *)pathTemplate statusCode:(NSInteger)statusCode {
    AUTAssertNotNil(method, pathTemplate);

    let fixtureName = [AUTAPIFixture nameWithMethod:method statusCode:statusCode];

    let fixture = self.endpoints[pathTemplate].fixtures[fixtureName];
    AUTAssertNotNil(fixture);

    let originalJSONBody = (NSDictionary *)fixture.response.jsonBody;

    let originalInnerItems = (NSArray<NSDictionary *> *)originalJSONBody[@"items"];
    expect(originalInnerItems.count).to.beGreaterThan(0);

    let innerItemsJSON = (NSMutableArray<NSDictionary *> *)[NSMutableArray arrayWithCapacity:originalInnerItems.count];
    for (NSDictionary *item in originalInnerItems) {
        if (![item.allKeys containsObject:@"next"] && ![item.allKeys containsObject:@"previous"]) {
            [innerItemsJSON addObject:item];
            continue;
        }

        let newItem = [item mtl_dictionaryByAddingEntriesFromDictionary:@{
            @"next": NSNull.null,
            @"previous": NSNull.null,
        }];
        [innerItemsJSON addObject:newItem];
    }

    let jsonBody = [(NSDictionary *)originalJSONBody mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"items": innerItemsJSON,
    }];

    let url = fixture.request.URL.absoluteString;
    AUTAssertNotNil(url);

    return stubRequest(method, url)
        .withHeaders(fixture.request.headers)
        .andReturn(statusCode)
        .withHeaders(fixture.response.headers)
        .withJSON(jsonBody);
}

- (NSArray<LSStubResponseDSL *> *)stubPaginatedNextPageRequestsWithMethod:(NSString *)method pathTemplate:(NSString *)pathTemplate statusCode:(NSInteger)statusCode pageKeyPath:(NSString *)pageKeyPath paginationEndpointPath:(NSString *)paginationEndpointPath {
    AUTAssertNotNil(method, pathTemplate, pageKeyPath, paginationEndpointPath);

    let fixtureName = [AUTAPIFixture nameWithMethod:method statusCode:statusCode];

    let fixture = self.endpoints[pathTemplate].fixtures[fixtureName];
    AUTAssertNotNil(fixture);

    let originalJSON = fixture.response.jsonBody;
    let originalPageJSON = (NSDictionary *)[originalJSON valueForKeyPath:pageKeyPath];
    expect(originalPageJSON).notTo.beNil();

    let page1URL = fixture.request.URL;
    let page1URLString = AUTNotNil(fixture.request.URL.absoluteString);

    let components = [NSURLComponents componentsWithURL:page1URL resolvingAgainstBaseURL:NO];
    let cursor = [NSURLQueryItem queryItemWithName:@"test_cursor" value:@"ABC123"];
    let queryItems = components.queryItems ?: @[];
    components.queryItems = [queryItems arrayByAddingObject:cursor];
    components.path = paginationEndpointPath;
    let page2URLString = AUTNotNil(components.URL.absoluteString);

    let page1JSON = [originalPageJSON mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"previous": NSNull.null,
        @"next": page2URLString,
    }];

    let firstResponseJSON = (NSDictionary *)[originalJSON mutableCopy];
    [firstResponseJSON setValue:page1JSON forKeyPath:pageKeyPath];

    // First page
    let page1Stub = stubRequest(@"GET", page1URLString)
        .withHeader(@"Authorization", @"Session TOKEN")
        .andReturn(200)
        .withJSON(firstResponseJSON);

    let page2JSON = [page1JSON mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"previous": page1URLString,
        @"next": NSNull.null,
    }];

    // Second page
    let page2Stub = stubRequest(@"GET", page2URLString)
        .withHeader(@"Authorization", @"Session TOKEN")
        .andReturn(200)
        .withJSON(page2JSON);

    return @[ page1Stub, page2Stub ];
}

- (NSArray<LSStubResponseDSL *> *)stubPaginatedOutterNextPageRequestsWithMethod:(NSString *)method pathTemplate:(NSString *)pathTemplate statusCode:(NSInteger)statusCode {
    AUTAssertNotNil(method, pathTemplate);

    let fixtureName = [AUTAPIFixture nameWithMethod:method statusCode:statusCode];

    let fixture = self.endpoints[pathTemplate].fixtures[fixtureName];
    AUTAssertNotNil(fixture);

    let originalPageJSON = fixture.response.jsonBody;

    let originalItems = (NSArray<NSDictionary *> *)originalPageJSON[@"items"];
    expect(originalItems.count).to.beGreaterThan(0);

    let newItems = (NSMutableArray<NSDictionary *> *)[NSMutableArray arrayWithCapacity:originalItems.count];
    for (NSDictionary *item in originalItems) {
        if (![item.allKeys containsObject:@"next"] && ![item.allKeys containsObject:@"previous"]) {
            [newItems addObject:item];
            continue;
        }

        let newItem = [item mtl_dictionaryByAddingEntriesFromDictionary:@{
            @"next": NSNull.null,
            @"previous": NSNull.null,
        }];
        [newItems addObject:newItem];
    }

    let pageJSON = [originalPageJSON mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"items": newItems,
    }];

    let page1URL = fixture.request.URL;
    let page1URLString = AUTNotNil(fixture.request.URL.absoluteString);

    let components = [NSURLComponents componentsWithURL:page1URL resolvingAgainstBaseURL:NO];
    let cursor = [NSURLQueryItem queryItemWithName:@"test_cursor" value:@"ABC123"];
    let queryItems = components.queryItems ?: @[];
    components.queryItems = [queryItems arrayByAddingObject:cursor];
    let page2URLString = AUTNotNil(components.URL.absoluteString);

    let page1JSON = [pageJSON mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"previous": NSNull.null,
        @"next": page2URLString,
    }];

    let page2JSON = [pageJSON mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"previous": page1URLString,
        @"next": NSNull.null,
    }];

    // First page
    let page1Stub = stubRequest(@"GET", page1URLString)
        .withHeader(@"Authorization", @"Session TOKEN")
        .andReturn(200)
        .withJSON(page1JSON);

    // Second page
    let page2Stub = stubRequest(@"GET", page2URLString)
        .withHeader(@"Authorization", @"Session TOKEN")
        .andReturn(200)
        .withJSON(page2JSON);

    return @[ page1Stub, page2Stub ];
}

- (NSArray<LSStubResponseDSL *> *)stubPaginatedInnerNextPageRequestsWithMethod:(NSString *)method pathTemplate:(NSString *)pathTemplate statusCode:(NSInteger)statusCode {
    AUTAssertNotNil(method, pathTemplate);

    let fixtureName = [AUTAPIFixture nameWithMethod:method statusCode:statusCode];

    let fixture = self.endpoints[pathTemplate].fixtures[fixtureName];
    AUTAssertNotNil(fixture);

    let originalJSONBody = (NSDictionary *)fixture.response.jsonBody;

    let originalInnerItems = (NSArray<NSDictionary *> *)originalJSONBody[@"items"];
    expect(originalInnerItems.count).to.beGreaterThan(0);

    let stubs = [NSMutableArray array];

    let innerItemsJSON = (NSMutableArray<NSDictionary *> *)[NSMutableArray arrayWithCapacity:originalInnerItems.count];
    for (NSDictionary *item in originalInnerItems) {
        if (![item.allKeys containsObject:@"next"] && ![item.allKeys containsObject:@"previous"]) {
            [innerItemsJSON addObject:item];
            continue;
        }

        let innerPage1URLString = [NSString stringWithFormat:@"https://presenter.automatic.com/test-inner-pagination/%@/", NSUUID.UUID.UUIDString];
        let innerPage2URLString = [innerPage1URLString stringByAppendingString:@"?cursor=abc123"];

        let innerPage2JSON = [item mtl_dictionaryByAddingEntriesFromDictionary:@{
            @"next": NSNull.null,
            @"previous": innerPage1URLString,
        }];

        let page2Stub = stubRequest(@"GET", innerPage2URLString)
            .withHeader(@"Authorization", @"Session TOKEN")
            .andReturn(200)
            .withJSON(innerPage2JSON);

        [stubs addObject:page2Stub];

        let newItem = [item mtl_dictionaryByAddingEntriesFromDictionary:@{
            @"next": innerPage2URLString,
            @"previous": NSNull.null,
        }];
        [innerItemsJSON addObject:newItem];
    }

    let newJSONBody = [originalJSONBody mtl_dictionaryByAddingEntriesFromDictionary:@{
        @"items": innerItemsJSON,
    }];

    let url = fixture.request.URL.absoluteString;
    AUTAssertNotNil(url);

    // Outter page
    let outterPageStub = stubRequest(@"GET", url)
        .withHeader(@"Authorization", @"Session TOKEN")
        .andReturn(200)
        .withJSON(newJSONBody);

    [stubs addObject:outterPageStub];

    return stubs;
}

@end

NS_ASSUME_NONNULL_END
