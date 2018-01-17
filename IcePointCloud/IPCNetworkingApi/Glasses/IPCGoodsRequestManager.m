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
    NSArray * paremeter = @[key,@{
                                  @"type" : type,
                                  @"searchSupplier" : @"true",
                                  @"proAvailable" : @"true",
                                  @"storeId" : [IPCAppManager sharedManager].currentWareHouse.wareHouseId ? : @""}
                            ];
    [self postRequest:paremeter RequestMethod:GoodsRequest_FilterCategory CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryFilterGlassesListWithPage:(NSInteger)page
                                 Limit:(NSInteger)limit
                            SearchWord:(NSString *)searchWord
                             ClassType:(NSString *)classType
                            SearchType:(NSDictionary *)searchType
                            StartPrice:(double)startPrice
                              EndPrice:(double)endPrice
                              IsTrying:(BOOL)isTrying
                               StoreId:(NSString *)storeId
                            StrategyId:(NSString *)strategyId
                                  Code:(NSString *)code
                          SuccessBlock:(void (^)(id responseValue))success
                          FailureBlock:(void (^)(NSError * error))failure
{
    NSDictionary *params = @{@"start": @(page),
                             @"limit": @(limit),
                             @"type": classType,
                             @"keyword": searchWord,
                             @"delFlag":@"false",
                             @"hot":@"false",
                             @"searchSupplier": @"true",
                             @"proAvailable":@"true",
                             @"startPrice":startPrice > 0 ? @(startPrice) : @"",
                             @"endPrice":endPrice > 0 ? @(endPrice) : @"",
                             @"isTryProduct": isTrying ? @"true":@"false",
                             @"storeId":storeId ? : @"",
                             @"priceStrategyId" : strategyId,
                             @"code": code
                             };
    [self postRequest:@[searchType,params] RequestMethod:GoodsRequest_GoodsList CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
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
    [self postRequest:params RequestMethod:GoodsRequest_RecommdList CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}

+  (void)queryPriceStrategyWithSuccessBlock:(void (^)(id))success
                                 FailureBlock:(void (^)(NSError *))failure
{
    [self postRequest:nil RequestMethod:GoodsRequest_PriceStrategy CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}

@end
