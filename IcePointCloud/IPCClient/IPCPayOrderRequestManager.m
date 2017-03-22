//
//  IPCPayOrderRequestManager.m
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPayOrderRequestManager.h"

@implementation IPCPayOrderRequestManager


+ (void)offerOrderWithRequestCustomerID:(NSString *)customerID
                             OpometryID:(NSString *)opometryID
                              AddressID:(NSString *)addressID
                            OrderRemark:(NSString *)remark
                                PayType:(NSString *)payType
                            TotalAmount:(double) totalAmount
                          PrepaidAmount:(double)prepaidAmount
                          DiscountPrice:(double)discountPrice
                              EmployeID:(NSString *)employeID
                           SuccessBlock:(void (^)(id responseValue))success
                           FailureBlock:(void (^)(NSError * error))failure
{
    NSMutableArray * itemParams = [[NSMutableArray alloc]init];
    IPCShoppingCart *cart = [IPCShoppingCart sharedCart];
    
    for (int i = 0; i < cart.itemsCount; i++) {
        IPCShoppingCartItem *item = [cart itemAtIndex:i];
        if (item.selected)
            [itemParams addObject:[item paramtersJSONForOrderRequest]];
    }
    
    NSDictionary * parameters = @{@"customerId":customerID,
                                  @"optometryId":opometryID,
                                  @"addressId":addressID,
                                  @"orderDetail":itemParams,
                                  @"orderRemark":remark,
                                  @"payType":payType,
                                  @"payAmount":[IPCPayOrderMode sharedManager].payType == IPCOrderPayTypeInstallment ? @(prepaidAmount) : @(0),
                                  @"isAdvancePayment":[IPCPayOrderMode sharedManager].payType == IPCOrderPayTypeInstallment ? @"true" : @"false",
                                  @"afterDiscountPrice":[IPCPayOrderMode sharedManager].isSelectEmploye ? @(discountPrice) : @(totalAmount),
                                  @"employeeId":employeID
                                  };
    [self loadRequest:parameters RequestMethod:@"bizadmin.brushedSaveSalesOrder" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

//***************预售**************//
+ (void)saveNewPreSalesOrderWithRequestCustomerID:(NSString *)customerID
                                       OpometryID:(NSString *)opometryID
                                        AddressID:(NSString *)addressID
                                      OrderRemark:(NSString *)remark
                                      TotalAmount:(double) totalAmount
                                 PreSellPayAmount:(double)preSellPayAmount
                                     SuccessBlock:(void (^)(id responseValue))success
                                     FailureBlock:(void (^)(NSError * error))failure
{
    NSMutableArray * itemParams = [[NSMutableArray alloc]init];
    IPCShoppingCart *cart = [IPCShoppingCart sharedCart];
    
    for (int i = 0; i < cart.itemsCount; i++) {
        IPCShoppingCartItem *item = [cart itemAtIndex:i];
        if (item.selected)
            [itemParams addObject:[item paramtersJSONForOrderRequest]];
    }
    
    NSDictionary * parameters = @{@"customerId":customerID,
                                  @"optometryId":opometryID,
                                  @"addressId":addressID,
                                  @"orderDetail":itemParams,
                                  @"orderRemark":remark,
                                  @"payAmount":@(totalAmount),
                                  @"presellPayAmount":@(preSellPayAmount)};
    [self loadRequest:parameters RequestMethod:@"bizadmin.saveSalesOrderFromPresellOrder" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryEmployeWithKeyword:(NSString *)keyword
                   SuccessBlock:(void (^)(id responseValue))success
                   FailureBlock:(void (^)(NSError *error))failure
{
    NSDictionary * responseParameter = @{@"pageNo":@"1",@"maxPageSize":@"10000",@"keyWord":keyword,@"isOnJob":@"true"};
    [self loadRequest:responseParameter RequestMethod:@"employeeadmin.listEmployee" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

@end
