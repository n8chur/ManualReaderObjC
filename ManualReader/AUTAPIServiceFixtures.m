//
//  AUTAPIServiceFixtures.m
//  ManualReader
//
//  Created by Westin Newell on 5/4/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

#import "MTLModel+AUTValidateNonnull.h"

#import "AUTDictionaryTransformer.h"
#import "AUTAPIFixtureEndpointInfo.h"
#import "AUTValidatingValueTransformer.h"
#import "AUTExtObjC.h"

#import "AUTAPIServiceFixtures.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AUTAPIServiceFixtures

#pragma mark - Lifecycle

- (nullable instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (![self validate:error]) return nil;
    return self;
}

#pragma mark - AUTAPIServiceFixtures <MTLJSONSerializing>

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"scheme": @"scheme",
        @"host": @"host",
        @"basePath": @"base_path",
        @"endpoints": @"endpoints",
        @"examples": @"examples",
    };
}

+ (NSValueTransformer *)schemeJSONTransformer {
    return [AUTValidatingValueTransformer nonnullValidatingTransformerForClass:NSString.class];
}

+ (NSValueTransformer *)hostJSONTransformer {
    return [AUTValidatingValueTransformer nonnullValidatingTransformerForClass:NSString.class];
}

+ (NSValueTransformer *)basePathJSONTransformer {
    return [AUTValidatingValueTransformer nullableValidatingTransformerForClass:NSString.class];
}

+ (NSValueTransformer *)endpointsJSONTransformer {
    let keyTransformer = [AUTValidatingValueTransformer nonnullValidatingTransformerForClass:NSString.class];
    let valueTransformer = [MTLJSONAdapter dictionaryTransformerWithModelClass:AUTAPIFixtureEndpointInfo.class];
    return [[AUTDictionaryTransformer alloc] initWithKeyTransformer:keyTransformer valueTransformer:valueTransformer];
}

+ (NSValueTransformer *)examplesJSONTransformer {
    let keyTransformer = [AUTValidatingValueTransformer nonnullValidatingTransformerForClass:NSString.class];
    return [[AUTDictionaryTransformer alloc] initWithKeyTransformer:keyTransformer valueTransformer:nil];
}

#pragma mark - MTLModel

- (BOOL)validateScheme:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"scheme" error:error];
}

- (BOOL)validateHost:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"host" error:error];
}

- (BOOL)validateEndpoints:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"endpoints" error:error];
}

- (BOOL)validateExamples:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"examples" error:error];
}

@end

NS_ASSUME_NONNULL_END
