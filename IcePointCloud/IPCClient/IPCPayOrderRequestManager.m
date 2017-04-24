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
    
    [self postRequest:[parameter offOrderParameter] RequestMethod:@"bizadmin.saveSalesOrder" CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryEmployeWithKeyword:(NSString *)keyword
                   SuccessBlock:(void (^)(id responseValue))success
                   FailureBlock:(void (^)(NSError *error))failure
{
    NSDictionary * responseParameter = @{@"pageNo":@"1",@"maxPageSize":@"10000",@"keyWord":keyword,@"isOnJob":@"true"};
    [self postRequest:responseParameter RequestMethod:@"employeeadmin.listEmployee" CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)getIntegralRulesWithCustomerID:(NSString *)customID
                       IsPresellStatus:(NSString *)presellStatus
                                 Point:(NSInteger)point
                          SuccessBlock:(void (^)(id responseValue))success
                          FailureBlock:(void (^)(NSError *error))failure
{
    IPCPayOrderParameter * productParameter = [[IPCPayOrderParameter alloc]init];
    
    NSDictionary * parameters = @{
                                  @"isAdvancePayment": presellStatus,
                                  @"orderType": @"FOR_SALES",
                                  @"integral": @(point),
                                  @"customerId": customID,
                                  @"detailList": [productParameter productListParamter],
                                  };
    
    [self postRequest:parameters RequestMethod:@"integralTradeAdmin.getSaleOrderDetailIntegralList" CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)getStatusTradeOrExchangeWithSuccessBlock:(void (^)(id))success
                                    FailureBlock:(void (^)(NSError *))failure{
    [self postRequest:nil RequestMethod:@"integralTradeAdmin.getStatusTradeOrExchange" CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

@end
