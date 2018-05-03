//
//  AUTAPIFixture.m
//  ManualReader
//
//  Created by Westin Newell on 5/5/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

#import "MTLModel+AUTValidateNonnull.h"

#import "AUTAPIFixtureRequest.h"
#import "AUTAPIFixtureResponse.h"
#import "AUTExtObjC.h"

#import "AUTAPIFixture.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AUTAPIFixture

#pragma mark - Lifecycle

- (nullable instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (![self validate:error]) return nil;
    return self;
}

#pragma AUTAPIFixture

+ (NSString *)nameWithMethod:(NSString *)method statusCode:(NSUInteger)statusCode {
    AUTAssertNotNil(method);
    
    return [NSString stringWithFormat:@"%@-%@", method, @(statusCode)];
}

#pragma mark - AUTAPIFixture <MTLJSONSerializing>

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"request": @"request",
        @"response": @"response",
    };
}

+ (NSValueTransformer *)requestJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:AUTAPIFixtureRequest.class];
}

+ (NSValueTransformer *)responseJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:AUTAPIFixtureResponse.class];
}

#pragma mark - MTLModel

- (BOOL)validateRequest:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"request" error:error];
}

- (BOOL)validateResponse:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"response" error:error];
}

@end

NS_ASSUME_NONNULL_END
