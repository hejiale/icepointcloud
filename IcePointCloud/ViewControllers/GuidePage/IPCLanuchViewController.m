//
//  LanuchViewController.m
//  IcePointCloud
//
//  Created by mac on 16/9/7.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCLanuchViewController.h"
#import "IPCGuideConstant.h"
#import "IPCLoginActivationCodeViewController.h"

@interface IPCLanuchViewController ()

@end

@implementation IPCLanuchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSMutableArray *images = [NSMutableArray new];
    
    [images addObject:[UIImage imageNamed:@"lanuch_1"]];
    [images addObject:[UIImage imageNamed:@"lanuch_2"]];
    [images addObject:[UIImage imageNamed:@"lanuch_3"]];
    
    __weak typeof(self) weakSelf = self;
    [[IPCGuideViewManager sharedInstance] showGuideViewWithImages:images
                                                           InView:self.view
                                                           Finish:^{
                                                               [UIView animateWithDuration:1.3 animations:^{
                                                                   self.view.transform = CGAffineTransformScale(self.view.transform, 1.5, 1.5);
                                                                   self.view.alpha = 0;
                                                               }completion:^(BOOL finished) {
                                                                   [weakSelf checkPadUUID];
                                                                   
                                                                   IPCLoginActivationCodeViewController *loginVC = [[IPCLoginActivationCodeViewController alloc]initWithNibName:@"IPCLoginActivationCodeViewController" bundle:nil];
                                                                   [[UIApplication sharedApplication].keyWindow setRootViewController:loginVC];
                                                               }];
                                                               
                                                           }];
    
}

///App重装 删除本地钥匙串和服务端UUID
- (void)checkPadUUID
{
    if ([[LUKeychainAccess standardKeychainAccess] objectForKey:kIPCDeviceLoginUUID]) {
        if (![[[LUKeychainAccess standardKeychainAccess] objectForKey:kIPCDeviceLoginUUID] isEqualToString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]]){
            [self userLogin];
        }
    }
}

- (void)userLogin
{
    __weak typeof(self) weakSelf = self;
    [IPCUserRequestManager userLoginWithUserName:LOGINACCOUNT
                                        Password:PASSWORD
                                    SuccessBlock:^(id responseValue) {
                                        [weakSelf deleteUUID];
                                    } FailureBlock:nil];
}

- (void)deleteUUID
{
    [IPCUserRequestManager deletePadUUIDWithUUID:[[LUKeychainAccess standardKeychainAccess] objectForKey:kIPCDeviceLoginUUID]
                                    SuccessBlock:^(id responseValue){
                                        [[LUKeychainAccess standardKeychainAccess] deleteObjectForKey:kIPCDeviceLoginUUID];
                                    } FailureBlock:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
