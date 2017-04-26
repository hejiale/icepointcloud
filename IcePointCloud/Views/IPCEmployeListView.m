//
//  IPCEmployeListView.m
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCEmployeListView.h"
#import "IPCEmployeListCell.h"

static NSString * const employeIdentifier = @"IPCEmployeListTableViewCellIdentifier";
typedef void(^DismissBlock)();

@interface IPCEmployeListView()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *employeBgView;
@property (weak, nonatomic) IBOutlet UITableView *employeTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (copy, nonatomic) DismissBlock dismissBlock;
@property (strong, nonatomic) NSMutableArray<IPCEmploye *> *employeeArray;

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
        
        [self.employeBgView addBorder:5 Width:0];
        [self.employeTableView setTableFooterView:[[UIView alloc]init]];
        self.employeTableView.emptyAlertImage = @"exception_search";
        self.employeTableView.emptyAlertTitle = @"没有搜索到该员工";
        
        [self.searchTextField setLeftImageView:@"text_searchIcon"];
        [IPCCustomUI show];
        [self queryEmploye];
    }
    return self;
}

- (NSMutableArray<IPCEmploye *> *)employeeArray{
    if (!_employeeArray) {
        _employeeArray = [[NSMutableArray alloc] init];
    }
    return _employeeArray;
}

#pragma mark //Network Request
- (void)queryEmploye{
    [self.employeeArray removeAllObjects];
    
    [IPCPayOrderRequestManager queryEmployeWithKeyword:self.searchTextField.text SuccessBlock:^(id responseValue)
     {
         [IPCCustomUI hiden];
         IPCEmployeList * employeList = [[IPCEmployeList alloc] initWithResponseObject:responseValue];
         [self.employeeArray addObjectsFromArray:employeList.employeArray];
         [self.employeTableView reloadData];
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
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
    
    IPCEmploye * employe = self.employeeArray[indexPath.row];
    if (employe) {
        [[IPCPayOrderMode sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.employe.jobID isEqualToString:employe.jobID]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        }];
        [cell.employeLabel setText:[NSString stringWithFormat:@"员工号:%@   员工名:%@",employe.jobNumber,employe.name]];
    }
    return cell;
}


#pragma mark //UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCEmploye * employe = self.employeeArray[indexPath.row];
    if (employe) {
        __block BOOL isExist = NO;
        [[IPCPayOrderMode sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([employe.jobID isEqualToString:obj.employe.jobID]) {
                isExist = YES;
            }
        }];
        if (!isExist){
            IPCEmployeeResult * result = [[IPCEmployeeResult alloc]init];
            result.employe = employe;
            
            if ([IPCPayOrderMode sharedManager].employeeResultArray.count == 0) {
                result.employeeResult = 100;
            }
            [[IPCPayOrderMode sharedManager].employeeResultArray addObject:result];
            
            if ([[IPCPayOrderMode sharedManager].employeeResultArray count] > 1) {
                [[IPCPayOrderMode sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.employeeResult = 0;
                }];
            }
        }
    }
    if (self.dismissBlock)
        self.dismissBlock();
}

#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self queryEmploye];
    [textField endEditing:YES];
    return YES;
}




@end
