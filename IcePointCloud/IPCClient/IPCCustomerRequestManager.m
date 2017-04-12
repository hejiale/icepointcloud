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
                                      Page:(NSInteger)page
                              SuccessBlock:(void (^)(id responseValue))success
                              FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"customerId":customID,@"pageNo":@(page),@"maxPageSize":@(5)} RequestMethod:@"customerAdmin.listOptometry" CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
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
                             @"employeeName":employeeName};
    [self postRequest:params RequestMethod:@"customerAdmin.saveOptometry" CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)saveCustomerInfoWithCustomName:(NSString *)customName
                           CustomPhone:(NSString *)phone
                                Gender:(NSString *)gender
                                   Age:(NSString *)age
                                 Email:(NSString *)email
                              Birthday:(NSString *)birthday
                                Remark:(NSString *)remark
                             PhotoUUID:(NSString *)photoUUID
                              Distance:(NSString *)distance
                               SphLeft:(NSString *)sphLeft
                              SphRight:(NSString *)sphRight
                               CylLeft:(NSString *)cylLeft
                              CylRight:(NSString *)cylRight
                              AxisLeft:(NSString *)axisLeft
                             AxisRight:(NSString *)axisRight
                               AddLeft:(NSString *)addLeft
                              AddRight:(NSString *)addRight
                         CorrectedLeft:(NSString *)correctedLeft
                        CorrectedRight:(NSString *)correctedRight
                           ContactName:(NSString *)contactName
                         ContactGender:(NSString *)contactGender
                          ContactPhone:(NSString *)contactPhone
                        ContactAddress:(NSString *)contactAddress
                          SuccessBlock:(void (^)(id responseValue))success
                          FailureBlock:(void (^)(NSError * error))failure
{
    NSDictionary *params = @{@"customerName": customName,
                             @"customerPhone":phone,
                             @"genderString":gender,
                             @"age":age,
                             @"email":email,
                             @"birthday":birthday,
                             @"remark":remark,
                             @"photo_uuid":photoUUID,
                             @"distance":distance,
                             @"sphLeft":sphLeft,
                             @"sphRight":sphRight,
                             @"cylLeft":cylLeft,
                             @"cylRight":cylRight,
                             @"axisLeft":axisLeft,
                             @"axisRight":axisRight,
                             @"addLeft":addLeft,
                             @"addRight":addRight,
                             @"correctedVisionLeft":correctedLeft,
                             @"correctedVisionRight":correctedRight,
                             @"contactorName":contactName,
                             @"contactorGengerString":contactGender,
                             @"contactorPhone":contactPhone,
                             @"contactorAddress":contactAddress};
    [self postRequest:params RequestMethod:@"customerAdmin.saveCustomerInfo" CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryCustomerDetailInfoWithCustomerID:(NSString *)customerID
                                 SuccessBlock:(void (^)(id responseValue))success
                                 FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"customerId":customerID} RequestMethod:@"customerAdmin.getCusomerInfo" CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryCustomerListWithKeyword:(NSString *)keyword
                        SuccessBlock:(void (^)(id responseValue))success
                        FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"keyword":keyword} RequestMethod:@"customerAdmin.listAllCustomer" CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)setCurrentOptometryWithCustomID:(NSString *)customID
                            OptometryID:(NSString *)optometryID
                           SuccessBlock:(void (^)(id responseValue))success
                           FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"customerId":customID,@"optometryId":optometryID} RequestMethod:@"customerAdmin.setCurrentOptometry" CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryHistorySellInfoWithPhone:(NSString *)phone
                                 Page:(NSInteger)page
                         SuccessBlock:(void (^)(id responseValue))success
                         FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"pageNo":@(page),@"maxPageSize":@(5),@"customerPhone":phone} RequestMethod:@"customerAdmin.listHistoryOrders" CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)saveNewCustomerAddressWithAddressID:(NSString *)addressID
                                   CustomID:(NSString *)customID
                                ContactName:(NSString *)contactName
                                     Gender:(NSString *)gender
                                      Phone:(NSString *)phone
                                    Address:(NSString *)address
                               SuccessBlock:(void (^)(id responseValue))success
                               FailureBlock:(void (^)(NSError * error))failure
{
    NSDictionary * parameters = @{@"id":addressID,
                                  @"customerId":customID,
                                  @"contactorName":contactName,
                                  @"genderstring":gender,
                                  @"contactorPhone":phone,
                                  @"detailAdress":address};
    [self postRequest:parameters RequestMethod:@"customerAdmin.saveAddress" CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryCustomerAddressListWithCustomID:(NSString *)customID
                                SuccessBlock:(void (^)(id responseValue))success
                                FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"customerId":customID} RequestMethod:@"customerAdmin.getAllAddress" CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryOrderDetailWithOrderID:(NSString *)orderNumber
                       SuccessBlock:(void (^)(id responseValue))success
                       FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"orderNumber":orderNumber} RequestMethod:@"bizadmin.getSalesOrderByOrderNumberForPos" CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)updateCustomerInfoWithCustomID:(NSString *)customID
                          CustomerName:(NSString *)customName
                           CustomPhone:(NSString *)phone
                                Gender:(NSString *)gender
                                   Age:(NSString *)age
                                 Email:(NSString *)email
                              Birthday:(NSString *)birthday
                                Remark:(NSString *)remark
                          SuccessBlock:(void (^)(id responseValue))success
                          FailureBlock:(void (^)(NSError * error))failure
{
    NSDictionary * parameters = @{@"id":customID,
                                  @"customerName":customName,
                                  @"customerPhone":phone,
                                  @"genderString":gender,
                                  @"age":age,
                                  @"email":email,
                                  @"birthday":birthday,
                                  @"remark":remark};
    [self postRequest:parameters RequestMethod:@"customerAdmin.updateCustomerInfo" CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)setDefaultOptometryWithCustomID:(NSString *)customID
                     DefaultOptometryID:(NSString *)defaultOptometryID
                           SuccessBlock:(void (^)(id responseValue))success
                           FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"customerId":customID,@"optometryId":defaultOptometryID} RequestMethod:@"customerAdmin.setCurrentOptometry" CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)setDefaultAddressWithCustomID:(NSString *)customID
                     DefaultAddressID:(NSString *)defaultAddressID
                         SuccessBlock:(void (^)(id responseValue))success
                         FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"customerId":customID,@"addressId":defaultAddressID} RequestMethod:@"customerAdmin.setCurrentAddress" CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)getMemberLevelWithSuccessBlock:(void (^)(id))success
                          FailureBlock:(void (^)(NSError *))failure
{
    [self postRequest:nil RequestMethod:@"customerAdmin.listMemberLevel" CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)getCustomerTypeSuccessBlock:(void (^)(id))success
                       FailureBlock:(void (^)(NSError *))failure
{
    [self postRequest:nil RequestMethod:@"customerAdmin.listCustomerType" CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

@end
