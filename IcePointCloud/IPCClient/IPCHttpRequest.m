//
//  IPCHttpRequest.m
//  IcePointCloud
//
//  Created by mac on 9/27/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCHttpRequest.h"

@interface IPCHttpRequest()

@end

@implementation IPCHttpRequest


+ (IPCHttpRequest *)sharedClient{
    static dispatch_once_t token;
    static IPCHttpRequest *_client;
    dispatch_once(&token, ^{
        _client = [[self alloc] init];
    });
    return _client;
}

#pragma mark //AFNetworking Request Method
- (void)callRequestWithParams:(IPCAppendRequestParameter *)request
                    ImageData:(NSData *)imageData
                    ImageName:(NSString *)imageName
                  RequestType:(IPCRequestType)requestType
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
            if (failure){
                failure(HTTPError(kIPCErrorNetworkAlertMessage, NSURLErrorNotConnectedToInternet));
            }
        }
    }else{
        [[AFHTTPSessionManager manager] sendRequestWithParams:request
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
    }
}


- (void)cancelAllRequest
{
    [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
}


@end
