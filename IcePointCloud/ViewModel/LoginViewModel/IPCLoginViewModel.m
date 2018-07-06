//
//  IPCLoginViewModel.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/7.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCLoginViewModel.h"
#import "IPCRootViewController.h"

static NSString * const AccountErrorMessage = @"登录帐号不能为空!";
static NSString * const PasswordErrorMessage = @"登录密码不能为空!";

@implementation IPCLoginViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.loginHistory addObjectsFromArray:[IPCAppManager sharedManager].loginAccountHistory];
    }
    return self;
}

- (NSMutableArray<NSString *> *)loginHistory{
    if (!_loginHistory) {
        _loginHistory = [[NSMutableArray alloc]init];
    }
    return _loginHistory;
}

- (NSString *)userName
{
    if ([NSUserDefaults jk_stringForKey:IPCUserNameKey].length) {
        return [NSUserDefaults jk_stringForKey:IPCUserNameKey];
    }
    return nil;
}

#pragma mark //Request Methods
- (void)signinRequestWithUserName:(NSString *)userName Password:(NSString *)password NeedVality:(void (^)())need Failed:(void (^)())failed
{
    NSString * Tusername = [userName jk_trimmingWhitespace];
    NSString * Tpassword = [password jk_trimmingWhitespace];
    
    if (!Tusername.length){
        [IPCCommonUI showError:AccountErrorMessage];
        if (failed) {
            failed();
        }
        return;
    }
    if (!Tpassword.length) {
        [IPCCommonUI showError:PasswordErrorMessage];
        if (failed) {
            failed();
        }
        return;
    }
    
    [IPCAppManager sharedManager].userName = Tusername;
    [IPCAppManager sharedManager].password = Tpassword;
    ///后台监测保存账号信息
    [Bugly setUserIdentifier:[Tusername stringByAppendingString:Tpassword]];
    
    NSString * localUUID = [[LUKeychainAccess standardKeychainAccess] objectForKey:kIPCDeviceLoginUUID];
    
    __weak typeof(self) weakSelf = self;
    [IPCUserRequestManager userLoginWithUserName:Tusername Password:Tpassword SuccessBlock:^(id responseValue){
        //query login info
        [IPCAppManager sharedManager].deviceToken = responseValue[@"mobileToken"];
        //storeage account info
        [weakSelf syncUserAccountHistory:userName];
        //query company openPad Config
        [weakSelf getOpenPadConfig:^(BOOL isOpen) {
            if (isOpen && !localUUID.length) {
                if (need) {
                    need();
                }
            }else{
                [weakSelf loadConfigData];
            }
        }];
    } FailureBlock:^(NSError *error) {
        if (error.code == IPAD_NOT_ACTIVATE) {
            if (need) {
                need();
            }
        }else{
            if (failed) {
                failed();
            }
            [IPCCommonUI showError:error.domain];
        }
    }];
}

- (void)loadConfigData
{
    __weak typeof(self) weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [weakSelf queryEmployeeAccount:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [weakSelf loadWareHouse:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [weakSelf loadPriceStrategy:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [weakSelf loadCompanyConfig:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [weakSelf getAuth:^{
            dispatch_semaphore_signal(semaphore);
        }]; 
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [weakSelf getProductConfig:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [[IPCAppManager sharedManager] loadCurrentWareHouse];
        [weakSelf showMainRootViewController];
    });
}

- (void)queryEmployeeAccount:(void(^)())complete
{
    [[IPCAppManager sharedManager] queryEmployeeAccount:^(NSError *error) {
        if (error) {
            [IPCCommonUI showError:error.domain];
        }else{
            if (complete) {
                complete();
            }
        }
    }];
}

- (void)loadWareHouse:(void(^)())complete
{
    [[IPCAppManager sharedManager] loadWareHouse:^(NSError *error) {
        if (error) {
            [IPCCommonUI showError:error.domain];
        }else{
            if (complete) {
                complete();
            }
        }
    }];
}

- (void)loadPriceStrategy:(void(^)())complete
{
    [[IPCAppManager sharedManager] queryPriceStrategy:^(NSError *error) {
        if (error) {
            [IPCCommonUI showError:error.domain];
        }else{
            if (complete) {
                complete();
            }
        }
    }];
}

- (void)loadCompanyConfig:(void(^)())complete
{
    [[IPCAppManager sharedManager] getCompanyConfig:^(NSError *error) {
        if (error) {
            [IPCCommonUI showError:error.domain];
        }else{
            if (complete) {
                complete();
            }
        }
    }];
}

- (void)getAuth:(void(^)())complete
{
    [[IPCAppManager sharedManager] getAuths:^(NSError *error) {
        if (error) {
            [IPCCommonUI showError:error.domain];
        }else{
            if (complete) {
                complete();
            }
        }
    }];
}

- (void)valityActiveCode:(NSString *)code
{
    __weak typeof(self) weakSelf = self;
    [IPCUserRequestManager verifyActivationCode:code SuccessBlock:^(id responseValue)
     {
         [IPCCommonUI showSuccess:@"设备激活成功!"];
         
         [[LUKeychainAccess standardKeychainAccess] setObject:[[UIDevice currentDevice] identifierForVendor].UUIDString forKey:kIPCDeviceLoginUUID];
         
         [weakSelf loadConfigData];
 
     } FailureBlock:^(NSError *error) {
         [IPCCommonUI showError:error.domain];
     }];
}

- (void)getOpenPadConfig:(void(^)(BOOL isOpen))complete
{
    [IPCUserRequestManager getOpenPadConfigWithSuccessBlock:^(id responseValue) {
        if (complete) {
            complete([responseValue boolValue]);
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)getProductConfig:(void(^)())complete
{
    [IPCCustomerRequestManager getProductConfigWithSuccessBlock:^(id responseValue)
    {
        __block NSInteger rang = 0;
        if ([responseValue isKindOfClass:[NSDictionary class]]) {
            if ([responseValue[@"values"] isKindOfClass:[NSArray class]]) {
                [responseValue[@"values"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx < 2) {
                        rang += [obj[@"figure"] integerValue];
                    }
                }];
            }
        }
        [IPCAppManager sharedManager].interceptionDigits = rang;
        
        if (complete) {
            complete();
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark //Clicked Methods
- (void)syncUserAccountHistory:(NSString *)userName
{
    if ([IPCAppManager sharedManager].deviceToken.length && userName.length)
    {
        [NSUserDefaults jk_setObject:userName forKey:IPCUserNameKey];
        
        if (![self.loginHistory containsObject:userName])
            [self.loginHistory insertObject:userName atIndex:0];
        
        NSData *historyData  = [NSKeyedArchiver archivedDataWithRootObject:self.loginHistory];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:IPCListLoginHistoryKey];
        [NSUserDefaults jk_setObject:historyData forKey:IPCListLoginHistoryKey];
    }
}

- (void)showMainRootViewController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView transitionWithView:[UIApplication sharedApplication].keyWindow
                          duration:0.8f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            BOOL oldState = [UIView areAnimationsEnabled];
                            [UIView setAnimationsEnabled:NO];
                            IPCRootViewController * menuVC = [[IPCRootViewController alloc]initWithNibName:@"IPCRootViewController" bundle:nil];
                            UINavigationController * menuNav = [[UINavigationController alloc]initWithRootViewController:menuVC];
                            [[UIApplication sharedApplication].keyWindow setRootViewController:menuNav];
                            [UIView setAnimationsEnabled:oldState];
                        } completion:nil];
    });
}

@end
