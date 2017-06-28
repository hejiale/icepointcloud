//
//  IPCRequestManager.m
//  IcePointCloud
//
//  Created by mac on 16/6/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCRequest.h"

@implementation IPCRequest

#pragma mark //POST REQUEST
+ (void)postRequest:(id)parameters
      RequestMethod:(NSString *)requestMethod
        CacheEnable:(IPCRequestCache)cacheEnable
       SuccessBlock:(void (^)(id responseValue))success
       FailureBlock:(void (^)(NSError *error))failure
{
    IPCAppendRequestParameter * request = [[IPCAppendRequestParameter alloc]initWithRequestMethod:requestMethod Parameter:parameters];
    [[IPCHttpRequest sharedClient] callRequestWithParams:request ImageData:nil ImageName:nil RequestType:IPCRequestTypePost CacheEnable:cacheEnable SuccessBlock:success ProgressBlock:nil FailureBlock:failure];
}


#pragma mark //GET REQUEST
+ (void)getRequest:(id)parameters
     RequestMethod:(NSString *)requestMethod
       CacheEnable:(IPCRequestCache)cacheEnable
      SuccessBlock:(void (^)(id responseValue))success
      FailureBlock:(void (^)(NSError *error))failure
{
    IPCAppendRequestParameter * request = [[IPCAppendRequestParameter alloc]initWithRequestMethod:requestMethod Parameter:parameters];
    [[IPCHttpRequest sharedClient] callRequestWithParams:request ImageData:nil ImageName:nil RequestType:IPCRequestTypeGet CacheEnable:cacheEnable SuccessBlock:success ProgressBlock:nil FailureBlock:failure];
}


#pragma mark //UPLOAD IMAGE
+ (void)uploadImageWithImageName:(NSString *)imageName
                       ImageData:(NSData *)imageData
                      Parameters:(id)parameters
                   RequestMethod:(NSString *)requestMethod
                    SuccessBlock:(void (^)(id responseValue))success
                   ProgressBlock:(void (^)(NSProgress *))uploadProgress
                    FailureBlock:(void (^)(NSError *error))failure
{
    IPCAppendRequestParameter * request = [[IPCAppendRequestParameter alloc]initWithRequestMethod:requestMethod Parameter:parameters];
    [[IPCHttpRequest sharedClient] callRequestWithParams:request ImageData:imageData ImageName:imageName RequestType:IPCRequestTypeUpload CacheEnable: IPCRequestCacheDisEnable SuccessBlock:success ProgressBlock:uploadProgress FailureBlock:failure];
}

@end
