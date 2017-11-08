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
    [self postRequest:params RequestMethod:CustomerRequest_SaveNewOptometry CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)saveCustomerInfoWithCustomName:(NSString *)customName
                           CustomPhone:(NSString *)phone
                                Gender:(NSString *)gender
                                 Email:(NSString *)email
                              Birthday:(NSString *)birthday
                                Remark:(NSString *)remark
                         OptometryList:(NSArray *)optometryList
                           ContactName:(NSString *)contactName
                         ContactGender:(NSString *)contactGender
                          ContactPhone:(NSString *)contactPhone
                        ContactAddress:(NSString *)contactAddress
                          CustomerType:(NSString *)customerType
                        CustomerTypeId:(NSString *)customerTypeId
                            Occupation:(NSString *)occupation
                           MemberLevel:(NSString *)memberLevel
                         MemberLevelId:(NSString *)memberLevelId
                             MemberNum:(NSString *)memberNum
                               PhotoId:(NSString *)photoId
                          IntroducerId:(NSString *)introducerId
                     IntroducerInteger:(NSString *)introducerInteger
                          SuccessBlock:(void (^)(id responseValue))success
                          FailureBlock:(void (^)(NSError * error))failure
{
    NSDictionary *params = @{@"customerName": customName,
                             @"customerPhone":phone,
                             @"genderString":gender,
                             @"email":email,
                             @"birthday":birthday,
                             @"remark":remark,
                             @"contactorName":contactName,
                             @"contactorGengerString":contactGender,
                             @"contactorPhone":contactPhone,
                             @"contactorAddress":contactAddress,
                             @"customerType":customerType,
                             @"customerTypeId":customerTypeId,
                             @"memberLevel":memberLevel,
                             @"memberLevelId":memberLevelId,
                             @"memberId":memberNum,
                             @"occupation":occupation,
                             @"optometrys":optometryList,
                             @"photoIdForPos":photoId,
                             @"isPos":@"true"};
    NSMutableDictionary * paramterDic = [[NSMutableDictionary alloc]initWithDictionary:params];
    
    if ([customerType isEqualToString:@"转介绍"]) {
        [paramterDic setObject:introducerId forKey:@"introducerId"];
        [paramterDic setObject:introducerInteger forKey:@"introducerIntegral"];
    }
    [self postRequest:paramterDic RequestMethod:CustomerRequest_SaveNewCustomer CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
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


+ (void)setCurrentOptometryWithCustomID:(NSString *)customID
                            OptometryID:(NSString *)optometryID
                           SuccessBlock:(void (^)(id responseValue))success
                           FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"customerId":customID,@"optometryId":optometryID} RequestMethod:CustomerRequest_SetCurrentOptometry CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryHistorySellInfoWithPhone:(NSString *)customID
                                 Page:(NSInteger)page
                         SuccessBlock:(void (^)(id responseValue))success
                         FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"pageNo":@(page),@"maxPageSize":@(5),@"customerId":customID} RequestMethod:CustomerRequest_CustomerOrderList CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
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
    [self postRequest:parameters RequestMethod:CustomerRequest_SaveNewAddress CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryCustomerAddressListWithCustomID:(NSString *)customID
                                SuccessBlock:(void (^)(id responseValue))success
                                FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"customerId":customID} RequestMethod:CustomerRequest_AddressList CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)queryOrderDetailWithOrderID:(NSString *)orderNumber
                       SuccessBlock:(void (^)(id responseValue))success
                       FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"orderNumber":orderNumber} RequestMethod:CustomerRequest_OrderDetail CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)updateCustomerInfoWithCustomID:(NSString *)customID
                          CustomerName:(NSString *)customName
                           CustomPhone:(NSString *)phone
                                Gender:(NSString *)gender
                                 Email:(NSString *)email
                              Birthday:(NSString *)birthday
                             MemberNum:(NSString *)memberNum
                         MemberLevelId:(NSString *)memberLevelId
                        CustomerTypeId:(NSString *)customerTypeId
                           MemberLevel:(NSString *)memberLevel
                                   Job:(NSString *)job
                                Remark:(NSString *)remark
                               PhotoId:(NSString *)photoId
                          SuccessBlock:(void (^)(id responseValue))success
                          FailureBlock:(void (^)(NSError * error))failure
{
    NSDictionary * parameters = @{@"id":customID,
                                  @"customerName":customName,
                                  @"customerPhone":phone,
                                  @"genderString":gender,
                                  @"email":email,
                                  @"birthday":birthday,
                                  @"remark":remark,
                                  @"memberId":memberNum,
                                  @"memberLevelId":memberLevelId,
                                  @"customerTypeId":customerTypeId,
                                  @"occupation":job,
                                  @"memberLevel":memberLevel,
                                  @"photoIdForPos":photoId,
                                  @"isPos":@"true"};
    [self postRequest:parameters RequestMethod:CustomerRequest_UpdateCustomer CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)setDefaultOptometryWithCustomID:(NSString *)customID
                     DefaultOptometryID:(NSString *)defaultOptometryID
                           SuccessBlock:(void (^)(id responseValue))success
                           FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"customerId":customID,@"optometryId":defaultOptometryID} RequestMethod:CustomerRequest_SetCurrentOptometry CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)setDefaultAddressWithCustomID:(NSString *)customID
                     DefaultAddressID:(NSString *)defaultAddressID
                         SuccessBlock:(void (^)(id responseValue))success
                         FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"customerId":customID,@"id":defaultAddressID} RequestMethod:CustomerRequest_SetCurrentAddress CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
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

+ (void)judgePhoneIsExistWithPhone:(NSString *)phone SuccessBlock:(void (^)(id))success FailureBlock:(void (^)(NSError *))failure
{
    [self postRequest:@{@"customerId":@"0",@"customerName":@"",@"customerPhone":phone} RequestMethod:CustomerRequest_JudgeNameOrPhone CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)judgeCustomerNameIsExistWithName:(NSString *)name SuccessBlock:(void (^)(id))success FailureBlock:(void (^)(NSError *))failure
{
    [self postRequest:@{@"customerId":@"0",@"customerName":name,@"customerPhone":@""} RequestMethod:CustomerRequest_JudgeNameOrPhone CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

@end
