//
//  MTLModel+AUTValidateNonnull.h
//  ManualReader
//
//  Created by Eric Horacek on 11/10/15.
//  Copyright © 2015 Automatic Labs. All rights reserved.
//

#import <Mantle/Mantle.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * ManualReaderErrorDomain;

typedef NS_ENUM(NSUInteger, ManualReaderError){
    ManualReaderErrorValidationFailed
};

// TODO: Move to a dedicated Transformer/Validation framework.
@interface MTLModel (AUTValidateNonnull)

/// Validates that the provided value is non-null.
///
/// For use with the KVC validation APIs.
///
/// @param value The value that should be validated.
///
/// @param error A pass-by-reference error populated if the value is null with
///        an error in the ManualReaderErrorDomain domain and with
///        the ManualReaderErrorValidationFailed code.
///
/// @return YES if the value is non-null, NO otherwise.
- (BOOL)aut_validateNonnull:(inout id _Nullable * _Nonnull)value forKey:(NSString *)key error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
