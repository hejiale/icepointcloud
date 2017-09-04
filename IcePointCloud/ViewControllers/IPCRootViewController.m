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
#import "IPCPayOrderViewController.h"
#import "IPCSearchCustomerViewController.h"
#import "IPCSideBarMenuView.h"

@interface IPCRootViewController ()<IPCRootMenuViewControllerDelegate>

@property (nonatomic, strong) IPCGlassListViewController * productVC;
@property (nonatomic, strong) IPCTryGlassesViewController *tryVC;
@property (nonatomic, strong) IPCSearchCustomerViewController * customerInfoVC;
@property (nonatomic, strong) IPCPayOrderViewController * payOrderVC;
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
    _payOrderVC       = [[IPCPayOrderViewController alloc]initWithNibName:@"IPCPayOrderViewController" bundle:nil];
    
    [self setViewControllers:@[_productVC, _customerInfoVC,_tryVC,_payOrderVC]];
    
    __weak typeof(self) weakSelf = self;
    [[self rac_signalForSelector:@selector(filterProductAction)] subscribeNext:^(RACTuple * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.selectedIndex == 1) {
            [strongSelf.productVC onFilterProducts];
        }else if (strongSelf.selectedIndex == 3){
            [strongSelf.tryVC onFilterProducts];
        }
    }];
}

#pragma mark //Clicked Events
- (void)removeCover{
    [self.sideBarView removeFromSuperview];
    [self removerFilterCover];
}

- (void)removerFilterCover{
    [self.productVC removeCover];
    [self.tryVC removeCover];
}


//Show Methods
- (void)showSideBarView:(NSInteger)index{
    [self removerFilterCover];
    _sideBarView = [[IPCSideBarMenuView alloc]initWithFrame:self.view.bounds
                                                  MenuIndex:index
                                                     Logout:^{
                                                         [[IPCAppManager sharedManager] logout];
                                                     } Dismiss:^{
                                                         [self removeCover];
                                                     }];
    [self.view addSubview:_sideBarView];
}

#pragma mark //RootMenuViewControllerDelegate
- (void)tabBarController:(IPCTabBarViewController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}

- (void)tabBarController:(IPCTabBarViewController *)tabBarController didSelectIndex:(NSInteger)index
{
    if (index == 0) {
        if (self.selectedIndex == 1) {
            [self.productVC onSearchProducts];
        }else if (self.selectedIndex == 3){
            [self.tryVC onSearchProducts];
        }
    }else if (index == 5){
        [self showSideBarView:index];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
