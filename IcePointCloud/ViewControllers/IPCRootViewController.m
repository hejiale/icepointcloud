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
#import "IPCPersonBaseView.h"
#import "IPCUpdatePasswordView.h"
#import "IPCQRCodeView.h"
#import "IPCShoppingCartView.h"
#import "IPCPayOrderViewController.h"

@interface IPCRootViewController ()<IPCRootMenuViewControllerDelegate>

@property (nonatomic, strong) IPCGlassListViewController * productVC;
@property (nonatomic, strong) IPCTryGlassesViewController *tryVC;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IPCShoppingCartView * cartView;

@end

@implementation IPCRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.delegate = self;
    
    _productVC = [[IPCGlassListViewController alloc]initWithNibName:@"IPCGlassListViewController" bundle:nil];
    _tryVC =  [[IPCTryGlassesViewController alloc] initWithNibName:@"IPCTryGlassesViewController" bundle:nil];
    IPCCustomerViewController * userInfoVC = [[IPCCustomerViewController alloc]initWithNibName:@"IPCCustomerViewController" bundle:nil];
    [self setViewControllers:@[_productVC, userInfoVC,_tryVC]];
}

#pragma mark //Clicked Events
- (IBAction)dismissAction:(id)sender {
    [self removeAllSubViews];
}


- (void)removeAllSubViews{
    [self.backgroundView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag != 1 && obj)
            [obj removeFromSuperview];
    }];
    [self.backgroundView removeFromSuperview];
    [self.productVC reload];
}


#pragma mark //Show Methods
- (void)showUpdateViewController{
    IPCUpdatePasswordView * updateView = [UIView jk_loadInstanceFromNibWithName:@"IPCUpdatePasswordView" owner:self];
    [self.backgroundView addSubview:updateView];
    [updateView setFrame:CGRectMake(self.backgroundView.jk_width, 0, updateView.jk_width, updateView.jk_height)];
    [updateView showWithClose:^{
        [updateView removeFromSuperview];
    }];
}

- (void)showQRCodeView{
    IPCQRCodeView * codeView = [UIView jk_loadInstanceFromNibWithName:@"IPCQRCodeView" owner:self];
    [self.backgroundView addSubview:codeView];
    [codeView setFrame:CGRectMake(self.backgroundView.jk_width, 0, codeView.jk_width, codeView.jk_height)];
    [codeView showWithClose:^{
        [codeView removeFromSuperview];
    }];
}

- (void)showHelpViewController{
    IPCHelpViewController * helpVC = [[IPCHelpViewController alloc]initWithNibName:@"IPCHelpViewController" bundle:nil];
    [self.navigationController pushViewController:helpVC animated:YES];
}

- (void)popToLoginViewController{
    [[IPCAppManager sharedManager] logout];
}

- (void)pushToPayOrderViewController{
    if ([IPCCurrentCustomerOpometry sharedManager].currentCustomer && [IPCCurrentCustomerOpometry sharedManager].currentAddress &&[IPCCurrentCustomerOpometry sharedManager].currentOpometry)
    {
        IPCPayOrderViewController * payOrderVC = [[IPCPayOrderViewController alloc]initWithNibName:@"IPCPayOrderViewController" bundle:nil];
        [self.navigationController pushViewController:payOrderVC animated:YES];
    }else{
        [IPCUIKit showAlert:@"冰点云" Message:@"请先前去验光页面选择客户验光信息!" Owner:self Done:^{
            [self removeAllSubViews];
            [self setSelectedIndex:2];
        }];
    }
}

#pragma mark //RootMenuViewControllerDelegate
- (void)tabBarController:(IPCRootMenuViewController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 1) {
        [self.productVC addNotifications];
    }else if (tabBarController.selectedIndex == 3){
        [self.tryVC addTryNotifications];
    }
}

- (void)tabBarControllerNoneChange:(IPCRootMenuViewController *)tabBarController{
    if (tabBarController.selectedIndex == 1) {
        [self.productVC rootRefresh];
    }else if (tabBarController.selectedIndex == 3){
        [self.tryVC rootRefresh];
    }
}

- (void)showShoppingCartView{
    [self.productVC removeCover];[self.tryVC removeAllPopView];
    [self.view addSubview:self.backgroundView];
    [self.backgroundView setFrame:self.view.bounds];
    [self.view bringSubviewToFront:self.backgroundView];
    __weak typeof (self) weakSelf = self;
    
    _cartView = [UIView jk_loadInstanceFromNibWithName:@"IPCShoppingCartView" owner:self];
    [_cartView setFrame:CGRectMake(self.backgroundView.jk_width, 0, _cartView.jk_width, _cartView.jk_height)];
    [self.backgroundView addSubview:_cartView];
    [_cartView showWithPay:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf pushToPayOrderViewController];
    }];
}

- (void)showPersonView{
    [self.productVC removeCover];[self.tryVC removeAllPopView];
    [self.view addSubview:self.backgroundView];
    [self.backgroundView setFrame:self.view.bounds]; 
    [self.view bringSubviewToFront:self.backgroundView];
    __weak typeof (self) weakSelf = self;
    
    IPCPersonBaseView * personView = [UIView jk_loadInstanceFromNibWithName:@"IPCPersonBaseView" owner:self];
    [personView setFrame:CGRectMake(self.backgroundView.jk_width, 0, personView.jk_width, personView.jk_height)];
    [self.backgroundView addSubview:personView];
    
    [personView showWithClose:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf removeAllSubViews];
    } Logout:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf popToLoginViewController];
    } ShowLibrary:nil
      UpdateBlock:^{
          __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf showUpdateViewController];
    } QRCodeBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf showQRCodeView];
    } HelpBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf showHelpViewController];
    }];
}


- (void)judgeIsInsertNewCustomer:(NSInteger)index{
    if ([self.selectedViewController isKindOfClass:[IPCCustomerViewController class]] && self.selectedViewController)
    {
        __weak typeof (self) weakSelf = self;
        IPCCustomerViewController * currentUserVC = (IPCCustomerViewController *)self.selectedViewController;
        if (currentUserVC.isInserting) {
            [IPCUIKit showAlert:@"冰点云" Message:@"您正在新增验光数据，如果点击确定，客户验光记录将丢失，确定清空吗？" Owner:self Done:^{
                __strong typeof (weakSelf) strongSelf = weakSelf;
                [currentUserVC toExitInsertCustomer];
                [strongSelf setSelectedIndex:index];
            }];
        }else{
            [self setSelectedIndex:index];
        }
    }else{
        [self setSelectedIndex:index];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
