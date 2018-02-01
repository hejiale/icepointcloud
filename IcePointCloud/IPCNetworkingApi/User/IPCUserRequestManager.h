//
//  IPCUserRequestManager.h
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCRequest.h"

@interface IPCUserRequestManager : IPCRequest

/**
 *  LOGIN
 *
 *  @param userName
 *  @param password
 *  @param success
 *  @param failure
 */
+ (void)userLoginWithUserName:(NSString *)userName
                     Password:(NSString *)password
                 SuccessBlock:(void (^)(id responseValue))success
                 FailureBlock:(void (^)(NSError * error))failure;

/**
 *  LOGOUT
 *
 *  @param success
 *  @param failure
 */
+ (void)userLogoutWithSuccessBlock:(void (^)(id responseValue))success
                      FailureBlock:(void (^)(NSError * error))failure;


/**
 *  UPDATE PASSWORD
 *
 *  @param oldPassword
 *  @param updatePassword
 *  @param success
 *  @param failure
 */
+ (void)updatePasswordWithOldPassword:(NSString *)oldPassword
                       UpdatePassword:(NSString *)updatePassword
                         SuccessBlock:(void (^)(id responseValue))success
                         FailureBlock:(void (^)(NSError * error))failure;


/**
 QUERY Repository
 
 @param success
 @param failure
 */
+ (void)queryRepositoryWithSuccessBlock:(void (^)(id responseValue))success
                           FailureBlock:(void (^)(NSError * error))failure;



/**
 Query Store

 @param success 
 @param failure
 */
+ (void)queryAllStoreWithSuccessBlock:(void (^)(id responseValue))success
                         FailureBlock:(void (^)(NSError * error))failure;

/**
 QUERY Employee Account
 
 @param success
 @param failure
 */
+ (void)queryEmployeeAccountWithSuccessBlock:(void (^)(id responseValue))success
                                FailureBlock:(void (^)(NSError * error))failure;


/**
 Verify the activation code
 
 @param code
 @param success
 @param failure 
 */
+ (void)verifyActivationCode:(NSString *)code
                SuccessBlock:(void (^)(id responseValue))success
                FailureBlock:(void (^)(NSError * error))failure;


/**
 Get App Message
 
 @param success
 @param failure
 */
+ (void)getAppMessageWithSuccessBlock:(void (^)(id responseValue))success
                         FailureBlock:(void (^)(NSError * error))failure;


/**
 Delete UUID
 
 @param uuid
 @param success
 @param failure
 */
+ (void)deletePadUUIDWithUUID:(NSString *)uuid
                 SuccessBlock:(void (^)(id responseValue))success
                 FailureBlock:(void (^)(NSError * error))failure;


/**
 Query OpenPad Config

 @param success
 @param failure 
 */
+ (void)getOpenPadConfigWithSuccessBlock:(void (^)(id responseValue))success
                            FailureBlock:(void (^)(NSError * error))failure;

@end
