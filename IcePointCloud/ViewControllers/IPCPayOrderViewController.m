//
//  IPCPayOrderViewController.m
//  IcePointCloud
//
//  Created by mac on 2017/3/2.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderViewController.h"
#import "IPCEmployeListView.h"
#import "IPCPaySuccessView.h"
#import "IPCPayOrderPayTypeView.h"
//***************预售**************//
//#import "IPCPayOrderViewPreSellCellMode.h"
#import "IPCPayOrderViewNormalSellCellMode.h"

@interface IPCPayOrderViewController ()<UITableViewDelegate,UITableViewDataSource,IPCPayOrderViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *payOrderTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (strong, nonatomic) IPCEmployeListView * employeView;
@property (strong, nonatomic) IPCPaySuccessView  * paySuccessView;
//***************预售**************//
//@property (strong, nonatomic) IPCPayOrderViewPreSellCellMode * preSellCellMode;
@property (strong, nonatomic) IPCPayOrderViewNormalSellCellMode * normalSellCellMode;

@end

@implementation IPCPayOrderViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //***************预售**************//
//    self.preSellCellMode = [[IPCPayOrderViewPreSellCellMode alloc]init];
//    self.preSellCellMode.delegate = self;
    self.normalSellCellMode = [[IPCPayOrderViewNormalSellCellMode alloc]init];
    self.normalSellCellMode.delegate = self;
    
    [IPCPayOrderMode sharedManager].payType = IPCOrderPayTypePayAmount;
//    [IPCPayOrderMode sharedManager].prePayType = IPCOrderPreSellPayTypeAmount;
    
    [self.payOrderTableView setTableFooterView:[[UIView alloc]init]];
    [self.payOrderTableView setTableHeaderView:[[UIView alloc]init]];
    [self.topView addBottomLine];
    [self.bottomView addTopLine];
    [self.payButton setBackgroundColor:COLOR_RGB_BLUE];
    [self updateTotalPrice];
}


#pragma mark //Set UI
- (void)loadEmployeView{
    __weak typeof (self) weakSelf = self;
    self.employeView = [[IPCEmployeListView alloc]initWithFrame:self.view.bounds DismissBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.employeView removeFromSuperview];self.employeView = nil;
        [strongSelf.payOrderTableView reloadData];
        [strongSelf updateTotalPrice];
    }];
    [self.view addSubview:self.employeView];
    [self.view bringSubviewToFront:self.employeView];
}

- (void)showPopoverOrderBgView:(IPCOrder *)result{
    __weak typeof (self) weakSelf = self;
    self.paySuccessView = [[IPCPaySuccessView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds OrderInfo:result Dismiss:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.paySuccessView removeFromSuperview];
    }];
    [self.view addSubview:self.paySuccessView];
    [self.view bringSubviewToFront:self.paySuccessView];
    [self successPayOrder];
}

