//
//  AUTAPIServiceFixtures+Parse.h
//  ManualReader
//
//  Created by Eric Horacek on 5/24/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

#import "AUTAPIServiceFixtures.h"

NS_ASSUME_NONNULL_BEGIN

@interface AUTAPIServiceFixtures (Parse)

/// Returns the fixtures for the given service.
+ (instancetype)fixturesInBundle:(NSBundle *)bundle atPath:(NSString * )path;

@end

NS_ASSUME_NONNULL_END
