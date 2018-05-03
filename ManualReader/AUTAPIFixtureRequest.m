//
//  AUTAPIFixtureRequest.m
//  ManualReader
//
//  Created by Westin Newell on 5/5/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

#import "MTLModel+AUTValidateNonnull.h"

#import "AUTDictionaryTransformer.h"
#import "AUTURLValueTransformer.h"
#import "AUTAPIFixtureRequestParameters.h"
#import "AUTJSONStringTransformer.h"
#import "AUTExtObjC.h"

#import "AUTAPIFixtureRequest.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AUTAPIFixtureRequest

#pragma mark - Lifecycle

- (nullable instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (![self validate:error]) return nil;
    return self;
}

#pragma mark - AUTAPIFixtureRequest <MTLJSONSerializing>

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"method": @"method",
        @"path": @"path",
        @"headers": @"headers",
        @"jsonBody": @"body",
        @"body": @"body",
        @"URL": @"url",
        @"parameters": @"parameters",
    };
}

+ (NSValueTransformer *)methodJSONTransformer {
    return [AUTValidatingValueTransformer nonnullValidatingTransformerForClass:NSString.class];
}

+ (NSValueTransformer *)pathJSONTransformer {
    return [AUTValidatingValueTransformer nonnullValidatingTransformerForClass:NSString.class];
}

+ (NSValueTransformer *)headersJSONTransformer {
    let keyTransformer = [AUTValidatingValueTransformer nonnullValidatingTransformerForClass:NSString.class];
    let valueTransformer = [AUTValidatingValueTransformer nullableValidatingTransformerForClass:NSString.class];
    return [[AUTDictionaryTransformer alloc] initWithKeyTransformer:keyTransformer valueTransformer:valueTransformer];
}

+ (NSValueTransformer *)jsonBodyJSONTransformer {
    return [[AUTJSONStringTransformer alloc] init];
}

+ (NSValueTransformer *)bodyJSONTransformer {
    return [AUTValidatingValueTransformer nonnullValidatingTransformerForClass:NSString.class];
}

+ (NSValueTransformer *)URLJSONTransformer {
    return [AUTURLValueTransformer nonnullValueTransformer];
}

+ (NSValueTransformer *)parametersJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:AUTAPIFixtureRequestParameters.class];
}

#pragma mark - MTLModel

- (BOOL)validateMethod:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"method" error:error];
}

- (BOOL)validatePath:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"path" error:error];
}

- (BOOL)validateHeaders:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"headers" error:error];
}

- (BOOL)validateBody:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"body" error:error];
}

- (BOOL)validateURL:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"URL" error:error];
}

- (BOOL)validateParameters:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"parameters" error:error];
}

@end

NS_ASSUME_NONNULL_END
