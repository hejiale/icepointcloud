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
//#import "IPCCustomerListViewController.h"
#import "IPCScanCodeViewController.h"
#import "IPCSideBarMenuView.h"

@interface IPCRootViewController ()<IPCRootMenuViewControllerDelegate>

@property (nonatomic, strong) IPCGlassListViewController * productVC;
@property (nonatomic, strong) IPCTryGlassesViewController *tryVC;
//@property (nonatomic, strong) IPCCustomerListViewController * customerInfoVC;
@property (nonatomic, strong) IPCPayOrderViewController * payOrderVC;
@property (nonatomic, strong) IPCPortraitNavigationViewController * cameraNav;

@end

@implementation IPCRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.productVC         =  [[IPCGlassListViewController alloc]initWithNibName:@"IPCGlassListViewController" bundle:nil];
    self.tryVC                 =  [[IPCTryGlassesViewController alloc] initWithNibName:@"IPCTryGlassesViewController" bundle:nil];
//    self.customerInfoVC =  [[IPCCustomerListViewController alloc]initWithNibName:@"IPCCustomerListViewController" bundle:nil];
    self.payOrderVC       =  [[IPCPayOrderViewController alloc]initWithNibName:@"IPCPayOrderViewController" bundle:nil];
    
    [self setViewControllers:@[self.productVC,self.tryVC,self.payOrderVC]];
    
    __weak typeof(self) weakSelf = self;
    [[self rac_signalForSelector:@selector(filterProductAction)] subscribeNext:^(RACTuple * _Nullable x)
     {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (weakSelf.selectedIndex == 1) {
            [strongSelf.productVC onFilterProducts];
        }else if (weakSelf.selectedIndex == 3){
            [strongSelf.tryVC onFilterProducts];
        }
    }];
    
    [[self rac_signalForSelector:@selector(scanProductAction)] subscribeNext:^(RACTuple * _Nullable x)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        IPCScanCodeViewController *scanVc = [[IPCScanCodeViewController alloc] initWithFinish:^(NSString *result, NSError *error)
        {
            [strongSelf.cameraNav dismissViewControllerAnimated:YES completion:nil];
            
            [IPCAppManager sharedManager].isSelectProductCode = YES;
            [strongSelf.productVC searchProductWithCode:result];
        }];
        strongSelf.cameraNav = [[IPCPortraitNavigationViewController alloc]initWithRootViewController:scanVc];
        [weakSelf presentViewController:strongSelf.cameraNav animated:YES completion:nil];
    }];
    
    ///清除之前版本搜索数据
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"IPCListSearchHistoryKey"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IPCListSearchHistoryKey"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"IPSearchCustomerkey"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IPSearchCustomerkey"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark //Clicked Events
//Show Methods
- (void)showSideBarView
{
    [self.productVC removeCover];
    [self.tryVC removeCover];
   
    IPCSideBarMenuView * sideBarView = [[IPCSideBarMenuView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:sideBarView];
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
        }else if (self.selectedIndex == 2){
            [self.tryVC onSearchProducts];
        }
    }else if (index == 4){
        [self showSideBarView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.view = nil;
    self.productVC = nil;
    self.tryVC = nil;
//    self.customerInfoVC = nil;
    self.payOrderVC = nil;
}



@end
