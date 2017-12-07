//
//  IPCLoginViewModel.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/7.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCLoginViewModel.h"
#import "IPCRootViewController.h"

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
- (void)signinRequestWithUserName:(NSString *)userName Password:(NSString *)password Failed:(void(^)())failed
{
    NSString * Tusername = [userName jk_trimmingWhitespace];
    NSString * Tpassword = [password jk_trimmingWhitespace];
    
    if (!Tusername.length){
        [IPCCommonUI showError:@"登录帐号不能为空"];
        if (failed) {
            failed();
        }
        return;
    }
    if (!Tpassword.length) {
        [IPCCommonUI showError:@"登录密码不能为空"];
        if (failed) {
            failed();
        }
        return;
    }
    
    __weak typeof (self) weakSelf = self;
    
    [IPCUserRequestManager userLoginWithUserName:Tusername Password:Tpassword SuccessBlock:^(id responseValue){
        //query login info
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [IPCAppManager sharedManager].deviceToken = responseValue[@"mobileToken"];
        [IPCAppManager sharedManager].companyName = responseValue[@"companyName"];
        //storeage account info
        [strongSelf syncUserAccountHistory:userName];
        //query responsity wareHouse
        [strongSelf queryEmployeeAccount];
    } FailureBlock:^(NSError *error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (failed) {
            failed();
        }
        [IPCCommonUI showError:@"用户登录失败,请重新输入!"];
    }];
}

- (void)queryEmployeeAccount
{
    __weak typeof (self) weakSelf = self;
    [IPCUserRequestManager queryEmployeeAccountWithSuccessBlock:^(id responseValue){
        __strong typeof (weakSelf) strongSelf = weakSelf;
        //Query Responsity WareHouse
        [IPCAppManager sharedManager].storeResult = [IPCStoreResult mj_objectWithKeyValues:responseValue];
        [IPCAppManager sharedManager].storeResult.employee = [IPCEmployee mj_objectWithKeyValues:responseValue];
        [[IPCPayOrderManager sharedManager] resetEmployee];
        //load wareHouse
        [strongSelf loadWareHouse];
    } FailureBlock:^(NSError *error) {
        [IPCCommonUI showError:@"用户登录失败,请重新输入!"];
    }];
}

- (void)loadWareHouse
{
    __weak typeof (self) weakSelf = self;
    [[IPCAppManager sharedManager] loadWareHouse:^(NSError *error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        //Load Main View
        if (!error) {
            [strongSelf showMainRootViewController];
        }else{
            [IPCCommonUI showError:@"用户登录失败,请重新输入!"];
        }
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
