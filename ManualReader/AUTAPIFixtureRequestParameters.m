//
//  AUTAPIFixtureRequestParameters.m
//  ManualReader
//
//  Created by Westin Newell on 5/5/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

#import "MTLModel+AUTValidateNonnull.h"

#import "AUTDictionaryTransformer.h"
#import "AUTExtObjC.h"
#import "AUTValidatingValueTransformer.h"

#import "AUTAPIFixtureRequestParameters.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AUTAPIFixtureRequestParameters

#pragma mark - Lifecycle

- (nullable instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (![self validate:error]) return nil;
    return self;
}

#pragma mark - AUTAPIFixtureRequestParameters <MTLJSONSerializing>

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"query": @"query",
        @"path": @"path",
    };
}

+ (NSValueTransformer *)queryJSONTransformer {
    let keyTransformer = [AUTValidatingValueTransformer nonnullValidatingTransformerForClass:NSString.class];
    let valueTransformer = [AUTValidatingValueTransformer nullableValidatingTransformerForClass:NSString.class];
    return [[AUTDictionaryTransformer alloc] initWithKeyTransformer:keyTransformer valueTransformer:valueTransformer];
}

+ (NSValueTransformer *)pathJSONTransformer {
    let keyTransformer = [AUTValidatingValueTransformer nonnullValidatingTransformerForClass:NSString.class];
    let valueTransformer = [AUTValidatingValueTransformer nullableValidatingTransformerForClass:NSString.class];
    return [[AUTDictionaryTransformer alloc] initWithKeyTransformer:keyTransformer valueTransformer:valueTransformer];
}

#pragma mark - MTLModel

- (BOOL)validateQuery:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"query" error:error];
}

- (BOOL)validatePath:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"path" error:error];
}

@end

NS_ASSUME_NONNULL_END
