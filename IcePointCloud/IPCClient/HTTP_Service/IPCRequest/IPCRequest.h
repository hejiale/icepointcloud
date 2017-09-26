//
//  IPCRequestManager.h
//  IcePointCloud
//
//  Created by mac on 16/6/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCRequest : NSObject

/**
 Post  Request
 
 @param parameters
 @param requestMethod
 @param requestType
 @param cacheEnable
 @param success
 @param failure
 */
+ (void)postRequest:(id)parameters
      RequestMethod:(NSString *)requestMethod
        CacheEnable:(IPCRequestCache)cacheEnable
       SuccessBlock:(void (^)(id responseValue))success
       FailureBlock:(void (^)(NSError *error))failure;


/**
 Get Request
 
 @param parameters
 @param requestMethod
 @param requestType
 @param cacheEnable
 @param success
 @param failure
 */
+ (void)getRequest:(id)parameters
     RequestMethod:(NSString *)requestMethod
       CacheEnable:(IPCRequestCache)cacheEnable
      SuccessBlock:(void (^)(id responseValue))success
      FailureBlock:(void (^)(NSError *error))failure;


/**
 Upload Image Request
 
 @param imageName
 @param imageData
 @param parameters
 @param requestMethod
 @param success
 @param uploadProgress
 @param failure
 */
+ (void)uploadImageWithImageName:(NSString *)imageName
                       ImageData:(NSData *)imageData
                      Parameters:(id)parameters
                   RequestMethod:(NSString *)requestMethod
                    SuccessBlock:(void (^)(id responseValue))success
                   ProgressBlock:(void (^)(NSProgress *))uploadProgress
                    FailureBlock:(void (^)(NSError *error))failure;


@end
