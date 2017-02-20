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
    [self loadRequest:@{@"customerId":customID,@"pageNo":@(page),@"maxPageSize":@(5)} RequestMethod:@"customerAdmin.listOptometry" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)storeUserOptometryInfoWithCustomID:(NSString *)customID
                                  Distance:(NSString *)distance
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
                              SuccessBlock:(void (^)(id responseValue))success
                              FailureBlock:(void (^)(NSError * error))failure{
    NSDictionary *params = @{@"customerId": customID,
                             @"distance": distance,
                             @"sphLeft": sphLeft,
                             @"sphRight":sphRight,
                             @"cylLeft": cylLeft,
                             @"cylRight":cylRight,
                             @"axisLeft":axisLeft,
                             @"axisRight":axisRight,
                             @"addLeft":addLeft,
                             @"addRight":addRight,
                             @"correctedVisionLeft":correctedVisionLeft,
                             @"correctedVisionRight":correctedVisionRight};
    [self loadRequest:params RequestMethod:@"customerAdmin.saveOptometry" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
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
    [self loadRequest:params RequestMethod:@"customerAdmin.saveCustomerInfo" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryCustomerDetailInfoWithCustomerID:(NSString *)customerID
                                 SuccessBlock:(void (^)(id responseValue))success
                                 FailureBlock:(void (^)(NSError * error))failure
{
    [self loadRequest:@{@"customerId":customerID} RequestMethod:@"customerAdmin.getCusomerInfo"  RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryCustomerListWithKeyword:(NSString *)keyword
                        SuccessBlock:(void (^)(id responseValue))success
                        FailureBlock:(void (^)(NSError * error))failure
{
    [self loadRequest:@{@"keyword":keyword} RequestMethod:@"customerAdmin.listAllCustomer" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)setCurrentOptometryWithCustomID:(NSString *)customID
                            OptometryID:(NSString *)optometryID
                           SuccessBlock:(void (^)(id responseValue))success
                           FailureBlock:(void (^)(NSError * error))failure
{
    [self loadRequest:@{@"customerId":customID,@"optometryId":optometryID} RequestMethod:@"customerAdmin.setCurrentOptometry" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryHistorySellInfoWithPhone:(NSString *)phone
                                 Page:(NSInteger)page
                         SuccessBlock:(void (^)(id responseValue))success
                         FailureBlock:(void (^)(NSError * error))failure
{
    [self loadRequest:@{@"pageNo":@(page),@"maxPageSize":@(5),@"customerPhone":phone} RequestMethod:@"customerAdmin.listHistoryOrders" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
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
    [self loadRequest:parameters RequestMethod:@"customerAdmin.saveAddress" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryCustomerAddressListWithCustomID:(NSString *)customID
                                SuccessBlock:(void (^)(id responseValue))success
                                FailureBlock:(void (^)(NSError * error))failure
{
    [self loadRequest:@{@"customerId":customID} RequestMethod:@"customerAdmin.getAllAddress"  RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryOrderDetailWithOrderID:(NSString *)orderNumber
                       SuccessBlock:(void (^)(id responseValue))success
                       FailureBlock:(void (^)(NSError * error))failure
{
    [self loadRequest:@{@"orderNumber":orderNumber} RequestMethod:@"bizadmin.getSalesOrderByOrderNumberForPos" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)updateCustomerInfoWithCustomID:(NSString *)customID
                          CustomerName:(NSString *)customName
                           CustomPhone:(NSString *)phone
                                Gender:(NSString *)gender
                                   Age:(NSString *)age
                                 Email:(NSString *)email
                              Birthday:(NSString *)birthday
                                Remark:(NSString *)remark
                             PhotoUUID:(NSString *)photoUUID
                      DefaultAddressID:(NSString *)defaultAddressID
                    DefaultOptometryID:(NSString *)defaultOptometryID
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
                                  @"remark":remark,
                                  @"photo_uuid":photoUUID,
                                  @"currentAddressId":defaultAddressID,
                                  @"currentOptometryId":defaultOptometryID};
    [self loadRequest:parameters RequestMethod:@"customerAdmin.updateCustomerInfo" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

@end
