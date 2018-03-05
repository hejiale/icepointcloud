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
                             Comprehensive:(NSString *)comprehensive
                                    Remark:(NSString *)remark
                              SuccessBlock:(void (^)(id responseValue))success
                              FailureBlock:(void (^)(NSError * error))failure;




/**
 SAVE CUSTOMER INFO
 
 @param customName
 @param phone
 @param gender
 @param birthday
 @param customerTypeId
 @param photoId
 @param age
 @param customerId
 @param success
 @param failure
 */
+ (void)saveCustomerInfoWithCustomName:(NSString *)customName
                           CustomPhone:(NSString *)phone
                                Gender:(NSString *)gender
                              Birthday:(NSString *)birthday
                        CustomerTypeId:(NSString *)customerTypeId
                               PhotoId:(NSString *)photoId
                                   Age:(NSString *)age
                            CustomerId:(NSString *)customerId
                               StoreId:(NSString *)storeId
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
 Upgrade Member
 
 @param customerId
 @param memberGrowth
 @param memberPhone
 @param integral
 @param balance
 @param success
 @param failure
 */
+ (void)upgradeMemberWithCustomerId:(NSString *)customerId
                       MemberGrowth:(double)memberGrowth
                        MemberPhone:(NSString *)memberPhone
                           Integral:(NSInteger)integral
                            Balance:(double)balance
                       SuccessBlock:(void (^)(id responseValue))success
                       FailureBlock:(void (^)(NSError * error))failure;


/**
 Validate Customer
 
 @param code
 @param success
 @param failure
 */
+ (void)validateCustomerWithCode:(NSString *)code
                    SuccessBlock:(void (^)(id responseValue))success
                    FailureBlock:(void (^)(NSError * error))failure;


/**
 Update Member Phone
 
 @param memberPhone
 @param success
 @param failure
 */
+ (void)updateMemberPhoneWithPhone:(NSString *)memberPhone
                        CustomerId:(NSString *)customerId
                      SuccessBlock:(void (^)(id responseValue))success
                      FailureBlock:(void (^)(NSError *))failure;


/**
 Query MemberList

 @param keyword
 @param page
 @param success
 @param failure
 */
+ (void)queryMemberListWithKeyword:(NSString *)keyword
                              Page:(NSInteger )page
                   SuccessBlock:(void (^)(id responseValue))success
                   FailureBlock:(void (^)(NSError * error))failure;


/**
 Bind Member

 @param customerId
 @param memberCustomerId
 @param success
 @param failure
 */
+ (void)bindMemberWithCustomerId:(NSString *)customerId
                MemberCustomerId:(NSString *)memberCustomerId
                    SuccessBlock:(void (^)(id responseValue))success
                    FailureBlock:(void (^)(NSError * error))failure;


/**
 Query Member Detail

 @param memberCustomerId
 @param success
 @param failure
 */
+ (void)queryBindMemberCustomerWithMemberCustomerId:(NSString *)memberCustomerId
                                         SuccessBlock:(void (^)(id responseValue))success
                                         FailureBlock:(void (^)(NSError * error))failure;


/**
 Get Visitor Customer

 @param success
 @param failure 
 */
+ (void)getVisitorCustomerWithSuccessBlock:(void (^)(id responseValue))success
                              FailureBlock:(void (^)(NSError * error))failure;


@end
