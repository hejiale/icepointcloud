//
//  AFHTTPSessionManager+Extend.h
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//


@interface AFHTTPSessionManager (Extend)


/**
 Send Request

 @param request
 @param userID
 @param imageData
 @param imageName
 @param requestType
 @param cacheEnable
 @param success
 @param progress
 @param failure
 @return 
 */
- (NSURLSessionDataTask *)sendRequestWithParams:(IPCRequest *)request
                                         UserID:(NSString *)userID
                                      ImageData:(NSData *)imageData
                                      ImageName:(NSString *)imageName
                                    RequestType:(IPCRequestType)requestType
                                    CacheEnable:(IPCRequestCache)cacheEnable
                                   SuccessBlock:(void (^)(id responseValue, NSURLSessionDataTask * _Nonnull task))success
                                  ProgressBlock:(void (^)(NSProgress *))progress
                                   FailureBlock:(void (^)(NSError * error, NSURLSessionDataTask * _Nonnull task))failure;

@end
