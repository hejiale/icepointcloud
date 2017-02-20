//
//  IPCCustomerRequestManager.h
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCRequestManager.h"

@interface IPCCustomerRequestManager : IPCRequestManager

/**
 *  QUERY HISTORY OPTOMETORY INFO
 *
 *  @param customID
 *  @param page
 *  @param success
 *  @param failure
 */
+ (void)queryUserOptometryListWithCustomID:(NSString *)customID
                                      Page:(NSInteger)page
                              SuccessBlock:(void (^)(id responseValue))success
                              FailureBlock:(void (^)(NSError * error))failure;

/**
 *  SAVE CUSTOMER OPTOMETRY
 *
 *  @param customID             CUSTOMER ID
 *  @param distance             PD
 *  @param sphLeft              SPH
 *  @param sphRight
 *  @param cylLeft              CYL
 *  @param cylRight
 *  @param axisLeft             AXIS
 *  @param axisRight
 *  @param addLeft              ADD
 *  @param addRight
 *  @param correctedVisionLeft
 *  @param correctedVisionRight
 *  @param success
 *  @param failure
 */
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
                              FailureBlock:(void (^)(NSError * error))failure;

/**
 *  SAVE CUSTOMER INFO
 *
 *  @param customName
 *  @param phone
 *  @param gender
 *  @param age
 *  @param email
 *  @param birthday
 *  @param remark
 *  @param photoUUID
 *  @param distance
 *  @param sphLeft
 *  @param sphRight
 *  @param cylLeft
 *  @param cylRight
 *  @param axisLeft
 *  @param axisRight
 *  @param addLeft
 *  @param addRight
 *  @param correctedLeft
 *  @param correctedRight
 *  @param contactName
 *  @param contactGender
 *  @param contactPhone
 *  @param contactAddress
 *  @param success
 *  @param failure
 */
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
 *  QUERY CUSTOMER LIST
 *
 *  @param keyword
 *  @param success
 *  @param failure
 */
+ (void)queryCustomerListWithKeyword:(NSString *)keyword
                        SuccessBlock:(void (^)(id responseValue))success
                        FailureBlock:(void (^)(NSError * error))failure;

/**
 *  SET DEFAULT OPTOMETRY
 *
 *  @param customID
 *  @param optometryID
 *  @param success
 *  @param failure
 */
+ (void)setCurrentOptometryWithCustomID:(NSString *)customID
                            OptometryID:(NSString *)optometryID
                           SuccessBlock:(void (^)(id responseValue))success
                           FailureBlock:(void (^)(NSError * error))failure;

/**
 *  QUERY HISTORY LIST ORDER
 *
 *  @param phone
 *  @param page
 *  @param success
 *  @param failure
 */
+ (void)queryHistorySellInfoWithPhone:(NSString *)phone
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
 *  SELECT DEFAULT CUSTOMER
 *
 *  @param customID
 *  @param customName
 *  @param phone
 *  @param gender
 *  @param age
 *  @param email
 *  @param birthday
 *  @param remark
 *  @param photoUUID
 *  @param defaultAddressID
 *  @param defaultOptometryID
 *  @param success
 *  @param failure
 */
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
                          FailureBlock:(void (^)(NSError * error))failure;

@end
