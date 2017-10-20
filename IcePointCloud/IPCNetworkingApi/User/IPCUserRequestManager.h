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

@end
