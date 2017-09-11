//
//  IPCEmployeeListView.m
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCEmployeListView.h"
#import "IPCEmployeListCell.h"

static NSString * const employeIdentifier = @"IPCEmployeeListTableViewCellIdentifier";
typedef void(^DismissBlock)();

@interface IPCEmployeListView()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *employeBgView;
@property (weak, nonatomic) IBOutlet UITableView *employeTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (copy, nonatomic) DismissBlock dismissBlock;
@property (strong, nonatomic) NSMutableArray<IPCEmployee *> *employeeArray;
@property (strong, nonatomic) IPCRefreshAnimationHeader * refreshHeader;

@end

@implementation IPCEmployeListView


- (instancetype)initWithFrame:(CGRect)frame DismissBlock:(void(^)())dismiss
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dismissBlock = dismiss;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCEmployeListView" owner:self];
        view.frame = frame;
        [self addSubview:view];
        
        [self.employeBgView addBorder:5 Width:0 Color:nil];
        [self.searchTextField setLeftImageView:@"text_searchIcon"];
        
        [self.employeTableView setTableFooterView:[[UIView alloc]init]];
        self.employeTableView.emptyAlertImage = @"exception_search";
        self.employeTableView.emptyAlertTitle = @"没有搜索到该员工";
        self.employeTableView.mj_header = self.refreshHeader;
        [self.refreshHeader beginRefreshing];
    }
    return self;
}

- (NSMutableArray<IPCEmployee *> *)employeeArray{
    if (!_employeeArray) {
        _employeeArray = [[NSMutableArray alloc] init];
    }
    return _employeeArray;
}

#pragma mark //Set UI
- (IPCRefreshAnimationHeader *)refreshHeader{
    if (!_refreshHeader) {
        _refreshHeader = [IPCRefreshAnimationHeader headerWithRefreshingTarget:self refreshingAction:@selector(queryEmploye)];
    }
    return  _refreshHeader;
}

#pragma mark //Network Request
- (void)queryEmploye{
    [self.employeeArray removeAllObjects];
    
    [IPCPayOrderRequestManager queryEmployeWithKeyword:self.searchTextField.text SuccessBlock:^(id responseValue)
     {
         IPCEmployeeList * employeList = [[IPCEmployeeList alloc] initWithResponseObject:responseValue];
         [self.employeeArray addObjectsFromArray:employeList.employeArray];
         [self.employeTableView reloadData];
         [self.refreshHeader endRefreshing];
     } FailureBlock:^(NSError *error) {
         [IPCCommonUI showInfo:@"查询员工信息失败！"];
     }];
}

#pragma mark //Clicked Events
- (IBAction)backAction:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}


#pragma mark //UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.employeeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCEmployeListCell * cell = [tableView dequeueReusableCellWithIdentifier:employeIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCEmployeListCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    IPCEmployee * employe = self.employeeArray[indexPath.row];
    if (employe) {
        [[IPCPayOrderManager sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.employee.jobID isEqualToString:employe.jobID]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        }];
        [cell.employeLabel setText:[NSString stringWithFormat:@"员工号:%@   员工名:%@",employe.jobNumber,employe.name]];
    }
    return cell;
}


#pragma mark //UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCEmployee * employe = self.employeeArray[indexPath.row];
    if (employe) {
        if ([IPCPayOrderManager sharedManager].employeeResultArray.count == 5){
            [IPCCommonUI showInfo:@"至多选择五名员工"];
            return;
        }

        __block BOOL isExist = NO;
        [[IPCPayOrderManager sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([employe.jobID isEqualToString:obj.employee.jobID]) {
                isExist = YES;
            }
        }];
        if (!isExist){
            IPCEmployeeResult * result = [[IPCEmployeeResult alloc]init];
            result.employee = employe;
            
            if ([IPCPayOrderManager sharedManager].employeeResultArray.count == 0) {
                result.achievement = 100;
            }
            [[IPCPayOrderManager sharedManager].employeeResultArray addObject:result];
            
            if ([[IPCPayOrderManager sharedManager].employeeResultArray count] > 1) {
                [[IPCPayOrderManager sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.achievement = 0;
                }];
            }
        }
    }
    if (self.dismissBlock)
        self.dismissBlock();
}

#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.refreshHeader beginRefreshing];
    [textField endEditing:YES];
    return YES;
}




@end
