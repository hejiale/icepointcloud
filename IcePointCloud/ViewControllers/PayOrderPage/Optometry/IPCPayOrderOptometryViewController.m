//
//  IPCPayOrderOptometryViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderOptometryViewController.h"
#import "IPCManagerOptometryViewController.h"
#import "IPCShowOptometryInfoView.h"
#import "IPCInsertNewOptometryView.h"

@interface IPCPayOrderOptometryViewController ()

@property (weak, nonatomic) IBOutlet UIView *infoContentView;
@property (strong, nonatomic) IPCShowOptometryInfoView * showOptometryView;

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
- (IPCShowOptometryInfoView *)showOptometryView
{
    if (!_showOptometryView) {
        __weak typeof(self) weakSelf = self;
        _showOptometryView = [[IPCShowOptometryInfoView alloc]initWithFrame:CGRectMake(20, 20, self.infoContentView.jk_width-40, self.infoContentView.jk_height-40) ChooseBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf pushToManagerOptometryViewController];
        }];
    }
    return _showOptometryView;
}


- (void)loadShowOptometryView
{
    [self.infoContentView setHidden:NO];
    [self.infoContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.infoContentView addSubview:self.showOptometryView];
}

#pragma mark //Clicked Events
- (void)reload
{
    if ([IPCCurrentCustomer sharedManager].currentOpometry) {
        [self loadShowOptometryView];
        [self.showOptometryView updateOptometryInfo];
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
