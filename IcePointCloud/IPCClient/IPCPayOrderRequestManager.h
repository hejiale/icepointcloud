//
//  IPCPayOrderRequestManager.h
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCRequestManager.h"

@interface IPCPayOrderRequestManager : IPCRequestManager

/**
 *  CONFIRM PAY ORDER
 *
 *  @param customerID
 *  @param opometryID
 *  @param addressID
 *  @param remark
 *  @param payType
 *  @param totalAmount
 *  @param prepaidAmount
 *  @param discountPrice
 *  @param employeID
 *  @param success
 *  @param failure
 */
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
                           FailureBlock:(void (^)(NSError * error))failure;

//***************预售**************//
/**
 Save New PreSalesOrder
 
 @param customerID
 @param opometryID
 @param addressID
 @param remark
 @param totalAmount
 @param preSellPayAmount
 @param success
 @param failure
 */
+ (void)saveNewPreSalesOrderWithRequestCustomerID:(NSString *)customerID
                                       OpometryID:(NSString *)opometryID
                                        AddressID:(NSString *)addressID
                                      OrderRemark:(NSString *)remark
                                      TotalAmount:(double) totalAmount
                                 PreSellPayAmount:(double)preSellPayAmount
                                     SuccessBlock:(void (^)(id responseValue))success
                                     FailureBlock:(void (^)(NSError * error))failure;


/**
 *  QUERY EMPLOYE
 *
 *  @param keyword
 *  @param success
 *  @param failure
 */
+ (void)queryEmployeWithKeyword:(NSString *)keyword
                   SuccessBlock:(void (^)(id responseValue))success
                   FailureBlock:(void (^)(NSError *error))failure;

@end
