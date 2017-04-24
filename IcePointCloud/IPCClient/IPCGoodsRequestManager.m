//
//  IPCGoodsRequestManager.m
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCGoodsRequestManager.h"

@implementation IPCGoodsRequestManager


+ (void)getAllCateTypeWithType:(NSString *)type
                     FilterKey:(NSDictionary *)key
                  SuccessBlock:(void (^)(id responseValue))success
                  FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@[key,@{@"type":type,@"searchSupplier":@"true",@"proAvailable":@"true"}] RequestMethod:@"bizadmin.getCategoryType" CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryFilterGlassesListWithPage:(NSInteger)page
                            SearchWord:(NSString *)searchWord
                             ClassType:(NSString *)classType
                            SearchType:(NSDictionary *)searchType
                            StartPrice:(double)startPrice
                              EndPrice:(double)endPrice
                                 IsHot:(BOOL)isHot
                             IsTrying:(BOOL)isTrying
                          SuccessBlock:(void (^)(id responseValue))success
                          FailureBlock:(void (^)(NSError * error))failure
{
    NSDictionary *params = @{@"start": @(page),
                             @"limit": @(9),
                             @"type": classType,
                             @"keyword": searchWord,
                             @"delFlag":@"false",
                             @"hot":isHot? @"true":@"false",
                             @"searchSupplier": @"true",
                             @"proAvailable":@"true",
                             @"startPrice":@(startPrice),
                             @"endPrice":endPrice > 0 ? @(endPrice) : @"",
                             @"isTryProduct": isTrying ? @"true":@"false"};
    [self postRequest:@[searchType,params] RequestMethod:@"bizadmin.filterTryGlasses" CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)searchCustomsizedContactLensWithPage:(NSInteger)page
                                SuccessBlock:(void (^)(id responseValue))success
                                FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"pageNo": @(page) , @"maxPageSize":@(9), @"listType":@"AVAILABLE", @"customizedProdType":@"CUSTOMIZED_CONTACT_LENS"} RequestMethod:@"productAdmin.listCustomizedProd" CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)searchCustomsizedLensWithPage:(NSInteger)page
                                SuccessBlock:(void (^)(id responseValue))success
                                FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"pageNo": @(page) ,@"maxPageSize":@(9), @"listType":@"AVAILABLE", @"customizedProdType":@"CUSTOMIZED_LENS"} RequestMethod:@"productAdmin.listCustomizedProd" CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


@end
