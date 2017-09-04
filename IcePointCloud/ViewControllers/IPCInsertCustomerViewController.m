//
//  UserInfoViewController.m
//  IcePointCloud
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCInsertCustomerViewController.h"
#import "IPCSearchCustomerViewController.h"
#import "IPCCustomTopCell.h"
#import "IPCInsertCustomerBaseCell.h"
#import "IPCInsertCustomerOpometryCell.h"
#import "IPCInsertCustomerAddressCell.h"
#import "IPCInsertCustomerViewModel.h"

static NSString * const topIdentifier           = @"IPCCustomTopCellIdentifier";
static NSString * const baseIdentifier         = @"IPCInsertCustomerBaseCellIdentifier";
static NSString * const opometryIdentifier = @"IPCInsertCustomerOpometryCellIdentifier";
static NSString * const addressIdentifier    = @"IPCInsertCustomerAddressCellIdentifier";

@interface IPCInsertCustomerViewController ()<UITableViewDelegate,UITableViewDataSource,UserBaseInfoCellDelegate,IPCInsertCustomerOpometryCellDelegate>

@property (weak,   nonatomic) IBOutlet UITableView *userInfoTableView;
@property (strong, nonatomic) IBOutlet UIView *tableFootView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IPCInsertCustomerViewModel * insertCustomerModel;

@end

@implementation IPCInsertCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.insertCustomerModel = [[IPCInsertCustomerViewModel alloc]init];
    
    [self.userInfoTableView setTableFooterView:self.tableFootView];
    
    [[self rac_signalForSelector:@selector(backAction)] subscribeNext:^(RACTuple * _Nullable x) {
        [[IPCInsertCustomer instance] resetData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationTitle:@"新增客户"];
    [self setNavigationBarStatus:NO];
    [self.userInfoTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}


#pragma mark //Clicked Events
- (IBAction)insertNewCustomerAction:(id)sender {
    [[IPCInsertCustomer instance] resetData];
    [self.userInfoTableView reloadData];
}


- (IBAction)saveNewCustomerAction:(id)sender
{
    if ([IPCInsertCustomer instance].customerName.length && [IPCInsertCustomer instance].customerPhone.length) {
        [self.saveButton jk_showIndicator];
        __weak typeof(self) weakSelf = self;
        [self.insertCustomerModel saveNewCustomer:^(NSString *customerId){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.saveButton jk_hideIndicator];
            
            if ([customerId integerValue] > 0 && customerId) {
                if ([IPCPayOrderManager sharedManager].isPayOrderStatus)
                {
                    [[IPCPayOrderManager sharedManager] resetPayPrice];
                    [IPCPayOrderManager sharedManager].currentCustomerId = customerId;
                    [[NSNotificationCenter defaultCenter]postNotificationName:IPCChooseCustomerNotification object:nil];
                    [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }else{
        [IPCCommonUI showError:@"请输入完整客户名或手机号!"];
    }
}

- (void)selectIntroducerMethod{
    IPCSearchCustomerViewController * searchCustomerVC = [[IPCSearchCustomerViewController alloc]initWithNibName:@"IPCSearchCustomerViewController" bundle:nil];
    [self.navigationController pushViewController:searchCustomerVC animated:YES];
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return [IPCInsertCustomer instance].optometryArray.count + 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:topIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setLeftTitle:@"客户基本信息"];
            return cell;
        }else{
            IPCInsertCustomerBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:baseIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCInsertCustomerBaseCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
                cell.delegate = self;
            }
            __weak typeof(self) weakSelf = self;
            [[cell rac_signalForSelector:@selector(showCustomerListAction)] subscribeNext:^(RACTuple * _Nullable x) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf selectIntroducerMethod];
            }];
            return cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:topIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setLeftTitle:@"收货地址"];
            return cell;
        }else{
            IPCInsertCustomerAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:addressIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCInsertCustomerAddressCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:topIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setRightOperation:@"验光单" AttributedTitle:nil ButtonTitle:nil ButtonImage:@"icon_insert_btn"];
            [[cell rac_signalForSelector:@selector(rightButtonAction:)] subscribeNext:^(id x) {
                [[IPCInsertCustomer instance].optometryArray addObject:[[IPCOptometryMode alloc]init]];
                [tableView reloadData];
                [tableView scrollToBottom];
            }];
            return cell;
        }else{
            IPCInsertCustomerOpometryCell * cell = [tableView dequeueReusableCellWithIdentifier:opometryIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCInsertCustomerOpometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
                cell.delegate = self;
            }
    
            if ([IPCInsertCustomer instance].optometryArray.count) {
                IPCOptometryMode * optometry = [IPCInsertCustomer instance].optometryArray[indexPath.row-1];
                cell.optometryMode = optometry;
                
                if (indexPath.row == 1) {
                    [cell.removeButton setHidden:YES];
                }else{
                    [cell.removeButton setHidden:NO];
                    
                }
                [[cell rac_signalForSelector:@selector(removeOptometryAction:)] subscribeNext:^(id x) {
                    [[IPCInsertCustomer instance] .optometryArray removeObjectAtIndex:indexPath.row-1];
                    [tableView reloadData];
                }];
            }
            return cell;
        }
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row > 0){
        if ([IPCInsertCustomer instance].isPackUp) {
            if ([[IPCInsertCustomer instance].customerType isEqualToString:@"转介绍"]) {
                return 360;
            }
            return 310;
        }
        return 180;
    }else if (indexPath.section == 1 && indexPath.row > 0)
        return 100;
    else if (indexPath.section == 2 && indexPath.row > 0)
        return 175;
    return 50;
}

#pragma mark //UserBaseInfoCellDelegate
- (void)reloadInsertCustomUI{
    [self.userInfoTableView reloadData];
}

- (void)judgePhone:(NSString *)phone{
    [IPCCommonUI show];
    __weak typeof(self) weakSelf = self;
    [self.insertCustomerModel judgeCustomerPhone:phone :^{
        [IPCCommonUI hiden];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [IPCInsertCustomer instance].customerPhone = phone;
        [strongSelf.userInfoTableView reloadData];
    }];
}

#pragma mark //IPCInsertCustomerOpometryCellDelegate
- (void)updateOptometryMode:(IPCOptometryMode *)optometry Cell:(IPCInsertCustomerOpometryCell *)cell{
    NSIndexPath * indexPath = [self.userInfoTableView indexPathForCell:cell];
    if ([IPCInsertCustomer instance].optometryArray.count) {
        [[IPCInsertCustomer instance].optometryArray replaceObjectAtIndex:indexPath.row-1 withObject:optometry];
    }
    [self.userInfoTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
