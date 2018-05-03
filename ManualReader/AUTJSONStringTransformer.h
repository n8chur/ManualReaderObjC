//
//  AUTJSONStringTransformer.h
//  ManualReader
//
//  Created by Westin Newell on 11/22/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import Mantle;

NS_ASSUME_NONNULL_BEGIN

/// Transforms a JSON string into a JSON object or nil if the string is
/// empty/null.
///
/// See +[NSJSONSerialization JSONObjectWithData:options:error:] for more
/// information about the type of object returned.
@interface AUTJSONStringTransformer : NSValueTransformer <MTLTransformerErrorHandling>

@end

NS_ASSUME_NONNULL_END
