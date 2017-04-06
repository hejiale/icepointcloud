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
                          SuccessBlock:(void (^)(id responseValue))success
                          FailureBlock:(void (^)(NSError * error))failure
{
    NSDictionary *params = @{@"start": @(page * 9),
                             @"limit": @(9),
                             @"type": classType,
                             @"keyword": searchWord,
                             @"hot":isHot? @"true":@"false",
                             @"searchSupplier": @"true",
                             @"proAvailable":@"true",
                             @"startPrice":@(startPrice),
                             @"endPrice":endPrice > 0 ? @(endPrice) : @""};
    [self postRequest:@[searchType,params] RequestMethod:@"bizadmin.filterTryGlasses" CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}

@end
