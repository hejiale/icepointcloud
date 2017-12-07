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


+ (void)savePrototyOrderWithSuccessBlock:(void (^)(id responseValue))success
                            FailureBlock:(void (^)(NSError * error))failure
{
    IPCPayOrderParameter * parameter = [[IPCPayOrderParameter alloc]init];
    
    [self postRequest:[parameter prototyOrderParameter] RequestMethod:PayOrderRequest_SavePrototyOrder CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)offerOrderWithOrderId:(NSString *)orderId
                 SuccessBlock:(void (^)(id responseValue))success
                 FailureBlock:(void (^)(NSError * error))failure
{
    IPCPayOrderParameter * parameter = [[IPCPayOrderParameter alloc]init];
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]initWithDictionary:[parameter prototyOrderParameter]];
    [parameters setObject:orderId forKey:@"id"];
    [parameters setObject:@"true" forKey:@"isCheckMember"];
    
    [self postRequest:parameters RequestMethod:PayOrderRequest_OfferOrder CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)authOrderWithOrderNum:(NSString *)orderNum
                 SuccessBlock:(void (^)(id responseValue))success
                 FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"orderNumber":orderNum,@"type":@"FOR_SALES"} RequestMethod:PayOrderRequest_AuthOrder CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)payCashOrderWithOrderNumber:(NSString *)orderNum
                       SuccessBlock:(void (^)(id responseValue))success
                       FailureBlock:(void (^)(NSError *error))failure
{
    IPCPayOrderParameter * parameter = [[IPCPayOrderParameter alloc]init];
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[parameter payTypeInfos] forKey:@"orderPayInfos"];
    [dic setObject:orderNum forKey:@"orderNumber"];
    
    [self postRequest:dic RequestMethod:PayOrderRequest_PayCashOrder CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)queryEmployeWithKeyword:(NSString *)keyword
                   SuccessBlock:(void (^)(id responseValue))success
                   FailureBlock:(void (^)(NSError *error))failure
{
    NSDictionary * responseParameter = @{@"pageNo":@(1),
                                         @"maxPageSize":@(10000),
                                         @"keyWord":keyword,
                                         @"isOnJob":@"false",
                                         @"storeId" : [IPCAppManager sharedManager].currentWareHouse.wareHouseId ? : @""
                                         };
    [self postRequest:responseParameter RequestMethod:PayOrderRequest_EmployeeList CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)queryIntegralRuleWithSuccessBlock:(void (^)(id))success FailureBlock:(void (^)(NSError *))failure
{
    [self postRequest:nil RequestMethod:PayOrderRequest_IntegralRule CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)queryPayListTypeWithSuccessBlock:(void (^)(id responseValue))success
                            FailureBlock:(void (^)(NSError *error))failure
{
    [self postRequest:nil RequestMethod:PayOrderRequest_ListPayType CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

@end
