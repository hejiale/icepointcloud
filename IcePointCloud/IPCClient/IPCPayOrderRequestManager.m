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
    //    NSMutableArray * itemParams = [[NSMutableArray alloc]init];
    //    IPCShoppingCart *cart = [IPCShoppingCart sharedCart];
    //
    //    for (int i = 0; i < cart.itemsCount; i++) {
    //        IPCShoppingCartItem *item = [cart itemAtIndex:i];
    //        if (item.selected){
    //            [itemParams addObject:[item paramtersJSONForOrderRequest]];
    //        }
    //    }
    
    //    NSArray * itemParams = @[{@"valueCardId": @"0",
    //        @"othersProductPrice": @"0",
    //        @"othersProductCount": @"0",
    //        @"glassPrice": @(500),
    //        @"accessoryPrice": @"0",
    //        @"glassId": @"7176",
    //        @"othersProductId": @"0",
    //        @"lensCount": @"0",
    //        @"valueCardCount": @"0",
    //        @"lensPrice": @"0",
    //        @"lensId": @"0",
    //        @"glassCount": @(1),
    //        @"accessoryCount": @"0",
    //        @"accessoryId": @"0",
    //        @"valueCardPrice": @"0"
    //    }];
    
    
    NSDictionary * parameters = @{@"customerId":@"785",
                                  @"optometryId":@"386035",
                                  @"addressId":@"8277",
                                  @"orderType": @"FOR_SALES",
                                  @"detailList":@[@{@"valueCardId": @"0",
                                                    @"othersProductPrice": @"0",
                                                    @"othersProductCount": @"0",
                                                    @"glassPrice": @(555),
                                                    @"accessoryPrice": @"0",
                                                    @"glassId": @"7176",
                                                    @"othersProductId": @"0",
                                                    @"lensCount": @"0",
                                                    @"valueCardCount": @"0",
                                                    @"lensPrice": @"0",
                                                    @"lensId": @"0",
                                                    @"afterDiscountPrice": @(500),
                                                    @"glassCount": @(1),
                                                    @"accessoryCount": @"0",
                                                    @"accessoryId": @"0",
                                                    @"valueCardPrice": @"0"
                                                    }],
                                  @"orderRemark":@"",
                                  @"employeeAchievements":@[@{@"achievement":@(100),@"employeeId":@"2"}],
                                  @"optometryId":@"386035",
                                  @"orderFinalPrice":@(20),
                                  @"addressId":@"8277",
                                  @"isAdvancePayment":@"false",
                                  @"payAmount":@(20),
                                  @"payType":@"CASH",
                                  @"integral":@(0),
                                  @"donationAmount":@(480),
                                  @"usebalanceAmount":@(0),
                                  @"payTypeAmount":@(10),
                                  @"payTypeDetails":@[@{@"payTypeInfo":@"abc",@"price":@(10)}]
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

+ (void)getIntegralRulesWithSuccessBlock:(void (^)(id responseValue))success
                            FailureBlock:(void (^)(NSError *error))failure
{
    NSDictionary * parameters = @{
                                  @"isAdvancePayment": @"false",
                                  @"orderType": @"FOR_SALES",
                                  @"integral": @(20),
                                  @"detailList": @[@{
                                      @"valueCardId": @"0",
                                      @"othersProductPrice": @(0),
                                      @"othersProductCount": @(0),
                                      @"glassPrice": @(500),
                                      @"accessoryPrice": @(0),
                                      @"glassId": @"7178",
                                      @"afterDiscountPrice": @(500),
                                      @"othersProductId": @"0",
                                      @"lensCount": @(0),
                                      @"valueCardCount": @(0),
                                      @"lensPrice": @(0),
                                      @"lensId": @"0",
                                      @"glassCount": @(1),
                                      @"accessoryCount": @(0),
                                      @"accessoryId": @"0",
                                      @"valueCardPrice": @(0)
                                  }],
                                  @"customerId": @"785",
                                  };
    
    [self postRequest:parameters RequestMethod:@"integralTradeAdmin.getSaleOrderDetailIntegralList" CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

@end
