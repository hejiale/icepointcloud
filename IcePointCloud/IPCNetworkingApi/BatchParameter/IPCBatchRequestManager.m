//
//  IPCBatchRequestManager.m
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCBatchRequestManager.h"

@implementation IPCBatchRequestManager


+ (void)queryBatchLensProductsStockWithLensID:(NSString *)lenID
                                 SuccessBlock:(void (^)(id responseValue))success
                                 FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:lenID RequestMethod:BatchRequest_LensStock  CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryBatchReadingProductsStockWithLensID:(NSString *)lenID
                                    SuccessBlock:(void (^)(id responseValue))success
                                    FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:lenID RequestMethod:BatchRequest_ReadingGlassesStock  CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryBatchContactProductsStockWithLensID:(NSString *)lenID
                                    SuccessBlock:(void (^)(id responseValue))success
                                    FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:lenID RequestMethod:BatchRequest_ContactLensGlassesStock  CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryContactGlassBatchSpecification:(NSArray *)contactLensID
                               SuccessBlock:(void (^)(id responseValue))success
                               FailureBlock:(void (^)(NSError *error))failure
{
    NSString * contactLens = [contactLensID componentsJoinedByString:@","];
    [self postRequest:contactLens RequestMethod:BatchRequest_ContactLensSpecification  CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)queryAccessoryBatchSpecification:(NSString *)lenID
                            SuccessBlock:(void (^)(id responseValue))success
                            FailureBlock:(void (^)(NSError *error))failure
{
    [self postRequest:lenID RequestMethod:BatchRequest_AccessorySpecification  CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)queryBatchLensConfig:(NSString *)glassType
                SuccessBlock:(void (^)(id responseValue))success
                FailureBlock:(void (^)(NSError *error))failure
{
    [self postRequest:@{@"configurationType":glassType} RequestMethod:BatchRequest_LensConfig CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


@end
