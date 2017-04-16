//
//  IPCPayOrderRequestManager.m
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPayOrderRequestManager.h"

@implementation IPCPayOrderRequestManager


+ (void)offerOrderWithSuccessBlock:(void (^)(id responseValue))success
                      FailureBlock:(void (^)(NSError * error))failure
{
    NSMutableArray * itemParams = [[NSMutableArray alloc]init];
    IPCShoppingCart *cart = [IPCShoppingCart sharedCart];
    
    for (int i = 0; i < cart.itemsCount; i++) {
        IPCShoppingCartItem *item = [cart itemAtIndex:i];
        if (item.selected){
            [itemParams addObject:[item paramtersJSONForOrderRequest]];
        }
    }
    //员工份额
    NSMutableArray * employeeList = [[NSMutableArray alloc]init];
    [[IPCPayOrderMode sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * employeeResultDic = [[NSMutableDictionary alloc]init];
        [employeeResultDic setObject:@(obj.employeeResult) forKey:@"achievement"];
        [employeeResultDic setObject:obj.employe.jobID forKey:@"employeeId"];
        [employeeList addObject:employeeResultDic];
    }];
    
    //其它支付方式
    NSMutableArray * otherTypeList = [[NSMutableArray alloc]init];
    [[IPCPayOrderMode sharedManager].otherPayTypeArray enumerateObjectsUsingBlock:^(IPCOtherPayTypeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * otherResultDic = [[NSMutableDictionary alloc]init];
        [otherResultDic setObject:@(obj.otherPayAmount) forKey:@"price"];
        [otherResultDic setObject:obj.otherPayTypeName forKey:@"payTypeInfo"];
        [otherTypeList addObject:otherResultDic];
    }];
    
    NSDictionary * parameters = @{@"customerId": [IPCCurrentCustomerOpometry sharedManager].currentCustomer.customerID,
                                  @"optometryId": [IPCCurrentCustomerOpometry sharedManager].currentOpometry.optometryID,
                                  @"addressId": [IPCCurrentCustomerOpometry sharedManager].currentAddress.addressID,
                                  @"orderType": @"FOR_SALES",
                                  @"detailList":itemParams,
                                  @"employeeAchievements":employeeList,
                                  @"orderFinalPrice":@([IPCPayOrderMode sharedManager].realTotalPrice),
                                  @"isAdvancePayment":([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypePayAmount ? @"false" : @"true"),
                                  @"payAmount":@([IPCPayOrderMode sharedManager].presellAmount),
                                  @"payType":[IPCPayOrderMode sharedManager].payStyleName,
                                  @"integral":@([IPCPayOrderMode sharedManager].usedPoint),
                                  @"donationAmount":@([IPCPayOrderMode sharedManager].givingAmount),
                                  @"usebalanceAmount":@([IPCPayOrderMode sharedManager].usedBalanceAmount),
                                  @"payTypeAmount":@([IPCPayOrderMode sharedManager].payTypeAmount),
                                  @"payTypeDetails":otherTypeList
                                  };
    [self postRequest:parameters RequestMethod:@"bizadmin.saveSalesOrder" CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
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
                                 Point:(double)point
                          SuccessBlock:(void (^)(id responseValue))success
                          FailureBlock:(void (^)(NSError *error))failure
{
    NSMutableArray * itemParams = [[NSMutableArray alloc]init];
    IPCShoppingCart *cart = [IPCShoppingCart sharedCart];
    
    for (int i = 0; i < cart.itemsCount; i++) {
        IPCShoppingCartItem *item = [cart itemAtIndex:i];
        if (item.selected){
            [itemParams addObject:[item paramtersJSONForOrderRequest]];
        }
    }
    
    NSDictionary * parameters = @{
                                  @"isAdvancePayment": presellStatus,
                                  @"orderType": @"FOR_SALES",
                                  @"integral": @(point),
                                  @"customerId": customID,
                                  @"detailList": itemParams,
                                  };
    
    [self postRequest:parameters RequestMethod:@"integralTradeAdmin.getSaleOrderDetailIntegralList" CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

@end
