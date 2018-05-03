//
//  AUTAPIServiceFixtures+Parse.m
//  ManualReader
//
//  Created by Eric Horacek on 5/24/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

#import "AUTExtObjC.h"

#import "AUTAPIServiceFixtures+Parse.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AUTAPIServiceFixtures (H)

+ (instancetype)fixturesInBundle:(NSBundle *)bundle atPath:(NSString * )path {
    AUTAssertNotNil(bundle, path);

    let rootInfoJSONPath = [bundle pathForResource:@"info" ofType:@"json" inDirectory:path];
    let rootInfoJSONData = AUTNotNil([NSData dataWithContentsOfFile:rootInfoJSONPath]);
    
    NSError *error;
    let rootInfoJSON = (NSMutableDictionary<NSString *, id> *)[[NSJSONSerialization JSONObjectWithData:rootInfoJSONData options:kNilOptions error:&error] mutableCopy];
    NSAssert(rootInfoJSON != nil, @"%@", error);
    NSParameterAssert([rootInfoJSON isKindOfClass:NSMutableDictionary.class]);
    
    let folderPaths = (NSArray<NSString *> *)AUTNotNil(rootInfoJSON[@"folder_paths"]);
    NSParameterAssert([folderPaths isKindOfClass:NSArray.class]);
    [rootInfoJSON removeObjectForKey:@"folder_paths"];
    rootInfoJSON[@"endpoints"] = [self endpointsForFolderPaths:folderPaths inFixtureDirectory:path bundle:bundle];

    let examplePaths = (NSArray<NSString *> *)AUTNotNil(rootInfoJSON[@"example_paths"]);
    NSParameterAssert([folderPaths isKindOfClass:NSArray.class]);
    [rootInfoJSON removeObjectForKey:@"example_paths"];
    rootInfoJSON[@"examples"] = [self examplesForPaths:examplePaths inFixtureDirectory:path bundle:bundle];
    
    let rootInfo = (AUTAPIServiceFixtures *)[MTLJSONAdapter modelOfClass:AUTAPIServiceFixtures.class fromJSONDictionary:rootInfoJSON error:&error];
    NSAssert(rootInfo != nil, @"%@", error);
    return rootInfo;
}

+ (NSDictionary<NSString *, NSDictionary<NSString *, id> *> *)endpointsForFolderPaths:(NSArray<NSString *> *)folderPaths inFixtureDirectory:(NSString *)fixtureDirectory bundle:(NSBundle *)bundle {
    AUTAssertNotNil(folderPaths, fixtureDirectory, bundle);

    // Replace folder_paths with endpoint object map.
    let endpoints = (NSMutableDictionary<NSString *, NSDictionary<NSString *, id> *>*)[NSMutableDictionary dictionary];
    for (NSString *folderPath in folderPaths) {
        let endpointFolder = [fixtureDirectory stringByAppendingPathComponent:folderPath];
        let endpointInfoJSONPath = [bundle pathForResource:@"info" ofType:@"json" inDirectory:endpointFolder];
        let endpointInfoJSONData = [NSData dataWithContentsOfFile:endpointInfoJSONPath];
        AUTAssertNotNil(endpointInfoJSONData);

        NSError *error;
        let endpointInfoJSON = (NSMutableDictionary<NSString *, id> *)[[NSJSONSerialization JSONObjectWithData:endpointInfoJSONData options:kNilOptions error:&error] mutableCopy];
        NSAssert(endpointInfoJSON != nil, @"%@", error);
        NSParameterAssert([endpointInfoJSON isKindOfClass:NSDictionary.class]);
        
        NSArray<NSString *> *fixturePaths = endpointInfoJSON[@"fixtures"];
        AUTAssertNotNil(fixturePaths);
        NSParameterAssert([fixturePaths isKindOfClass:NSArray.class]);

        endpointInfoJSON[@"fixtures"] = [self fixturesForFixturePaths:fixturePaths endpointFolder:endpointFolder inBundle:bundle];
        
        NSString *pathTemplate = endpointInfoJSON[@"path_template"];
        AUTAssertNotNil(pathTemplate);
        NSParameterAssert([pathTemplate isKindOfClass:NSString.class]);
        
        endpoints[pathTemplate] = endpointInfoJSON;
    }

    return [endpoints copy];
}

+ (NSDictionary<NSString *, NSDictionary<NSString *, id> *> *)fixturesForFixturePaths:(NSArray<NSString *> *)fixturePaths endpointFolder:(NSString *)endpointFolder inBundle:(NSBundle *)bundle {
    AUTAssertNotNil(fixturePaths, endpointFolder, bundle);

    // Remap fixture path array to a dictionary where the key is the
    // filename and the value is a deserialized fixture JSON.
    NSMutableDictionary<NSString *, NSDictionary<NSString *, id> *> *fixtures = [NSMutableDictionary dictionary];
    for (NSString *relativeFixturePath in fixturePaths) {
        let fixtureResourcePath = [endpointFolder stringByAppendingPathComponent:relativeFixturePath];
        let fixturePath = [bundle pathForResource:fixtureResourcePath ofType:nil];
        let fixtureJSONData = [NSData dataWithContentsOfFile:fixturePath];
        AUTAssertNotNil(fixtureJSONData);

        NSError *error;
        let fixtureJSON = (NSDictionary<NSString *, id> *)[NSJSONSerialization JSONObjectWithData:fixtureJSONData options:kNilOptions error:&error];
        NSAssert(fixtureJSON != nil, @"%@", error);
        NSParameterAssert([fixtureJSON isKindOfClass:NSDictionary.class]);
        
        let filename = [[fixturePath stringByDeletingPathExtension] lastPathComponent];
        fixtures[filename] = fixtureJSON;
    }

    return [fixtures copy];
}

+ (NSDictionary<NSString *, id> *)examplesForPaths:(NSArray<NSString *> *)examplePaths inFixtureDirectory:(NSString *)fixtureDirectory bundle:(NSBundle *)bundle {
    AUTAssertNotNil(examplePaths, fixtureDirectory, bundle);

    // Remap example path array to a dictionary where the key is the definition
    // name and the value is a deserialized example JSON.
    NSMutableDictionary<NSString *, id> *examples = [NSMutableDictionary dictionary];
    for (NSString *examplePath in examplePaths) {
        let fixtureResourcePath = [fixtureDirectory stringByAppendingPathComponent:examplePath];
        let fixturePath = [bundle pathForResource:fixtureResourcePath ofType:nil];
        let fixtureJSONData = [NSData dataWithContentsOfFile:fixturePath];
        AUTAssertNotNil(fixtureJSONData);

        NSError *error;
        id exampleJSON = [NSJSONSerialization JSONObjectWithData:fixtureJSONData options:kNilOptions error:&error];
        NSAssert(exampleJSON != nil, @"%@", error);

        let filename = [[fixturePath stringByDeletingPathExtension] lastPathComponent];
        examples[filename] = exampleJSON;
    }

    return [examples copy];
}

@end

NS_ASSUME_NONNULL_END
