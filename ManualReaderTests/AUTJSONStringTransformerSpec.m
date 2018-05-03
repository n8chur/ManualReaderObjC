//
//  AUTJSONStringTransformerSpec.m
//  ManualReaderTests
//
//  Created by Westin Newell on 11/22/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import Specta;
@import Expecta;

#import "AUTExtObjC.h"

#import "AUTJSONStringTransformer.h"

SpecBegin(AUTJSONStringTransformer)

describe(@"The AUTJSONStringTransformer", ^{
    __block AUTJSONStringTransformer *transformer;

    beforeEach(^{
        transformer = [[AUTJSONStringTransformer alloc] init];
    });

    it(@"should transform nil when \"null\" or empty string is provided", ^{
        expect([transformer transformedValue:@"null"]).to.beNil();
        expect([transformer transformedValue:@""]).to.beNil();
    });

    it(@"should transform a valid NSDictionary<NSString *, id> object", ^{
        let jsonString = @"{ \"foo\": 1, \"bar\": { \"baz\": \"qux\" }}";
        let json = (NSDictionary *)[transformer transformedValue:jsonString];
        expect(json).notTo.beNil();

        expect(json[@"foo"]).to.equal(@1);

        let bar = (NSDictionary *)json[@"bar"];
        expect(bar).to.beAKindOf(NSDictionary.class);

        expect(bar[@"baz"]).to.equal(@"qux");
    });
});

SpecEnd
