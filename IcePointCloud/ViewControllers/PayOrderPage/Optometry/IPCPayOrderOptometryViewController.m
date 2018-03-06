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
            [weakSelf pushToManagerOptometryViewController];
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
    if ([IPCPayOrderCurrentCustomer sharedManager].currentOpometry)
    {
        [self loadShowOptometryView];
    }else{
        [self.showOptometryView removeFromSuperview];
    }
}

- (IBAction)editOptometryAction:(id)sender
{
    if ([[IPCPayOrderManager sharedManager] customerId]) {
        __weak typeof(self) weakSelf = self;
        self.insertOptometryView = [[IPCInsertNewOptometryView alloc]initWithFrame:[IPCCommonUI currentView].bounds
                                                                        CustomerId:[[IPCPayOrderManager sharedManager] customerId]
                                                                     CompleteBlock:^(IPCOptometryMode * optometry)
                                    {
                                        [IPCPayOrderCurrentCustomer sharedManager].currentOpometry = optometry;
                                        [weakSelf reload];
                                    }];
        [[IPCCommonUI currentView] addSubview:self.insertOptometryView];
    }else{
        [IPCCommonUI showError:@"请先选择客户"];
    }
}


- (void)pushToManagerOptometryViewController{
    IPCManagerOptometryViewController * optometryVC = [[IPCManagerOptometryViewController alloc]initWithNibName:@"IPCManagerOptometryViewController" bundle:nil];
    optometryVC.customerId = [[IPCPayOrderManager sharedManager] customerId];
    [self.navigationController pushViewController:optometryVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (self.isViewLoaded && !self.view.window){
        self.view = nil;
        self.showOptometryView = nil;
        self.insertOptometryView = nil;
        [IPCHttpRequest cancelAllRequest];
    }
}


@end
