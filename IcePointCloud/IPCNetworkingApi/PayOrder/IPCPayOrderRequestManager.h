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
 
 *  @param success
 *  @param failure
 */
+ (void)savePrototyOrderWithSuccessBlock:(void (^)(id responseValue))success
                            FailureBlock:(void (^)(NSError * error))failure;


/**
 OFFER PAY ORDER
 
 @param success
 @param failure
 */
+ (void)offerOrderWithOrderId:(NSString *)orderId
                 SuccessBlock:(void (^)(id responseValue))success
                 FailureBlock:(void (^)(NSError * error))failure;


/**
 AUTH ORDER
 
 @param orderNum
 @param success
 @param failure
 */
+ (void)authOrderWithOrderNum:(NSString *)orderNum
                 SuccessBlock:(void (^)(id responseValue))success
                 FailureBlock:(void (^)(NSError * error))failure;


/**
 Pay Cash Order
 
 @param success
 @param failure
 */
+ (void)payCashOrderWithOrderNumber:(NSString *)orderNum
                       SuccessBlock:(void (^)(id responseValue))success
                       FailureBlock:(void (^)(NSError *error))failure;

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


/**
 Query Integral Rule
 
 @param success
 @param failure
 */
+ (void)queryIntegralRuleWithSuccessBlock:(void (^)(id responseValue))success
                             FailureBlock:(void (^)(NSError *error))failure;


/**
 Query Pay List Type
 
 @param success
 @param failure
 */
+ (void)queryPayListTypeWithSuccessBlock:(void (^)(id responseValue))success
                            FailureBlock:(void (^)(NSError *error))failure;


/**
 Get CompanyConfig
 
 @param success
 @param failure
 */
+ (void)getCompanyConfigWithSuccessBlock:(void (^)(id responseValue))success
                            FailureBlock:(void (^)(NSError *error))failure;



/**
 Outbound
 
 @param orderNum
 @param success
 @param failure
 */
+(void)outbound:(NSString *)orderNum
   SuccessBlock:(void (^)(id))success
   FailureBlock:(void (^)(NSError *))failure;


/**
 Get Auth

 @param success
 @param failure 
 */
+ (void)getAuthWithSuccessBlock:(void (^)(id responseValue))success
                   FailureBlock:(void (^)(NSError *error))failure;




@end
