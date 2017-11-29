//
//  IPCCustomerRequestManager.h
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCRequest.h"

@interface IPCCustomerRequestManager : IPCRequest

/**
 *  QUERY HISTORY OPTOMETORY INFO
 *
 *  @param customID
 *  @param success
 *  @param failure
 */
+ (void)queryUserOptometryListWithCustomID:(NSString *)customID
                              SuccessBlock:(void (^)(id responseValue))success
                              FailureBlock:(void (^)(NSError * error))failure;


/**
 SAVE CUSTOMER OPTOMETRY
 
 @param customID  用户id
 @param sphLeft 球镜
 @param sphRight
 @param cylLeft 柱镜
 @param cylRight
 @param axisLeft
 @param axisRight
 @param addLeft
 @param addRight
 @param correctedVisionLeft
 @param correctedVisionRight
 @param distanceLeft
 @param distanceRight
 @param success
 @param failure
 */
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
                              FailureBlock:(void (^)(NSError * error))failure;



/**
 SAVE CUSTOMER INFO
 
 @param customName
 @param phone
 @param gender
 @param email
 @param birthday
 @param remark
 @param optometryList
 @param contactName
 @param contactGender
 @param contactPhone
 @param contactAddress
 @param employeeId
 @param employeeName
 @param customerType
 @param customerTypeId
 @param occupation
 @param memberLevel
 @param memberLevelId
 @param memberNum
 @param success
 @param failure
 */
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
                                   Age:(NSString *)age
                            CustomerId:(NSString *)customerId
                          SuccessBlock:(void (^)(id responseValue))success
                          FailureBlock:(void (^)(NSError * error))failure;

/**
 *  QUERY CUSTOMER DETAIL INFO
 *
 *  @param customerID
 *  @param success
 *  @param failure
 */
+ (void)queryCustomerDetailInfoWithCustomerID:(NSString *)customerID
                                 SuccessBlock:(void (^)(id responseValue))success
                                 FailureBlock:(void (^)(NSError * error))failure;



/**
 QUERY CUSTOMER LIST
 
 @param keyword
 @param page
 @param success
 @param failure
 */
+ (void)queryCustomerListWithKeyword:(NSString *)keyword
                                Page:(NSInteger )page
                        SuccessBlock:(void (^)(id responseValue))success
                        FailureBlock:(void (^)(NSError * error))failure;


/**
 *  QUERY HISTORY LIST ORDER
 *
 *  @param customID
 *  @param page
 *  @param success
 *  @param failure
 */
+ (void)queryHistorySellInfoWithPhone:(NSString *)customID
                                 Page:(NSInteger)page
                         SuccessBlock:(void (^)(id responseValue))success
                         FailureBlock:(void (^)(NSError * error))failure;


/**
 *  UPDATE CUSTOMER ADDRESS
 *
 *  @param addressID
 *  @param customID
 *  @param contactName
 *  @param gender
 *  @param phone
 *  @param address
 *  @param success
 *  @param failure
 */
+ (void)saveNewCustomerAddressWithAddressID:(NSString *)addressID
                                   CustomID:(NSString *)customID
                                ContactName:(NSString *)contactName
                                     Gender:(NSString *)gender
                                      Phone:(NSString *)phone
                                    Address:(NSString *)address
                               SuccessBlock:(void (^)(id responseValue))success
                               FailureBlock:(void (^)(NSError * error))failure;

/**
 *  QUERY CUSTOMER ADDRESS
 *
 *  @param customID
 *  @param page
 *  @param success
 *  @param failure
 */
+ (void)queryCustomerAddressListWithCustomID:(NSString *)customID
                                SuccessBlock:(void (^)(id responseValue))success
                                FailureBlock:(void (^)(NSError * error))failure;


/**
 *  QUERY ORDER DETAIL
 *
 *  @param orderNumber
 *  @param success
 *  @param failure
 */
+ (void)queryOrderDetailWithOrderID:(NSString *)orderNumber
                       SuccessBlock:(void (^)(id responseValue))success
                       FailureBlock:(void (^)(NSError * error))failure;


/**
 SELECT DEFAULT CUSTOMER
 
 @param customID
 @param customName
 @param phone
 @param gender
 @param email
 @param birthday
 @param employeeId
 @param memberNum
 @param memberLevelId
 @param customerTypeId
 @param job
 @param remark
 @param success
 @param failure
 */
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
                          FailureBlock:(void (^)(NSError * error))failure;


/**
 设置默认验光单
 
 @param customID
 @param defaultOptometryID
 @param success
 @param failure
 */
+ (void)setDefaultOptometryWithCustomID:(NSString *)customID
                     DefaultOptometryID:(NSString *)defaultOptometryID
                           SuccessBlock:(void (^)(id responseValue))success
                           FailureBlock:(void (^)(NSError * error))failure;



/**
 设置默认地址
 
 @param customID
 @param defaultAddressID
 @param success
 @param failure
 */
+ (void)setDefaultAddressWithCustomID:(NSString *)customID
                     DefaultAddressID:(NSString *)defaultAddressID
                         SuccessBlock:(void (^)(id responseValue))success
                         FailureBlock:(void (^)(NSError * error))failure;

/**
 MemberLevel
 
 @param success
 @param failure
 */
+ (void)getMemberLevelWithSuccessBlock:(void (^)(id responseValue))success
                          FailureBlock:(void (^)(NSError * error))failure;


/**
 CustomerType
 
 @param success
 @param failure
 */
+ (void)getCustomerTypeSuccessBlock:(void (^)(id responseValue))success
                       FailureBlock:(void (^)(NSError * error))failure;


/**
 Judge Customer Phone Is Exist
 
 @param phone
 @param success
 @param failure
 */
+ (void)judgePhoneIsExistWithPhone:(NSString *)phone
                      SuccessBlock:(void (^)(id responseValue))success
                      FailureBlock:(void (^)(NSError * error))failure;


/**
 Judge Customer Name Is Exist
 
 @param name
 @param success
 @param failure
 */
+ (void)judgeCustomerNameIsExistWithName:(NSString *)name
                            SuccessBlock:(void (^)(id))success
                            FailureBlock:(void (^)(NSError *))failure;

@end
