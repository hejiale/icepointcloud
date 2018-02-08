//
//  LanuchViewController.m
//  IcePointCloud
//
//  Created by mac on 16/9/7.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCLanuchViewController.h"
#import "IPCGuideConstant.h"
#import "IPCLoginViewController.h"

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
                                                                   __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                   strongSelf.view.transform = CGAffineTransformScale(strongSelf.view.transform, 1.5, 1.5);
                                                                   strongSelf.view.alpha = 0;
                                                               }completion:^(BOOL finished) {
                                                                   if ([weakSelf isShouldDeleteUUID]) {
                                                                       [weakSelf userLogin];
                                                                   }else{
                                                                       [weakSelf pushToLoginVC];
                                                                   }
                                                               }];
                                                           }];
    
}

///App重装 删除本地钥匙串和服务端UUID
- (BOOL)isShouldDeleteUUID
{
    if ([[LUKeychainAccess standardKeychainAccess] objectForKey:kIPCDeviceLoginUUID]) {
        if (![[[LUKeychainAccess standardKeychainAccess] objectForKey:kIPCDeviceLoginUUID] isEqualToString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]]){
            return YES;
        }
    }
    return NO;
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
    __weak typeof(self) weakSelf = self;
    
    [IPCUserRequestManager deletePadUUIDWithUUID:[[LUKeychainAccess standardKeychainAccess] objectForKey:kIPCDeviceLoginUUID]
                                    SuccessBlock:^(id responseValue)
     {
         [[LUKeychainAccess standardKeychainAccess] deleteObjectForKey:kIPCDeviceLoginUUID];
         [weakSelf pushToLoginVC];
     } FailureBlock:nil];
}

- (void)pushToLoginVC
{
    IPCLoginViewController *loginVC = [[IPCLoginViewController alloc]initWithNibName:@"IPCLoginViewController" bundle:nil];
    [[UIApplication sharedApplication].keyWindow setRootViewController:loginVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
