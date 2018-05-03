//
//  AUTAPIFixtureEndpointInfo.m
//  ManualReader
//
//  Created by Westin Newell on 5/5/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

#import "MTLModel+AUTValidateNonnull.h"

#import "AUTAPIFixture.h"
#import "AUTValidatingValueTransformer.h"
#import "AUTDictionaryTransformer.h"
#import "AUTExtObjC.h"
#import "AUTExtObjC.h"

#import "AUTAPIFixtureEndpointInfo.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AUTAPIFixtureEndpointInfo

#pragma mark - Lifecycle

- (nullable instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (![self validate:error]) return nil;
    return self;
}

#pragma mark - AUTAPIFixtureEndpointInfo <MTLJSONSerializing>

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"pathTemplate": @"path_template",
        @"fixtures": @"fixtures",
    };
}

+ (NSValueTransformer *)pathTemplateJSONTransformer {
    return [AUTValidatingValueTransformer nonnullValidatingTransformerForClass:NSString.class];
}

+ (NSValueTransformer *)fixturesJSONTransformer {
    let keyTransformer = [AUTValidatingValueTransformer nonnullValidatingTransformerForClass:NSString.class];
    let valueTransformer = [MTLJSONAdapter dictionaryTransformerWithModelClass:AUTAPIFixture.class];
    return [[AUTDictionaryTransformer alloc] initWithKeyTransformer:keyTransformer valueTransformer:valueTransformer];
}

#pragma mark - MTLModel

- (BOOL)validatePathTemplate:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"pathTemplate" error:error];
}

- (BOOL)validateFixtures:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"fixtures" error:error];
}

@end

NS_ASSUME_NONNULL_END
