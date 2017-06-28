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

static NSString * const topIdentifier = @"UserBaseTopTitleCellIdentifier";
static NSString * const baseIdentifier = @"UserBaseInfoCellIdentifier";
static NSString * const opometryIdentifier = @"UserBaseOpometryCellIdentifier";
static NSString * const addressIdentifier = @"IPCInsertCustomerAddressCellIdentifier";

@interface IPCInsertCustomerViewController ()<UITableViewDelegate,UITableViewDataSource,UserBaseInfoCellDelegate,IPCInsertCustomerOpometryCellDelegate>
{
    BOOL  isPackUping;
}

@property (weak,   nonatomic) IBOutlet UITableView *userInfoTableView;
@property (strong, nonatomic) IBOutlet UIView *tableFootView;

@end

@implementation IPCInsertCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setBackground];
    [[self rac_signalForSelector:@selector(backAction)] subscribeNext:^(RACTuple * _Nullable x) {
        [[IPCInsertCustomer instance] resetData];
    }];
    [self.userInfoTableView setTableFooterView:self.tableFootView];
    
    [[IPCEmployeeeManager sharedManager] queryEmploye:@""];
    [[IPCEmployeeeManager sharedManager] queryMemberLevel];
    [[IPCEmployeeeManager sharedManager] queryCustomerType];
    
    [[IPCInsertCustomer instance] resetData];
    [IPCInsertCustomer instance].isInsertStatus = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationTitle:@"新增客户"];
    [self setNavigationBarStatus:NO];
    [self.userInfoTableView reloadData];
}

