//
//  IPCUserRequestManager.m
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCUserRequestManager.h"

@implementation IPCUserRequestManager

+ (void)userLoginWithUserName:(NSString *)userName
                     Password:(NSString *)password
                 SuccessBlock:(void (^)(id responseValue))success
                 FailureBlock:(void (^)(NSError * error))failure
{
    NSDictionary *params = @{@"account"     : userName,
                             @"password"  : password,
                             @"deviceType": @"IOS",
//                             @"deviceID"    : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                             @"isPadLogin" : @"true"
                             };
    [self  postRequest:params RequestMethod:UserRequest_Login CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)userLogoutWithSuccessBlock:(void (^)(id responseValue))success
                      FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:nil RequestMethod:UserRequest_LoginOut CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)updatePasswordWithOldPassword:(NSString *)oldPassword
                       UpdatePassword:(NSString *)updatePassword
                         SuccessBlock:(void (^)(id responseValue))success
                         FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"oldPassword":oldPassword,@"password":updatePassword} RequestMethod:UserRequest_UpdatePassword CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)queryRepositoryWithSuccessBlock:(void (^)(id responseValue))success
                           FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"isRepository":@"true"} RequestMethod:UserRequest_WareHouseList CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)queryAllStoreWithSuccessBlock:(void (^)(id responseValue))success
                         FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:@{@"isRepository":@"false", @"companyId": [IPCAppManager sharedManager].storeResult.companyId } RequestMethod:UserRequest_WareHouseList CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)queryEmployeeAccountWithSuccessBlock:(void (^)(id responseValue))success
                                FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:nil RequestMethod:UserRequest_EmployeeAccount CacheEnable:IPCRequestCacheEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)verifyActivationCode:(NSString *)code SuccessBlock:(void (^)(id))success FailureBlock:(void (^)(NSError *))failure
{
    [self postRequest:@{@"verificationCode":code, @"padUUID": [[UIDevice currentDevice] identifierForVendor].UUIDString} RequestMethod:UserRequest_VerifyActivationCode CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)getAppMessageWithSuccessBlock:(void (^)(id responseValue))success
                         FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:nil RequestMethod:UserRequest_GetAppMessage CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)deletePadUUIDWithUUID:(NSString *)uuid SuccessBlock:(void (^)(id))success FailureBlock:(void (^)(NSError *))failure
{
    [self postRequest:uuid RequestMethod:UserRequest_DeleteUUID CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)getOpenPadConfigWithSuccessBlock:(void (^)(id))success FailureBlock:(void (^)(NSError *))failure
{
    [self postRequest:nil RequestMethod:UserRequest_OpenPadConfig CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

@end
