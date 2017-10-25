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
                             @"deviceID"    : [[[UIDevice currentDevice] identifierForVendor] UUIDString]};
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
    [self postRequest:@{@"isRepository":@"true"} RequestMethod:UserRequest_WareHouseList CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

+ (void)queryEmployeeAccountWithSuccessBlock:(void (^)(id responseValue))success
                                FailureBlock:(void (^)(NSError * error))failure
{
    [self postRequest:nil RequestMethod:UserRequest_EmployeeAccount CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


@end
