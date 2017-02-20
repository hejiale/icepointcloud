//
//  IPCClient.m
//  IcePointCloud
//
//  Created by mac on 9/27/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCClient.h"

@interface IPCClient()

@property (nonatomic, strong) NSMutableArray<NSURLSessionDataTask *>  *  allTasks;

@end

@implementation IPCClient


+ (IPCClient *)sharedClient{
    static dispatch_once_t token;
    static IPCClient *_client;
    dispatch_once(&token, ^{
        _client = [[self alloc] init];
    });
    return _client;
}


- (NSMutableArray<NSURLSessionDataTask *> *)allTasks{
    if (!_allTasks)
        _allTasks = [[NSMutableArray alloc]init];
    return _allTasks;
}


- (void)sendRequestWithParams:(IPCRequest *)request
                  RequestType:(IPCRequestType)requestType
                  CacheEnable:(IPCRequestCache)cacheEnable
                 SuccessBlock:(void (^)(id responseValue))success
                 FailureBlock:(void (^)(NSError * error))failure
{
    [self callRequestWithParams:request ImageData:nil ImageName:nil RequestType:requestType CacheEnable:cacheEnable SuccessBlock:success ProgressBlock:nil FailureBlock:failure];
}


- (void)uploadImageWithParams:(IPCRequest *)request
                        image:(NSData *)imageData
                    imageName:(NSString *)imageName
                 SuccessBlock:(void (^)(id responseValue))success
                ProgressBlock:(void (^)(NSProgress *))uploadProgress
                 FailureBlock:(void (^)(NSError * error))failure
{
    [self callRequestWithParams:request ImageData:imageData  ImageName:imageName  RequestType:IPCRequestTypeUpload CacheEnable:IPCRequestCacheDisEnable  SuccessBlock:success ProgressBlock:uploadProgress FailureBlock:failure];
}


#pragma mark //AFNetworking Request Method
- (void)callRequestWithParams:(IPCRequest *)request
                    ImageData:(NSData *)imageData
                    ImageName:(NSString *)imageName
                  RequestType:(IPCRequestType)requestType
                  CacheEnable:(IPCRequestCache)cacheEnable
                 SuccessBlock:(void (^)(id responseValue))success
                ProgressBlock:(void (^)(NSProgress *))progress
                 FailureBlock:(void (^)(NSError * error))failure
{
    //Access to the cache read cache used when no network or network error
    NSString * userID = [IPCAppManager sharedManager].profile.user.userID;
    id cache = [[IPCNetworkCache sharedCache] httpCacheForRequestMethod:request.requestMethod parameters:request.parameters UserID:userID];
    
    AFNetworkReachabilityStatus status = [IPCReachability manager].currentNetStatus;
    
    if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
        if (cache && IPCRequestCacheEnable) {
            if (success)
                success(cache);
        }else{
            if (failure)
                failure([NSError errorWithDomain:NSCocoaErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:@{kIPCNetworkErrorMessage:kIPCErrorNetworkAlertMessage}]);
        }
    }else{
        NSURLSessionDataTask * urlSessionDataTask = [[AFHTTPSessionManager manager] sendRequestWithParams:request
                                                                                                   UserID:userID
                                                                                                ImageData:imageData
                                                                                                ImageName:imageName
                                                                                              RequestType:requestType
                                                                                              CacheEnable:cacheEnable
                                                                                             SuccessBlock:^(id responseValue, NSURLSessionDataTask * _Nonnull task)
                                                     {
                                                         if (success) {
                                                             success(responseValue);
                                                         }
                                                         [self.allTasks removeObject:task];
                                                         
                                                     } ProgressBlock:^(NSProgress *uploadProgress) {
                                                         if (progress) {
                                                             progress(uploadProgress);
                                                         }
                                                     } FailureBlock:^(NSError *error, NSURLSessionDataTask * _Nonnull task) {
                                                         if (failure) {
                                                             failure(error);
                                                         }
                                                         [self.allTasks removeObject:task];
                                                     }];
        
        if (urlSessionDataTask)[self.allTasks addObject:urlSessionDataTask];
    }
}


- (void)cancelAllRequest
{
    [self.allTasks enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
        [task cancel];
    }];
    [self.allTasks removeAllObjects];
}


@end
