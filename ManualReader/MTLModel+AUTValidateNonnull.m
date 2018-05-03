//
//  MTLModel+AUTValidateNonnull.m
//  ManualReader
//
//  Created by Eric Horacek on 11/10/15.
//  Copyright © 2015 Automatic Labs. All rights reserved.
//

#import "MTLModel+AUTValidateNonnull.h"

NS_ASSUME_NONNULL_BEGIN

NSString * ManualReaderErrorDomain = @"ManualReader";

@implementation MTLModel (AUTValidateNonnull)

- (BOOL)aut_validateNonnull:(inout id _Nullable * _Nonnull)value forKey:(NSString *)key error:(NSError **)error {
    if (*value != nil) return YES;

    if (error != NULL) {
        NSString *format = NSLocalizedString(@"The value for key '%@' was nil on %@", nil);
        NSString *description = [NSString stringWithFormat:format, key, self.class];

        *error = [NSError
            errorWithDomain:ManualReaderErrorDomain
            code:ManualReaderErrorValidationFailed
            userInfo:@{ NSLocalizedDescriptionKey: description }];
    }
    
    return NO;
}

@end

NS_ASSUME_NONNULL_END
