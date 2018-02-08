//
//  IPCHttpRequest.m
//  IcePointCloud
//
//  Created by mac on 9/27/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCHttpRequest.h"


@implementation IPCHttpRequest

#pragma mark //AFNetworking Request Method
+ (void)callRequestWithParams:(IPCRequestParameter *)request
                    ImageData:(NSData *)imageData
                    ImageName:(NSString *)imageName
                  RequestType:(IPCRequestMethod)requestType
                  CacheEnable:(IPCRequestCache)cacheEnable
                 SuccessBlock:(void (^)(id responseValue))success
                ProgressBlock:(void (^)(NSProgress *))progress
                 FailureBlock:(void (^)(NSError * error))failure
{
    //Access to the cache read cache used when no network or network error
    id cache = [[IPCNetworkCache sharedCache] httpCacheForRequestMethod:request.requestMethod parameters:request.parameters];
    
    AFNetworkReachabilityStatus status = [IPCReachability manager].currentNetStatus;
    
    if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
        if (cache && IPCRequestCacheEnable) {
            if (success){
                success(cache);
            }
        }else{
            [IPCCommonUI showError:@"连接服务出错了，请检查当前网络环境!"];
        }
    }else{
        __weak typeof(self) weakSelf = self;
        __block NSURLSessionDataTask * task = [[AFHTTPSessionManager manager] sendRequestWithParams:request
                                                                                          ImageData:imageData
                                                                                          ImageName:imageName
                                                                                        RequestType:requestType
                                                                                        CacheEnable:cacheEnable
                                                                                       SuccessBlock:^(id responseValue, NSURLSessionDataTask * _Nonnull task)
                                               {
                                                   if (success) {
                                                       success(responseValue);
                                                   }
                                               } ProgressBlock:^(NSProgress *uploadProgress) {
                                                   if (progress) {
                                                       progress(uploadProgress);
                                                   }
                                               } FailureBlock:^(NSError *error, NSURLSessionDataTask * _Nonnull task) {
                                                   if (failure) {
                                                       failure(error);
                                                   }
                                               }];
        [task resume];
    }
}


+ (void)cancelAllRequest
{
    @synchronized(self) {
        [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
    }
}


@end
