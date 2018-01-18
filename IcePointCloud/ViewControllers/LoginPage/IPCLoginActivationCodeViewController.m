//
//  IPCLoginActivationCodeViewController.m
//  IcePointCloud
//
//  Created by gerry on 2018/1/18.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCLoginActivationCodeViewController.h"
#import "IPCLoginViewController.h"

@interface IPCLoginActivationCodeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@end

@implementation IPCLoginActivationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setBackground];
}

#pragma mark //Clicked Events
- (IBAction)activationCodeAction:(id)sender
{
    [[LUKeychainAccess standardKeychainAccess] setObject:[[UIDevice currentDevice] identifierForVendor].UUIDString forKey:kIPCDeviceLoginUUID];
    
    IPCLoginViewController * loginVC = [[IPCLoginViewController alloc]initWithNibName:@"IPCLoginViewController" bundle:nil];
    [[[UIApplication sharedApplication] delegate].window setRootViewController:loginVC];
}

#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
