//
//  IPCPayOrderOptometryViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderOptometryViewController.h"
#import "IPCPayOrderTopOptometryView.h"
#import "IPCPayOrderOptometryInfoView.h"
#import "IPCInsertNewOptometryView.h"

@interface IPCPayOrderOptometryViewController ()

@property (strong, nonatomic) IPCPayOrderTopOptometryView * topOptometryView;
@property (strong, nonatomic) IPCPayOrderOptometryInfoView * showOptometryView;
@property (strong, nonatomic) IPCInsertNewOptometryView * insertOptometryView;

@end

@implementation IPCPayOrderOptometryViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self reload];
}

#pragma mark //Set UI
- (IPCPayOrderTopOptometryView *)topOptometryView
{
    if (!_topOptometryView) {
        _topOptometryView = [[IPCPayOrderTopOptometryView alloc]initWithFrame:CGRectMake(0, 10, self.view.jk_width-10, 82)];
        [[_topOptometryView rac_signalForSelector:@selector(insertOptometryAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            [self loadCreateOptometryView];
        }];
    }
    return _topOptometryView;
}

- (IPCPayOrderOptometryInfoView *)showOptometryView
{
    if (!_showOptometryView) {
        __weak typeof(self) weakSelf = self;
        _showOptometryView = [[IPCPayOrderOptometryInfoView alloc]initWithFrame:CGRectMake(0, self.topOptometryView.jk_bottom+10, self.view.jk_width-10, self.view.jk_height-20 - self.topOptometryView.jk_bottom)];
    }
    return _showOptometryView;
}


- (void)loadShowOptometryView
{
    [self.view addSubview:self.showOptometryView];
    [self.view addSubview:self.topOptometryView];
}

- (void)clearAllSubView
{
    [self.showOptometryView removeFromSuperview];
    self.showOptometryView = nil;
    [self.topOptometryView removeFromSuperview];
    self.topOptometryView = nil;
}

#pragma mark //Clicked Events
- (void)reload
{
    [self clearAllSubView];
    
    if ([IPCPayOrderCurrentCustomer sharedManager].currentOpometry){
        [self loadShowOptometryView];
    }
}

- (IBAction)editOptometryAction:(id)sender
{
    [self loadCreateOptometryView];
}

- (void)loadCreateOptometryView
{
    if ([[IPCPayOrderManager sharedManager] customerId])
    {
        if ([[IPCPayOrderManager sharedManager] currentCustomer].isVisitor) {
            [IPCCommonUI showError:@"游客身份不能创建验光单"];
        }else{
            __weak typeof(self) weakSelf = self;
            self.insertOptometryView = [[IPCInsertNewOptometryView alloc]initWithFrame:[IPCCommonUI currentView].bounds
                                                                            CustomerId:[[IPCPayOrderManager sharedManager] customerId]
                                                                         CompleteBlock:^(IPCOptometryMode * optometry)
                                        {
                                            [IPCPayOrderCurrentCustomer sharedManager].currentOpometry = optometry;
                                            [weakSelf reload];
                                        }];
            [[IPCCommonUI currentView] addSubview:self.insertOptometryView];
        }
    }else{
        [IPCCommonUI showError:@"请先选择客户"];
    }
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
