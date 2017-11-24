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
#import "IPCInsertNewOptometryView.h"

@interface IPCPayOrderOptometryViewController ()

@property (weak, nonatomic) IBOutlet UIView *infoContentView;
@property (strong, nonatomic) IPCPayOrderOptometryInfoView    * infoView;
@property (strong, nonatomic) IPCPayOrderOptometryHeadView  * headView;
@property (strong, nonatomic) IPCPayOrderOptometryMemoView * memoView;

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

- (void)loadShowOptometryView
{
    [self.infoContentView setHidden:NO];
    [self.infoContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.infoContentView addSubview:self.headView];
    [self.infoContentView addSubview:self.infoView];
    [self.infoContentView addSubview:self.memoView];
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
        [self.infoContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.infoContentView setHidden:YES];
    }
}

- (IBAction)editOptometryAction:(id)sender {
    IPCInsertNewOptometryView * optometryView = [[IPCInsertNewOptometryView alloc]initWithFrame:self.view.superview.superview.bounds Complete:^{
        [self reload];
    }];
    [self.view.superview.superview addSubview:optometryView];
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