#pragma mark //Request Data
- (void)saveNewCustomerRequest
{
    if (![IPCInsertCustomer instance].memberLevel.length) {
        IPCMemberLevel * memberLevelMode = [IPCEmployeeeManager sharedManager].memberLevelList.list[0];
        [IPCInsertCustomer instance].memberLevel = memberLevelMode.memberLevel;
        [IPCInsertCustomer instance].memberLevelId = memberLevelMode.memberLevelId;
    }
    if (![IPCInsertCustomer instance].customerType.length) {
        __block IPCCustomerType * customerType = [IPCEmployeeeManager sharedManager].customerTypeList.list[0];
        [IPCInsertCustomer instance].customerType = @"自然进店";
        [[IPCEmployeeeManager sharedManager].customerTypeList.list enumerateObjectsUsingBlock:^(IPCCustomerType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.customerType isEqualToString:@"自然进店"]) {
                [IPCInsertCustomer instance].customerTypeId = obj.customerTypeId;
            }
        }];
    }
    
    NSMutableArray * optometryList = [[NSMutableArray alloc]init];
    [[IPCInsertCustomer instance].optometryArray enumerateObjectsUsingBlock:^(IPCOptometryMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * optometryDic = [[NSMutableDictionary alloc]init];
        [optometryDic setDictionary:@{
                                      @"distanceRight": obj.distanceRight,
                                      @"distanceLeft":obj.distanceLeft,
                                      @"sphLeft": (obj.sphLeft ?  : @""),
                                      @"sphRight":(obj.sphRight ?  : @""),
                                      @"cylLeft": (obj.cylLeft ?  : @""),
                                      @"cylRight":(obj.cylRight ?  : @""),
                                      @"axisLeft":obj.axisLeft,
                                      @"axisRight":obj.axisRight,
                                      @"addLeft":obj.addLeft,
                                      @"addRight":obj.addRight,
                                      @"correctedVisionLeft":obj.correctedVisionLeft,
                                      @"correctedVisionRight":obj.correctedVisionRight}];
        if (obj.purpose.length) {
            [optometryDic setObject:obj.purpose forKey:@"purpose"];
        }
        if (obj.employeeName.length) {
            [optometryDic setObject:obj.employeeId forKey:@"employeeId"];
            [optometryDic setObject:obj.employeeName forKey:@"employeeName"];
        }
        [optometryList addObject:optometryDic];
    }];
    
    [IPCCustomerRequestManager saveCustomerInfoWithCustomName:[IPCInsertCustomer instance].customerName
                                                  CustomPhone:[IPCInsertCustomer instance].customerPhone
                                                       Gender:[IPCInsertCustomer instance].gender
                                                        Email:[IPCInsertCustomer instance].email
                                                     Birthday:[IPCInsertCustomer instance].birthday
                                                       Remark:[IPCInsertCustomer instance].remark
                                                OptometryList:optometryList
                                                  ContactName:[IPCInsertCustomer instance].contactorName
                                                ContactGender:[IPCInsertCustomer instance].contactorGenger
                                                 ContactPhone:[IPCInsertCustomer instance].contactorPhone
                                               ContactAddress:[IPCInsertCustomer instance].contactorAddress
                                                 EmployeeName:[IPCInsertCustomer instance].empName
                                                   EmployeeId:[IPCInsertCustomer instance].empNameId
                                                 CustomerType:[IPCInsertCustomer instance].customerType
                                               CustomerTypeId:[IPCInsertCustomer instance].customerTypeId
                                                   Occupation:[IPCInsertCustomer instance].job
                                                  MemberLevel:[IPCInsertCustomer instance].memberLevel
                                                MemberLevelId:[IPCInsertCustomer instance].memberLevelId
                                                    MemberNum:[IPCInsertCustomer instance].memberNum
                                                      PhotoId:[IPCInsertCustomer instance].photo_udid
                                                 IntroducerId:[IPCInsertCustomer instance].introducerId
                                            IntroducerInteger: [IPCInsertCustomer instance].introducerInteger
                                                 SuccessBlock:^(id responseValue)
     {
         [IPCCustomUI showSuccess:@"新建用户成功!"];
         [[IPCInsertCustomer instance] resetData];
         [self.navigationController popViewControllerAnimated:YES];
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}

#pragma mark //Set UI
- (IPCInsertCustomerBaseCell *)baseInfoCell{
    IPCInsertCustomerBaseCell * cell = (IPCInsertCustomerBaseCell *)[self.userInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cell;
}

- (IPCInsertCustomerOpometryCell *)opometryCell{
    IPCInsertCustomerOpometryCell * cell = (IPCInsertCustomerOpometryCell *)[self.userInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    return cell;
}

#pragma mark //Clicked Events
- (IBAction)insertNewCustomerAction:(id)sender {
    [[IPCInsertCustomer instance] resetData];
    [self.userInfoTableView reloadData];
}


- (IBAction)saveNewCustomerAction:(id)sender {
    if ([IPCInsertCustomer instance].customerName.length && [IPCInsertCustomer instance].customerPhone.length) {
        [self saveNewCustomerRequest];
    }else{
        [IPCCustomUI showError:@"请输入完整客户名或手机号!"];
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
            [cell setTopTitle:@"客户基本信息"];
            return cell;
        }else{
            IPCInsertCustomerBaseCell * cell = [tableView dequeueReusableCellWithIdentifier:baseIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCInsertCustomerBaseCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
                cell.delegate = self;
            }
            [cell updatePackUpUI:isPackUping];
            [[cell rac_signalForSelector:@selector(showCustomerListAction)] subscribeNext:^(RACTuple * _Nullable x) {
                [self selectIntroducerMethod];
            }];
            return cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:topIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setTopTitle:@"收货地址"];
            return cell;
        }else{
            IPCInsertCustomerAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:addressIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCInsertCustomerAddressCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell updateInsertAddressUI];
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            IPCCustomTopCell * cell = [tableView dequeueReusableCellWithIdentifier:topIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomTopCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            
            if ([IPCPayOrderManager sharedManager].isPayOrderStatus) {
                [cell setTopTitle:@"验光单"];
            }else{
                [cell setInsertTitle:@"验光单"];
            }
            
            [[cell rac_signalForSelector:@selector(insertAction:)] subscribeNext:^(id x) {
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
            if (indexPath.row == 1) {
                [cell.removeButton setHidden:YES];
            }else{
                [cell.removeButton setHidden:NO];
            }
            [cell reloadUIWithOptometry:[IPCInsertCustomer instance].optometryArray[indexPath.row-1]];
            
            [[cell rac_signalForSelector:@selector(removeOptometryAction:)] subscribeNext:^(id x) {
                [[IPCInsertCustomer instance] .optometryArray removeObjectAtIndex:indexPath.row-1];
                [tableView reloadData];
            }];
            return cell;
        }
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row > 0){
        if (isPackUping) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 5)];
    [headView setBackgroundColor:[UIColor clearColor]];
    return headView;
}

#pragma mark //UserBaseInfoCellDelegate
- (void)updatePackUpStatus:(BOOL)isPackUp{
    isPackUping = isPackUp;
    [self.userInfoTableView reloadData];
}

- (void)reloadInsertCustomUI{
    [self.userInfoTableView reloadData];
}

#pragma mark //IPCInsertCustomerOpometryCellDelegate
- (void)updateOptometryMode:(IPCOptometryMode *)optometry Cell:(IPCInsertCustomerOpometryCell *)cell{
    NSIndexPath * indexPath = [self.userInfoTableView indexPathForCell:cell];
    [[IPCInsertCustomer instance].optometryArray replaceObjectAtIndex:indexPath.row-1 withObject:optometry];
    [self.userInfoTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
