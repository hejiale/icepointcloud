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
+ (void)loadRequest:(id)parameters
      RequestMethod:(NSString *)requestMethod
        RequestType:(IPCRequestType)requestType
        CacheEnable:(IPCRequestCache)cacheEnable
       SuccessBlock:(void (^)(id responseValue))success
       FailureBlock:(void (^)(NSError *error))failure
{
    IPCJoinRequest * request = [[IPCJoinRequest alloc]initWithRequestMethod:requestMethod Parameter:parameters];
    [[IPCHttpRequest sharedClient] sendRequestWithParams:request RequestType:requestType CacheEnable:cacheEnable SuccessBlock:success FailureBlock:failure];
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
    IPCJoinRequest * request = [[IPCJoinRequest alloc]initWithRequestMethod:requestMethod Parameter:parameters];
    [[IPCHttpRequest sharedClient] uploadImageWithParams:request image:imageData imageName:imageName SuccessBlock:success ProgressBlock:uploadProgress FailureBlock:failure];
    
}

@end
