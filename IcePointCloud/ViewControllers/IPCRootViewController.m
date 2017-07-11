//
//  MainRootViewController.m
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCRootViewController.h"
#import "IPCTryGlassesViewController.h"
#import "IPCGlassListViewController.h"
#import "IPCSearchCustomerViewController.h"
#import "IPCPayOrderViewController.h"
#import "IPCSideBarMenuView.h"

@interface IPCRootViewController ()<IPCRootMenuViewControllerDelegate>

@property (nonatomic, strong) IPCGlassListViewController * productVC;
@property (nonatomic, strong) IPCTryGlassesViewController *tryVC;
@property (nonatomic, strong) IPCSearchCustomerViewController * customerInfoVC;
@property (nonatomic, strong) IPCSideBarMenuView * sideBarView;

@end

@implementation IPCRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.delegate = self;
    
    _productVC         =  [[IPCGlassListViewController alloc]initWithNibName:@"IPCGlassListViewController" bundle:nil];
    _tryVC                 =  [[IPCTryGlassesViewController alloc] initWithNibName:@"IPCTryGlassesViewController" bundle:nil];
    _customerInfoVC =  [[IPCSearchCustomerViewController alloc]initWithNibName:@"IPCSearchCustomerViewController" bundle:nil];
    
    [self setViewControllers:@[_productVC, _customerInfoVC,_tryVC]];
    
    __weak typeof(self) weakSelf = self;
    [[self rac_signalForSelector:@selector(filterProductAction)] subscribeNext:^(RACTuple * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.selectedIndex == 1) {
            [strongSelf.productVC onFilterProducts];
        }else if (strongSelf.selectedIndex == 3){
            [strongSelf.tryVC onFilterProducts];
        }
    }];
    
    [[self rac_signalForSelector:@selector(searchProductAction)] subscribeNext:^(RACTuple * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.selectedIndex == 1) {
            [strongSelf.productVC onSearchProducts];
        }else if (strongSelf.selectedIndex == 3){
            [strongSelf.tryVC onSearchProducts];
        }
    }];
}

#pragma mark //Clicked Events
- (void)removeCover{
    [self.sideBarView removeFromSuperview];
    [self removerFilterCover];
    [self.productVC reload];
    [self.tryVC reload];
}

- (void)removerFilterCover{
    [self.productVC removeCover];
    [self.tryVC removeCover];
}


//Show Methods
- (void)pushToPayOrderViewController{
    [self removeCover];
    IPCPayOrderViewController * payOrderVC = [[IPCPayOrderViewController alloc]initWithNibName:@"IPCPayOrderViewController" bundle:nil];
    [self.navigationController pushViewController:payOrderVC animated:YES];
}

- (void)showSideBarView:(NSInteger)index{
    [self removerFilterCover];
    _sideBarView = [[IPCSideBarMenuView alloc]initWithFrame:self.view.bounds
                                               MenuIndex:index
                                                PayOrder:^{
                                                    [self pushToPayOrderViewController];
                                                } Logout:^{
                                                    [[IPCAppManager sharedManager] logout];
                                                } Dismiss:^{
                                                    [self removeCover];
                                                }];
    [self.view addSubview:_sideBarView];
}

#pragma mark //RootMenuViewControllerDelegate
- (void)tabBarController:(IPCTabBarViewController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (self.selectedIndex == 4 || self.selectedIndex == 5){
        [self showSideBarView:self.selectedIndex];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
