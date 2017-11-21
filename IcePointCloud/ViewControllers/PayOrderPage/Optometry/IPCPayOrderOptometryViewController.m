//
//  IPCPayOrderOptometryViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderOptometryViewController.h"
#import "IPCManagerOptometryViewController.h"
#import "IPCPayOrderOptometryHeadView.h"
#import "IPCPayOrderOptometryInfoView.h"
#import "IPCPayOrderOptometryMemoView.h"
#import "IPCPayOrderInputOptometryHeadView.h"
#import "IPCPayOrderInputOptometryView.h"
#import "IPCPayOrderInputOptometryMemoView.h"

@interface IPCPayOrderOptometryViewController ()

@property (strong, nonatomic) IPCPayOrderOptometryInfoView    * infoView;
@property (strong, nonatomic) IPCPayOrderOptometryHeadView  * headView;
@property (strong, nonatomic) IPCPayOrderOptometryMemoView * memoView;

@property (strong, nonatomic) IPCPayOrderInputOptometryHeadView  * inputHeadView;
@property (strong, nonatomic) IPCPayOrderInputOptometryView          * inputInfoView;
@property (strong, nonatomic) IPCPayOrderInputOptometryMemoView * inputMemoView;

@end

@implementation IPCPayOrderOptometryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self reload];
}

#pragma mark //Set UI
- (IPCPayOrderOptometryHeadView *)headView
{
    if (!_headView) {
        __weak typeof(self) weakSelf = self;
        _headView = [[IPCPayOrderOptometryHeadView alloc]initWithFrame:CGRectMake(20, 20, self.view.jk_width-40, 150) ChooseBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf pushToManagerOptometryViewController];
        }];
    }
    return _headView;
}

- (IPCPayOrderOptometryInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [[IPCPayOrderOptometryInfoView alloc]initWithFrame:CGRectMake(20, self.headView.jk_bottom+20, self.view.jk_width-40, 375)];
    }
    return _infoView;
}

- (IPCPayOrderOptometryMemoView *)memoView
{
    if (!_memoView) {
        _memoView = [[IPCPayOrderOptometryMemoView alloc]initWithFrame:CGRectMake(20, self.infoView.jk_bottom+20, self.view.jk_width-40, 60)];
    }
    return _memoView;
}

- (IPCPayOrderInputOptometryHeadView *)inputHeadView
{
    if (!_inputHeadView) {
        _inputHeadView = [[IPCPayOrderInputOptometryHeadView alloc]initWithFrame:CGRectMake(0, 20, self.view.jk_width-20, 150)];
    }
    return _inputHeadView;
}

- (IPCPayOrderInputOptometryView *)inputInfoView
{
    if (!_inputInfoView) {
        _inputInfoView = [[IPCPayOrderInputOptometryView alloc]initWithFrame:CGRectMake(0, self.inputHeadView.jk_bottom+20, self.view.jk_width-20, 375)];
    }
    return _inputInfoView;
}

- (IPCPayOrderInputOptometryMemoView *)inputMemoView
{
    if (!_inputMemoView) {
        _inputMemoView = [[IPCPayOrderInputOptometryMemoView alloc]initWithFrame:CGRectMake(0, _inputInfoView.jk_bottom+20, self.view.jk_width-20, 60)];
    }
    return _inputMemoView;
}

- (void)loadShowOptometryView
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.infoView];
    [self.view addSubview:self.memoView];
}

- (void)loadInputOptometryView
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.view addSubview:self.inputHeadView];
    [self.view addSubview:self.inputInfoView];
    [self.view addSubview:self.inputMemoView];
}

#pragma mark //Clicked Events
- (void)reload
{
    if ([IPCCurrentCustomer sharedManager].currentOpometry) {
        [self loadShowOptometryView];
        [self.infoView updateOptometryInfo];
        [self.headView updateOptometryInfo];
        [self.memoView updateOptometryInfo];
    }else{
        [self loadInputOptometryView];
        [self.inputInfoView updateInsertOptometry];
        [self.inputHeadView updateInsertOptometryInfo];
    }
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
