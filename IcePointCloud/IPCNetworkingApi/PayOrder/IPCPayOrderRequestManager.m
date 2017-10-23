//
//  IPCPayOrderRequestManager.m
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPayOrderRequestManager.h"
#import "IPCPayOrderParameter.h"

@implementation IPCPayOrderRequestManager


+ (void)offerOrderWithSuccessBlock:(void (^)(id responseValue))success
                      FailureBlock:(void (^)(NSError * error))failure
{
    IPCPayOrderParameter * parameter = [[IPCPayOrderParameter alloc]init];
    
    [self postRequest:[parameter offOrderParameter] RequestMethod:PayOrderRequest_SaveNewOrder CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryEmployeWithKeyword:(NSString *)keyword
                   SuccessBlock:(void (^)(id responseValue))success
                   FailureBlock:(void (^)(NSError *error))failure
{
    NSDictionary * responseParameter = @{@"pageNo":@(1),
                                         @"maxPageSize":@(10000),
                                         @"keyWord":keyword,
                                         @"isOnJob":@"true",
                                         @"storeId" : [IPCAppManager sharedManager].currentWareHouse.wareHouseId ? : @""
                                         };
    [self postRequest:responseParameter RequestMethod:PayOrderRequest_EmployeeList CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)getIntegralRulesWithCustomerID:(NSString *)customID
                                 Point:(NSInteger)point
                          SuccessBlock:(void (^)(id responseValue))success
                          FailureBlock:(void (^)(NSError *error))failure
{
    IPCPayOrderParameter * productParameter = [[IPCPayOrderParameter alloc]init];
    
    NSDictionary * parameters = @{
                                  @"orderType": @"FOR_SALES",
                                  @"integral": @(point),
                                  @"customerId": customID,
                                  @"detailList": [productParameter productListParamter]
                                  };
    
    [self postRequest:parameters RequestMethod:PayOrderRequest_Integral CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

@end
