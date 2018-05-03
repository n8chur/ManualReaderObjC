//
//  AUTAPIFixtureResponse.m
//  ManualReader
//
//  Created by Westin Newell on 5/5/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

#import "MTLModel+AUTValidateNonnull.h"

#import "AUTDictionaryTransformer.h"
#import "AUTJSONStringTransformer.h"
#import "AUTExtObjC.h"
#import "AUTValidatingValueTransformer.h"

#import "AUTAPIFixtureResponse.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AUTAPIFixtureResponse

#pragma mark - Lifecycle

- (nullable instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (![self validate:error]) return nil;
    return self;
}

#pragma mark - AUTAPIFixtureResponse <MTLJSONSerializing>

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"statusCode": @"status_code",
        @"headers": @"headers",
        @"jsonBody": @"body",
        @"body": @"body",
    };
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
    return [AUTValidatingValueTransformer nonnullValidatingTransformerForClass:NSString.class];;
}

#pragma mark - MTLModel

- (BOOL)validateHeaders:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"headers" error:error];
}

- (BOOL)validateBody:(id _Nullable *)value error:(NSError **)error {
    return [self aut_validateNonnull:value forKey:@"body" error:error];
}

@end

NS_ASSUME_NONNULL_END
