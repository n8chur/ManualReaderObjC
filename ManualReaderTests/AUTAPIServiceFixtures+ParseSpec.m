//
//  AUTAPIServiceFixtures+ParseSpec.m
//  ManualReaderTests
//
//  Created by Westin Newell on 1/16/18.
//  Copyright © 2018 Automatic Labs. All rights reserved.
//

@import Specta;
@import Expecta;

#import "AUTExtObjC.h"

#import "ManualReader.h"

SpecBegin(AUTAPIServiceFixtures_Parse)

describe(@"AUTServiceFixtures", ^{
    it(@"should parse from valid input", ^{
        let host = @"example.automatic.com";
        let bundle = [NSBundle bundleForClass:AUTAPIServiceFixtures.class];
        let path = [NSString stringWithFormat:@"fixtures/%@", host];
        let fixtures = [AUTAPIServiceFixtures fixturesInBundle:bundle atPath:path];
        expect(fixtures).to.beAKindOf(AUTAPIServiceFixtures.class);

        expect(fixtures.scheme).to.equal(@"https");
        expect(fixtures.host).to.equal(host);
        expect(fixtures.basePath).to.beNil();

        expect(fixtures.endpoints).to.haveACountOf(1);

        let pathTemplate = @"test/{test_id}/";
        let endpoint = fixtures.endpoints[pathTemplate];
        expect(endpoint).to.beAKindOf(AUTAPIFixtureEndpointInfo.class);
        expect(endpoint.pathTemplate).to.equal(pathTemplate);

        let method = @"GET";
        let statusCode = 200;
        let fixtureName = [AUTAPIFixture nameWithMethod:method statusCode:statusCode];
        let fixture = endpoint.fixtures[fixtureName];
        expect(fixture).to.beAKindOf(AUTAPIFixture.class);

        let request = fixture.request;
        expect(request.method).to.equal(method);
        let testIDValue = @"TEST_ABC123";
        expect(request.path).to.equal([NSString stringWithFormat:@"test/%@/", testIDValue]);
        expect(request.headers).to.haveACountOf(0);
        expect(request.jsonBody).to.beNil();
        expect(request.body).to.equal(@"");
        expect(request.URL).to.equal([NSURL URLWithString:@"https://example.automatic.com/test/TEST_ABC123/"]);
        expect(request.parameters.path).to.haveACountOf(1);
        expect(request.parameters.path[@"test_id"]).to.equal(testIDValue);
        expect(request.parameters.query).to.haveACountOf(0);

        let response = fixture.response;
        expect(response.statusCode).to.equal(statusCode);
        expect(response.jsonBody).to.equal(@{
            @"items": @[
                @{
                    @"created_at": @"2017-04-14T12:00:00Z+00:00",
                    @"status": @"success",
                    @"type": @"Base_B"
                },
                @{
                    @"created_at": @"2017-04-14T12:00:00Z+00:00",
                    @"duration": @42.1337,
                    @"type": @"Base_A"
                }
            ]
        });

        NSError *error;
        NSString *body;
        if (response.jsonBody != nil) {
            let data = [NSJSONSerialization dataWithJSONObject:AUTNotNil(response.jsonBody) options:NSJSONWritingSortedKeys error:&error];
            expect(error).to.beNil();
            expect(data).notTo.beNil();
            body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        expect(body).notTo.beNil();
        expect(response.body).to.equal(body);

    });
});

SpecEnd
