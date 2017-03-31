//
//  MainRootViewController.m
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCRootViewController.h"
#import "IPCTryGlassesViewController.h"
#import "IPCHelpViewController.h"
#import "IPCGlassListViewController.h"
#import "IPCCustomerViewController.h"
#import "IPCPayOrderViewController.h"
#import "IPCRootBarMenuView.h"

@interface IPCRootViewController ()<IPCRootMenuViewControllerDelegate>

@property (nonatomic, strong) IPCGlassListViewController * productVC;
@property (nonatomic, strong) IPCTryGlassesViewController *tryVC;
@property (nonatomic, strong) IPCCustomerViewController * customerInfoVC;
@property (nonatomic, strong) IPCRootBarMenuView * menuView;

@end

@implementation IPCRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.delegate = self;
    
    _productVC = [[IPCGlassListViewController alloc]initWithNibName:@"IPCGlassListViewController" bundle:nil];
    _tryVC =  [[IPCTryGlassesViewController alloc] initWithNibName:@"IPCTryGlassesViewController" bundle:nil];
    _customerInfoVC = [[IPCCustomerViewController alloc]initWithNibName:@"IPCCustomerViewController" bundle:nil];
    [self setViewControllers:@[_productVC, _customerInfoVC,_tryVC]];
}

#pragma mark //Clicked Events
- (void)removeCover{
    [self.menuView removeFromSuperview];
    [self removerFilterCover];
    [self.productVC reload];
    [self.tryVC reload];
}

- (void)removerFilterCover{
    [self.productVC removeCover];
    [self.tryVC removeAllPopView];
}


#pragma mark //Show Methods
- (void)showHelpViewController{
    [self removeCover];
    IPCHelpViewController * helpVC = [[IPCHelpViewController alloc]initWithNibName:@"IPCHelpViewController" bundle:nil];
    [self.navigationController pushViewController:helpVC animated:YES];
}

- (void)popToLoginViewController{
    [self removeCover];
    [[IPCAppManager sharedManager] logout];
}

- (void)pushToPayOrderViewController{
    [self removeCover];
    if ([IPCCurrentCustomerOpometry sharedManager].currentCustomer && [IPCCurrentCustomerOpometry sharedManager].currentAddress &&[IPCCurrentCustomerOpometry sharedManager].currentOpometry)
    {
        IPCPayOrderViewController * payOrderVC = [[IPCPayOrderViewController alloc]initWithNibName:@"IPCPayOrderViewController" bundle:nil];
        [self.navigationController pushViewController:payOrderVC animated:YES];
    }else{
        [IPCCustomUI showAlert:@"冰点云" Message:@"请先前去验光页面选择客户验光信息!" Owner:self Done:^{
            [self setSelectedIndex:2];
        }];
    }
}

- (void)showMenuView:(NSInteger)index{
    [self removerFilterCover];
    _menuView = [[IPCRootBarMenuView alloc]initWithFrame:self.view.bounds
                                               MenuIndex:index
                                                PayOrder:^{
                                                    [self pushToPayOrderViewController];
                                                } Logout:^{
                                                    [self popToLoginViewController];
                                                } Help:^{
                                                    [self showHelpViewController];
                                                } Dismiss:^{
                                                    [self removeCover];
                                                }];
    [self.view addSubview:_menuView];
}

#pragma mark //RootMenuViewControllerDelegate
- (void)tabBarController:(IPCTabBarViewController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 1) {
        [self.productVC addNotifications];
    }else if (tabBarController.selectedIndex == 3){
        [self.tryVC addTryNotifications];
    }
}

- (void)tabBarControllerNoneChange:(IPCTabBarViewController *)tabBarController TabBarIndex:(NSInteger)tabBarIndex
{
    if (tabBarIndex == 1) {
        [self.productVC rootRefresh];
    }else if (tabBarIndex == 3){
        [self.tryVC rootRefresh];
    }else if (tabBarIndex == 4 || tabBarIndex == 5){
        [self showMenuView:tabBarIndex];
    }
}

- (void)judgeIsInsertNewCustomer:(NSInteger)index{
    if ([self.selectedViewController isKindOfClass:[IPCCustomerViewController class]] && self.selectedViewController)
    {
        __weak typeof (self) weakSelf = self;
        IPCCustomerViewController * currentUserVC = (IPCCustomerViewController *)self.selectedViewController;
        if (currentUserVC.isInserting) {
            [IPCCustomUI showAlert:@"冰点云" Message:@"您正在新增验光数据，如果点击确定，客户验光记录将丢失，确定清空吗？" Owner:self Done:^{
                __strong typeof (weakSelf) strongSelf = weakSelf;
                [currentUserVC toExitInsertCustomer];
                [strongSelf setSelectedIndex:index];
            }];
        }else{
            [self setSelectedIndex:index];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
