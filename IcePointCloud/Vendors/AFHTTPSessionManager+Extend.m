//
//  AFHTTPSessionManager+Extend.m
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "AFHTTPSessionManager+Extend.h"

@implementation AFHTTPSessionManager (Extend)


- (NSURLSessionDataTask *)sendRequestWithParams:(IPCJoinRequest *)request
                                         UserID:(NSString *)userID
                                      ImageData:(NSData *)imageData
                                      ImageName:(NSString *)imageName
                                    RequestType:(IPCRequestType)requestType
                                    CacheEnable:(IPCRequestCache)cacheEnable
                                   SuccessBlock:(void (^)(id responseValue, NSURLSessionDataTask * _Nonnull task))success
                                  ProgressBlock:(void (^)(NSProgress *))progress
                                   FailureBlock:(void (^)(NSError * error, NSURLSessionDataTask * _Nonnull task))failure
{
    NSURLSessionDataTask * urlSessionDataTask = nil;
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    responseSerializer.removesKeysWithNullValues = YES;
    self.responseSerializer = responseSerializer;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    void(^successCall)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        [IPCResponse parseResponseData:responseObject Complete:^(id responseValue)
         {
             if (cacheEnable == IPCRequestCacheEnable) {
                 [[IPCNetworkCache sharedCache] setHttpCache:responseValue RequestMethod:request.requestMethod parameters:request.parameters UserID:userID];
             }else{
                 [[IPCNetworkCache sharedCache] removeCacheForRequestMethod:request.requestMethod parameters:request.parameters UserID:userID];
             }
             if (success)
                 success(responseValue, task);
             
         } Failed:^(NSError * _Nonnull error) {
             if (failure)
                 failure(error, task);
         }];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    };
    
    void(^progressCall)(NSProgress * _Nonnull uploadProgress) = ^(NSProgress * _Nonnull uploadProgress){
        if (progress && uploadProgress)
            progress(uploadProgress);
    };
    
    void(^failureCall)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
    {
        NSLog(@"-------Service Error  %@",error.localizedDescription);
        if (failure)
            failure([NSError errorWithDomain:NSCocoaErrorDomain code:error.code userInfo:@{kIPCNetworkErrorMessage:error.localizedDescription}], task);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    };
    
    if (requestType == IPCRequestTypeGet)
    {
        urlSessionDataTask = [self GET:IPC_ProductAPI_URL
                            parameters:request.requestParameter
                              progress:nil
                               success:successCall
                               failure:failureCall];
    }else if (requestType == IPCRequestTypePost)
    {
        urlSessionDataTask = [self POST:IPC_ProductAPI_URL
                             parameters:request.requestParameter
                               progress:nil
                                success:successCall
                                failure:failureCall];
    }else if (requestType == IPCRequestTypeUpload)
    {
        urlSessionDataTask = [self POST:IPC_ProductAPI_URL
                             parameters:request.requestParameter
              constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
                              {
                                  [formData appendPartWithFileData:imageData name:imageName fileName:@"" mimeType:@"image/png"];
                              }
                               progress:progressCall
                                success:successCall
                                failure:failureCall];
    }
    [urlSessionDataTask resume];
    return urlSessionDataTask;
}

@end
