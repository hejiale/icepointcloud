//
//  IPCHttpRequest.m
//  IcePointCloud
//
//  Created by mac on 9/27/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCHttpRequest.h"

@interface IPCHttpRequest()

@property (nonatomic, strong) NSMutableArray<NSURLSessionDataTask *> * taskArray;

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

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSMutableArray<NSURLSessionDataTask *> *)taskArray{
    if (!_taskArray) {
        _taskArray = [[NSMutableArray alloc]init];
    }
    return _taskArray;
}

#pragma mark //AFNetworking Request Method
- (void)callRequestWithParams:(IPCRequestParameter *)request
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
        NSURLSessionDataTask * task = [[AFHTTPSessionManager manager] sendRequestWithParams:request
                                                                                  ImageData:imageData
                                                                                  ImageName:imageName
                                                                                RequestType:requestType
                                                                                CacheEnable:cacheEnable
                                                                               SuccessBlock:^(id responseValue, NSURLSessionDataTask * _Nonnull task)
                                       {
                                           __strong typeof(weakSelf) strongSelf = weakSelf;
                                           [strongSelf.taskArray removeObject:task];
                                           
                                           if (success) {
                                               success(responseValue);
                                           }
                                       } ProgressBlock:^(NSProgress *uploadProgress) {
                                           if (progress) {
                                               progress(uploadProgress);
                                           }
                                       } FailureBlock:^(NSError *error, NSURLSessionDataTask * _Nonnull task) {
                                           __strong typeof(weakSelf) strongSelf = weakSelf;
                                           [strongSelf.taskArray removeObject:task];
                                           
                                           if (failure) {
                                               failure(error);
                                           }
                                       }];
        [self.taskArray addObject:task];
        [task resume];
    }
}


- (void)cancelAllRequest
{
    if (self.taskArray) {
        [self.taskArray enumerateObjectsUsingBlock:^(NSURLSessionDataTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) {
                [obj cancel];
            }
        }];
    }
}


@end
