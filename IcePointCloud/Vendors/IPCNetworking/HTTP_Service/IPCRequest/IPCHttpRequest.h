//
//  IPCHttpRequest.h
//  IcePointCloud
//
//  Created by mac on 9/27/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCRequestParameter.h"


@interface IPCHttpRequest : NSObject


+ (IPCHttpRequest *)sharedClient;

/**
 CALL REQUEST

 @param request
 @param imageData
 @param imageName
 @param requestType
 @param cacheEnable
 @param success
 @param progress 
 @param failure
 */
- (void)callRequestWithParams:(IPCRequestParameter *)request
                    ImageData:(NSData *)imageData
                    ImageName:(NSString *)imageName
                  RequestType:(IPCRequestMethod)requestType
                  CacheEnable:(IPCRequestCache)cacheEnable
                 SuccessBlock:(void (^)(id responseValue))success
                ProgressBlock:(void (^)(NSProgress *))progress
                 FailureBlock:(void (^)(NSError * error))failure;

/**
 *  CANCEL REQUEST
 */
- (void)cancelAllRequest;


@end
