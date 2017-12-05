//
//  IPCPayOrderOptometryViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderOptometryViewController.h"
#import "IPCManagerOptometryViewController.h"
#import "IPCPayOrderOptometryInfoView.h"
#import "IPCInsertNewOptometryView.h"

@interface IPCPayOrderOptometryViewController ()

@property (strong, nonatomic) IPCPayOrderOptometryInfoView * showOptometryView;
@property (strong, nonatomic) IPCInsertNewOptometryView * insertOptometryView;

@end

@implementation IPCPayOrderOptometryViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self reload];
}

#pragma mark //Set UI
- (IPCPayOrderOptometryInfoView *)showOptometryView
{
    if (!_showOptometryView) {
        __weak typeof(self) weakSelf = self;
        _showOptometryView = [[IPCPayOrderOptometryInfoView alloc]initWithFrame:CGRectMake(0, 10, self.view.jk_width-10, self.view.jk_height-20) ChooseBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf pushToManagerOptometryViewController];
        }];
    }
    return _showOptometryView;
}


- (void)loadShowOptometryView
{
    [self.showOptometryView removeFromSuperview];
    self.showOptometryView = nil;
    [self.view addSubview:self.showOptometryView];
}

#pragma mark //Clicked Events
- (void)reload
{
    if ([[IPCPayOrderManager sharedManager].currentOptometryId integerValue] > 0) {
        [self loadShowOptometryView];
    }else{
        [self.showOptometryView removeFromSuperview];
    }
}

- (IBAction)editOptometryAction:(id)sender
{
    __weak typeof(self) weakSelf = self;
    self.insertOptometryView = [[IPCInsertNewOptometryView alloc]initWithFrame:[IPCCommonUI currentView].bounds CustomerId:[IPCPayOrderManager sharedManager].currentCustomerId CompleteBlock:^(IPCOptometryMode * optometry)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.insertOptometryView removeFromSuperview];
        strongSelf.insertOptometryView = nil;
        
        [IPCPayOrderManager sharedManager].currentOptometryId = optometry.optometryID;
        [IPCCurrentCustomer sharedManager].currentOpometry = optometry;
        [strongSelf reload];
    }];
    [[IPCCommonUI currentView] addSubview:self.insertOptometryView];
}


- (void)pushToManagerOptometryViewController{
    IPCManagerOptometryViewController * optometryVC = [[IPCManagerOptometryViewController alloc]initWithNibName:@"IPCManagerOptometryViewController" bundle:nil];
    optometryVC.customerId = [IPCPayOrderManager sharedManager].currentCustomerId;
    [self.navigationController pushViewController:optometryVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
