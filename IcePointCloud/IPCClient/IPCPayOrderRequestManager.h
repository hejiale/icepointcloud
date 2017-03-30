//
//  IPCPayOrderRequestManager.h
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCRequest.h"

@interface IPCPayOrderRequestManager : IPCRequest

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
