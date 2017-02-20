//
//  IPCClient.h
//  IcePointCloud
//
//  Created by mac on 9/27/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCRequest.h"


@interface IPCClient : NSObject


+ (IPCClient *)sharedClient;


/**
 *  SEND REQUEST
 *
 *  @param request
 *  @param cacheType
 *  @param requestType
 *  @param success
 *  @param failure
 */
- (void)sendRequestWithParams:(IPCRequest *)request
                  RequestType:(IPCRequestType)requestType
                  CacheEnable:(IPCRequestCache)cacheEnable
                 SuccessBlock:(void (^)(id responseValue))success
                 FailureBlock:(void (^)(NSError * error))failure;

/**
 *  UPLOAD IMAGE
 *
 *  @param requestParams
 *  @param imageData
 *  @param success
 *  @param uploadProgress
 *  @param failure
 */
- (void)uploadImageWithParams:(IPCRequest *)request
                        image:(NSData *)imageData
                    imageName:(NSString *)imageName
                 SuccessBlock:(void (^)(id responseValue))success
                ProgressBlock:(void (^)(NSProgress *))uploadProgress
                 FailureBlock:(void (^)(NSError * error))failure;

/**
 *  CANCEL REQUEST
 */
- (void)cancelAllRequest;


@end