#pragma mark //Clicked Events
- (IBAction)backAction:(id)sender {
    __weak typeof (self) weakSelf = self;
    [IPCUIKit showAlert:@"冰点云" Message:@"确认退出此次订单支付吗?" Owner:self Done:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [[IPCPayOrderMode sharedManager] clearData];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


- (IBAction)onPayOrderAction:(id)sender {
    IPCPayOrderPayTypeView * payTypeView = [[IPCPayOrderPayTypeView alloc]init];
    [self.view addSubview:payTypeView];
    [self.view bringSubviewToFront:payTypeView];
    
    
//    if (! [IPCPayOrderMode sharedManager].currentEmploye) {
//        [IPCUIKit showError:@"请先选择员工"];
//    }else if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypeNone || [IPCPayOrderMode sharedManager].prePayType == IPCOrderPreSellPayTypeNone)
//    {
//        [IPCUIKit showError:@"请选择支付方式"];
//    }else if ([IPCPayOrderMode sharedManager].payStyle == IPCPayStyleTypeNone){
//        [IPCUIKit showError:@"请选择结算方式"];
//    }else if (([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypeInstallment && [IPCPayOrderMode sharedManager].prepaidAmount <= 0) || ([IPCPayOrderMode sharedManager].prePayType == IPCOrderPreSellPayTypellInstallment && [IPCPayOrderMode sharedManager].preSellPrepaidAmount <= 0))
//    {
//        [IPCUIKit showError:@"请输入预付金额"];
//    }else{
//        
//    }
}

- (void)successPayOrder{
    [[IPCPayOrderMode sharedManager] clearData];
    [[IPCShoppingCart sharedCart] removeSelectCartItem];
    [[IPCCurrentCustomerOpometry sharedManager] clearData];
}

- (void)updateTotalPrice
{
//    NSString * totalPrice = @"";
//    
//    if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypePayAmount && [IPCPayOrderMode sharedManager].prePayType == IPCOrderPreSellPayTypeAmount)
//    {
//        if ([IPCPayOrderMode sharedManager].currentEmploye && [IPCPayOrderMode sharedManager].isSelectEmploye){
//            totalPrice = [NSString stringWithFormat:@"合计：￥%.f", [IPCPayOrderMode sharedManager].employeAmount + [IPCPayOrderMode sharedManager].preEmployeAmount];
//        }else{
//            totalPrice = [NSString stringWithFormat:@"合计：￥%.f", [[IPCShoppingCart sharedCart] selectedGlassesTotalPrice]];
//        }
//    }else if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypeInstallment && [IPCPayOrderMode sharedManager].prePayType == IPCOrderPreSellPayTypellInstallment)
//    {
//        totalPrice = [NSString stringWithFormat:@"合计：￥%.f", [IPCPayOrderMode sharedManager].prepaidAmount + [IPCPayOrderMode sharedManager].preSellPrepaidAmount];
//    }else if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypePayAmount && [IPCPayOrderMode sharedManager].prePayType == IPCOrderPreSellPayTypellInstallment)
//    {
//        if ([IPCPayOrderMode sharedManager].currentEmploye && [IPCPayOrderMode sharedManager].isSelectEmploye){
//            totalPrice = [NSString stringWithFormat:@"合计：￥%.f", [IPCPayOrderMode sharedManager].employeAmount + [IPCPayOrderMode sharedManager].preSellPrepaidAmount];
//        }else{
//            totalPrice = [NSString stringWithFormat:@"合计：￥%.f", [[IPCShoppingCart sharedCart] selectedNormalSellGlassesTotalPrice] + [IPCPayOrderMode sharedManager].preSellPrepaidAmount];
//        }
//    }else if ([IPCPayOrderMode sharedManager].payType == IPCOrderPayTypeInstallment && [IPCPayOrderMode sharedManager].prePayType == IPCOrderPreSellPayTypeAmount)
//    {
//        if ([IPCPayOrderMode sharedManager].currentEmploye && [IPCPayOrderMode sharedManager].isSelectEmploye){
//            totalPrice = [NSString stringWithFormat:@"合计：￥%.f", [IPCPayOrderMode sharedManager].prepaidAmount + [IPCPayOrderMode sharedManager].preEmployeAmount];
//        }else{
//            totalPrice = [NSString stringWithFormat:@"合计：￥%.f", [IPCPayOrderMode sharedManager].prepaidAmount + [[IPCShoppingCart sharedCart] selectedPreSellGlassesTotalPrice]];
//        }
//    }else{
//        totalPrice = [NSString stringWithFormat:@"合计：￥%.f", [[IPCShoppingCart sharedCart] selectedGlassesTotalPrice]];
//    }
//
//    [self.totalPriceLabel setAttributedText:[IPCUIKit subStringWithText:totalPrice BeginRang:0 Rang:3 Font:[UIFont systemFontOfSize:14 weight:UIFontWeightThin] Color:[UIColor blackColor]]];
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //***************预售**************//
//    if ([[IPCShoppingCart sharedCart] selectedPreSellItemsCount] > 0 && [[IPCShoppingCart sharedCart] selectNormalItemsCount] > 0) {
//       return  [self.preSellCellMode numberOfSectionsInTableView:tableView];
//    }
    return [self.normalSellCellMode numberOfSectionsInTableView:tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //***************预售**************//
//    if ([[IPCShoppingCart sharedCart] selectedPreSellItemsCount] > 0 && [[IPCShoppingCart sharedCart] selectNormalItemsCount] > 0) {
//        return [self.preSellCellMode tableView:tableView numberOfRowsInSection:section];
//    }
    return [self.normalSellCellMode tableView:tableView numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //***************预售**************//
//    if ([[IPCShoppingCart sharedCart] selectedPreSellItemsCount] > 0 && [[IPCShoppingCart sharedCart] selectNormalItemsCount] > 0) {
//        return [self.preSellCellMode tableView:tableView cellForRowAtIndexPath:indexPath];
//    }
    return [self.normalSellCellMode tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //***************预售**************//
//    if ([[IPCShoppingCart sharedCart] selectedPreSellItemsCount] > 0 && [[IPCShoppingCart sharedCart] selectNormalItemsCount] > 0) {
//        return [self.preSellCellMode tableView:tableView heightForRowAtIndexPath:indexPath];
//    }
    return [self.normalSellCellMode tableView:tableView heightForRowAtIndexPath:indexPath];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //***************预售**************//
//    if (section == 4 || (section == 6 && ([[IPCShoppingCart sharedCart] selectedPreSellItemsCount] > 0 && [[IPCShoppingCart sharedCart] selectNormalItemsCount] > 0)))
//        return 0;
    if (section == 3 )
        return 0;
    return 6;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //***************预售**************//
//    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, (section == 4 || (section == 6 && ([[IPCShoppingCart sharedCart] selectedPreSellItemsCount] > 0 && [[IPCShoppingCart sharedCart] selectNormalItemsCount] > 0))) ? 0 : 6)];
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, (section == 3  ? 0 : 6))];
    [footView setBackgroundColor:[UIColor clearColor]];
    return footView;
}

#pragma mark //IPCPayOrderViewCellDelegate
- (void)showEmployeeView{
    [self loadEmployeView];
}

- (void)reloadPayOrderView{
    [self.payOrderTableView reloadData];
    [self updateTotalPrice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
