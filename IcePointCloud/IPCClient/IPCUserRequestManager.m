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
    [self  loadRequest:params RequestMethod:@"bizadmin.login" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)userLogoutWithSuccessBlock:(void (^)(id responseValue))success
                      FailureBlock:(void (^)(NSError * error))failure
{
    [self loadRequest:nil RequestMethod:@"bizadmin.logout" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)updatePersonInfoWithUserName:(NSString *)userName
                               Phone:(NSString *)phone
                        SuccessBlock:(void (^)(id responseValue))success
                        FailureBlock:(void (^)(NSError * error))failure
{
    [self loadRequest:@{@"username":userName,@"mobile":phone} RequestMethod:@"bizadmin.saveUserInfo" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}


+ (void)updatePasswordWithOldPassword:(NSString *)oldPassword
                       UpdatePassword:(NSString *)updatePassword
                         SuccessBlock:(void (^)(id responseValue))success
                         FailureBlock:(void (^)(NSError * error))failure
{
    [self loadRequest:@{@"oldPassword":oldPassword,@"password":updatePassword} RequestMethod:@"bizadmin.updateUserPassword" RequestType:IPCRequestTypePost CacheEnable:IPCRequestCacheDisEnable SuccessBlock:success FailureBlock:failure];
}

@end
