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
    
    [[IPCGuideViewManager sharedInstance] showGuideViewWithImages:images
                                                           InView:self.view
                                                           Finish:^{
                                                               [UIView animateWithDuration:1.3 animations:^{
                                                                   self.view.transform = CGAffineTransformScale(self.view.transform, 1.5, 1.5);
                                                                   self.view.alpha = 0;
                                                               }completion:^(BOOL finished) {
                                                                   if ([self isShouldDeleteUUID]) {
                                                                       [self userLogin];
                                                                   }else{
                                                                       [self pushToLoginVC];
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
    [IPCUserRequestManager userLoginWithUserName:LOGINACCOUNT
                                        Password:PASSWORD
                                    SuccessBlock:^(id responseValue) {
                                        [self deleteUUID];
                                    } FailureBlock:nil];
}

- (void)deleteUUID
{
    [IPCUserRequestManager deletePadUUIDWithUUID:[[LUKeychainAccess standardKeychainAccess] objectForKey:kIPCDeviceLoginUUID]
                                    SuccessBlock:^(id responseValue)
     {
         [[LUKeychainAccess standardKeychainAccess] deleteObjectForKey:kIPCDeviceLoginUUID];
         [self pushToLoginVC];
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
