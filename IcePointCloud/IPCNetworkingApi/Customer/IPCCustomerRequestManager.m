//
//  IPCCustomerRequestManager.m
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerRequestManager.h"

@implementation IPCCustomerRequestManager


+ (void)queryUserOptometryListWithCustomID:(NSString *)customID
                              SuccessBlock:(void (^)(id responseValue))success
                              FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"customerId":customID} RequestMethod:CustomerRequest_OptometryList CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)storeUserOptometryInfoWithCustomID:(NSString *)customID
                                   SphLeft:(NSString *)sphLeft
                                  SphRight:(NSString *)sphRight
                                   CylLeft:(NSString *)cylLeft
                                  CylRight:(NSString *)cylRight
                                  AxisLeft:(NSString *)axisLeft
                                 AxisRight:(NSString *)axisRight
                                   AddLeft:(NSString *)addLeft
                                  AddRight:(NSString *)addRight
                       CorrectedVisionLeft:(NSString *)correctedVisionLeft
                      CorrectedVisionRight:(NSString *)correctedVisionRight
                              DistanceLeft:(NSString *)distanceLeft
                             DistanceRight:(NSString *)distanceRight
                                   Purpose:(NSString *)purpose
                                EmployeeId:(NSString *)employeeId
                              EmployeeName:(NSString *)employeeName
                                    Remark:(NSString *)remark
                              SuccessBlock:(void (^)(id responseValue))success
                              FailureBlock:(void (^)(NSError * error))failure
{
    NSDictionary *params = @{@"customerId": customID,
                             @"distanceRight": distanceRight,
                             @"distanceLeft":distanceLeft,
                             @"sphLeft": sphLeft,
                             @"sphRight":sphRight,
                             @"cylLeft": cylLeft,
                             @"cylRight":cylRight,
                             @"axisLeft":axisLeft,
                             @"axisRight":axisRight,
                             @"addLeft":addLeft,
                             @"addRight":addRight,
                             @"correctedVisionLeft":correctedVisionLeft,
                             @"correctedVisionRight":correctedVisionRight,
                             @"purpose":purpose,
                             @"employeeId":employeeId,
                             @"employeeName":employeeName,
                             @"remark":(remark ? : @"")
                             };
    [self postRequest:params RequestMethod:CustomerRequest_SaveNewOptometry CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)saveCustomerInfoWithCustomName:(NSString *)customName
                           CustomPhone:(NSString *)phone
                                Gender:(NSString *)gender
                              Birthday:(NSString *)birthday
                        CustomerTypeId:(NSString *)customerTypeId
                               PhotoId:(NSString *)photoId
                                   Age:(NSString *)age
                            CustomerId:(NSString *)customerId
                          SuccessBlock:(void (^)(id responseValue))success
                          FailureBlock:(void (^)(NSError * error))failure
{
    NSDictionary *params = @{@"customerName": customName,
                             @"customerPhone":phone,
                             @"gender":gender,
                             @"birthday":birthday,
                             @"customerTypeId":customerTypeId,
                             @"photoIdForPos":photoId,
                             @"age":(age ? : @""),
                             @"id":customerId,
                             @"isPos":@"true"};
    [self postRequest:params RequestMethod:CustomerRequest_SaveNewCustomer CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryCustomerDetailInfoWithCustomerID:(NSString *)customerID
                                 SuccessBlock:(void (^)(id responseValue))success
                                 FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"customerId":customerID,@"needMoreInfo":@"true"} RequestMethod:CustomerRequest_CustomerDetail CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryCustomerListWithKeyword:(NSString *)keyword
                                Page:(NSInteger )page
                        SuccessBlock:(void (^)(id responseValue))success
                        FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"keyword":keyword,@"pageNo":@(page),@"maxPageSize":@(30)} RequestMethod:CustomerRequest_CustomerList CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryHistorySellInfoWithPhone:(NSString *)customID
                                 Page:(NSInteger)page
                         SuccessBlock:(void (^)(id responseValue))success
                         FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"pageNo":@(page),@"maxPageSize":@(5),@"customerId":customID} RequestMethod:CustomerRequest_CustomerOrderList CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)queryOrderDetailWithOrderID:(NSString *)orderNumber
                       SuccessBlock:(void (^)(id responseValue))success
                       FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"orderNumber":orderNumber} RequestMethod:CustomerRequest_OrderDetail CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)setDefaultOptometryWithCustomID:(NSString *)customID
                     DefaultOptometryID:(NSString *)defaultOptometryID
                           SuccessBlock:(void (^)(id responseValue))success
                           FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"customerId":customID,@"id":defaultOptometryID} RequestMethod:CustomerRequest_SetCurrentOptometry CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)getMemberLevelWithSuccessBlock:(void (^)(id))success
                          FailureBlock:(void (^)(NSError *))failure
{
    [self postRequest:nil RequestMethod:CustomerRequest_ListMemberLevel CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)getCustomerTypeSuccessBlock:(void (^)(id))success
                       FailureBlock:(void (^)(NSError *))failure
{
    [self postRequest:nil RequestMethod:CustomerRequest_ListCustomerType CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}

@end
