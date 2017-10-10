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
    [self postRequest:@[key,@{@"type":type,@"searchSupplier":@"true",@"proAvailable":@"true",@"storeId":[IPCAppManager sharedManager].currentWareHouse.wareHouseId}] RequestMethod:@"bizadmin.getCategoryType" CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryFilterGlassesListWithPage:(NSInteger)page
                            SearchWord:(NSString *)searchWord
                             ClassType:(NSString *)classType
                            SearchType:(NSDictionary *)searchType
                            StartPrice:(double)startPrice
                              EndPrice:(double)endPrice
                              IsTrying:(BOOL)isTrying
                               StoreId:(NSString *)storeId
                          SuccessBlock:(void (^)(id responseValue))success
                          FailureBlock:(void (^)(NSError * error))failure
{
    NSDictionary *params = @{@"start": @(page),
                             @"limit": @(30),
                             @"type": classType,
                             @"keyword": searchWord,
                             @"delFlag":@"false",
                             @"hot":@"false",
                             @"searchSupplier": @"true",
                             @"proAvailable":@"true",
                             @"startPrice":@(startPrice),
                             @"endPrice":endPrice > 0 ? @(endPrice) : @"",
                             @"isTryProduct": isTrying ? @"true":@"false",
                             @"storeId":storeId ? : @""
                             };
    [self postRequest:@[searchType,params] RequestMethod:@"bizadmin.filterTryGlasses" CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryRecommdGlassesWithClassType:(NSString *)classType
                                   Style:(NSString *)style
                            SuccessBlock:(void (^)(id responseValue))success
                            FailureBlock:(void (^)(NSError * error))failure
{
    NSDictionary *params = @{
                             @"type": classType,
                             @"keyword": style,
                             @"isTryProduct": @"true",
                             @"hot":@"false",
                             @"limit": @(9),};
    [self postRequest:params RequestMethod:@"productAdmin.searchTryGlasses" CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryRepositoryWithSuccessBlock:(void (^)(id responseValue))success
                           FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"isRepository":@"true"} RequestMethod:@"bizadmin.listStoreOrRepositoryByCompanyId" CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


@end
