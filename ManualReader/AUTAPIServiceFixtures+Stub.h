//
//  AUTAPIServiceFixtures+Stub.h
//  ManualReader
//
//  Created by Westin Newell on 5/5/17.
//  Copyright © 2017 Automatic Labs. All rights reserved.
//

@import Nocilla;

#import "AUTAPIServiceFixtures.h"

NS_ASSUME_NONNULL_BEGIN

@interface AUTAPIServiceFixtures (Stub)

- (LSStubResponseDSL *)stubRequestWithMethod:(NSString *)method pathTemplate:(NSString *)pathTemplate statusCode:(NSInteger)statusCode;

- (LSStubResponseDSL *)stubRequestNillingInnerPageCursorsWithMethod:(NSString *)method pathTemplate:(NSString *)pathTemplate statusCode:(NSInteger)statusCode;

/// Additionally nils the inner page cursors.
- (NSArray<LSStubResponseDSL *> *)stubPaginatedOutterNextPageRequestsWithMethod:(NSString *)method pathTemplate:(NSString *)pathTemplate statusCode:(NSInteger)statusCode;

/// Stubs an initial request at the provided endpoint with a response object
/// with a page (which can be found at the pageKeyPath) which has a nil previous
/// cursor, and a next cursor with a path that matches the
/// paginationEndpointPath and a test_cursor query parameter. The API respose
/// object returned at the paginationEndpointPath will return a page which has
/// a nil next cursor and a previous cursor that matches the original endpoint.
///
/// This method is useful when the initial response object's type is different
/// from the pagination API's response object (e.g. the initial response returns
/// an object that has a property which is paginated).
- (NSArray<LSStubResponseDSL *> *)stubPaginatedNextPageRequestsWithMethod:(NSString *)method pathTemplate:(NSString *)pathTemplate statusCode:(NSInteger)statusCode pageKeyPath:(NSString *)pageKeyPath paginationEndpointPath:(NSString *)paginationEndpointPath;

/// Modifies the provided fixture such that all inner item's have a next cursor
/// next cursor with a stubbed request to fetch a duplicate of that inner item.
- (NSArray<LSStubResponseDSL *> *)stubPaginatedInnerNextPageRequestsWithMethod:(NSString *)method pathTemplate:(NSString *)pathTemplate statusCode:(NSInteger)statusCode;

@end

NS_ASSUME_NONNULL_END
