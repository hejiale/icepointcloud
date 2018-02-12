//
//  AFHTTPSessionManager+Extend.m
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "AFHTTPSessionManager+Extend.h"

@implementation AFHTTPSessionManager (Extend)


- (AFHTTPResponseSerializer *)responseSerializer
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFJSONResponseSerializer *responseSerializer  = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    responseSerializer.acceptableContentTypes      = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    responseSerializer.removesKeysWithNullValues = YES;
    self.requestSerializer.timeoutInterval = 30.f;
    self.operationQueue.maxConcurrentOperationCount = 3;
    return responseSerializer;
}

- (NSURLSessionDataTask *)sendRequestWithParams:(IPCRequestParameter *)request
                                      ImageData:(NSData *)imageData
                                      ImageName:(NSString *)imageName
                                    RequestType:(IPCRequestMethod)requestType
                                    CacheEnable:(IPCRequestCache)cacheEnable
                                   SuccessBlock:(void (^)(id responseValue, NSURLSessionDataTask * _Nonnull task))success
                                  ProgressBlock:(void (^)(NSProgress *))progress
                                   FailureBlock:(void (^)(NSError * error, NSURLSessionDataTask * _Nonnull task))failure
{
    NSString * user =  [NSString stringWithFormat:@"%@#%@", [IPCAppManager sharedManager].userName, [IPCAppManager sharedManager].password];
    NSString * method = [request.requestMethod stringByAppendingString:[request.requestParameter JSONString]];
    NSString * userIdInfo = [NSString stringWithFormat:@"%@#%@#", user, method];
    
    NSURLSessionDataTask * urlSessionDataTask = nil;
    
    self.responseSerializer = [self responseSerializer];
    
    void(^successCall)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {        
        [IPCResponseManager parseResponseData:responseObject Complete:^(id responseValue)
         {
             if (cacheEnable == IPCRequestCacheEnable) {
                 [[IPCNetworkCache sharedCache] setHttpCache:responseValue RequestMethod:request.requestMethod parameters:request.parameters];
             }
             if (success){
                 success(responseValue, task);
             }
         } Failed:^(NSError * _Nonnull error) {
             [Bugtags sendException:[NSException exceptionWithName:@"后台请求出错" reason:[userIdInfo stringByAppendingString:error.localizedDescription] userInfo:nil]];
             [Bugly reportError:[NSError errorWithDomain:@"后台请求出错" code:9998 userInfo:@{NSLocalizedDescriptionKey: [userIdInfo stringByAppendingString:error.localizedDescription]}]];
             
             if (failure){
                 failure(error, task);
             }
         }];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    };
    
    void(^progressCall)(NSProgress * _Nonnull uploadProgress) = ^(NSProgress * _Nonnull uploadProgress){
        if (progress && uploadProgress){
            progress(uploadProgress);
        }
    };
    
    void(^failureCall)(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error)
    {
        if ([error code] == NSURLErrorNotConnectedToInternet || [error code] == NSURLErrorTimedOut ) {
            [IPCCommonUI showError:kIPCNotConnectInternetMessage];
        }else{
            [Bugtags sendException:[NSException exceptionWithName:@"网络请求出错" reason:[userIdInfo stringByAppendingString:error.localizedDescription] userInfo:nil]];
            [Bugly reportError:[NSError errorWithDomain:@"网络请求出错" code:9998 userInfo:@{NSLocalizedDescriptionKey: [userIdInfo stringByAppendingString:error.localizedDescription]}]];
            
            if (failure){
                failure(error, task);
            }
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    };
    
    if (requestType == IPCRequestTypeGET){
        urlSessionDataTask = [self GET:[IPC_ProductAPI_URL stringByAppendingString:IPC_ProductAPI_Port]
                            parameters:request.requestParameter
                              progress:nil
                               success:successCall
                               failure:failureCall];
    }else if (requestType == IPCRequestTypePOST){
        urlSessionDataTask = [self POST:[IPC_ProductAPI_URL stringByAppendingString:IPC_ProductAPI_Port]
                             parameters:request.requestParameter
              constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
                              {
                                  if (imageData) {
                                      [formData appendPartWithFileData:imageData name:imageName ? : @""  fileName:@"" mimeType:@"image/png"];
                                  }
                              }
                               progress:progressCall
                                success:successCall
                                failure:failureCall];
    }
    return urlSessionDataTask;
}

@end
