//
//  UserInfoViewController.m
//  IcePointCloud
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCInsertCustomerViewController.h"
#import "IPCCustomerTopTitleCell.h"
#import "IPCInsertCustomerBaseCell.h"
#import "IPCInsertCustomerOpometryCell.h"
#import "IPCInsertCustomerAddressCell.h"

static NSString * const topIdentifier = @"UserBaseTopTitleCellIdentifier";
static NSString * const baseIdentifier = @"UserBaseInfoCellIdentifier";
static NSString * const opometryIdentifier = @"UserBaseOpometryCellIdentifier";
static NSString * const addressIdentifier = @"IPCInsertCustomerAddressCellIdentifier";

@interface IPCInsertCustomerViewController ()<UITableViewDelegate,UITableViewDataSource,UserBaseInfoCellDelegate>
{
    BOOL  isPackUping;
}

@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak,   nonatomic) IBOutlet UITableView *userInfoTableView;
@property (strong, nonatomic) IBOutlet UIView *tableFootView;

@end

@implementation IPCInsertCustomerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.topBarView addBottomLine];
    [self.userInfoTableView setTableFooterView:self.tableFootView];
}

#pragma mark //Request Data
- (void)saveNewCustomerRequest
{
//    [IPCCustomerRequestManager saveCustomerInfoWithCustomName:self.insertTextArray[0]
//                                                  CustomPhone:self.insertTextArray[4]
//                                                       Gender:[IPCCommon gender:self.insertTextArray[1]]
//                                                          Age:self.insertTextArray[3]
//                                                        Email:self.insertTextArray[5]
//                                                     Birthday:self.insertTextArray[2]
//                                                       Remark:self.insertTextArray[7]
//                                                    PhotoUUID:@""
//                                                     Distance:[[self opometryCell].editOptometryView subString:10]
//                                                      SphLeft:[[self opometryCell].editOptometryView subString:5]
//                                                     SphRight:[[self opometryCell].editOptometryView subString:0]
//                                                      CylLeft:[[self opometryCell].editOptometryView subString:6]
//                                                     CylRight:[[self opometryCell].editOptometryView subString:1]
//                                                     AxisLeft:[[self opometryCell].editOptometryView subString:7]
//                                                    AxisRight:[[self opometryCell].editOptometryView subString:2]
//                                                      AddLeft:[[self opometryCell].editOptometryView subString:8]
//                                                     AddRight:[[self opometryCell].editOptometryView subString:3]
//                                                CorrectedLeft:[[self opometryCell].editOptometryView subString:9]
//                                               CorrectedRight:[[self opometryCell].editOptometryView subString:4]
//                                                  ContactName:self.insertTextArray[0]
//                                                ContactGender:[IPCCommon gender:self.insertTextArray[1]]
//                                                 ContactPhone:self.insertTextArray[4]
//                                               ContactAddress:self.insertTextArray[6]
//                                                 SuccessBlock:^(id responseValue)
//     {
//         [IPCCustomUI showSuccess:@"新建用户成功!"];
//         [self.insertTextArray removeAllObjects];self.insertTextArray = nil;
//         [self.userInfoTableView reloadData];
//     } FailureBlock:^(NSError *error) {
//         [IPCCustomUI showError:error.domain];
//     }];
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
- (IBAction)closeAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            IPCCustomerTopTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:topIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerTopTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
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
            return cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            IPCCustomerTopTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:topIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerTopTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setTopTitle:@"收货地址"];
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
            IPCCustomerTopTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:topIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCCustomerTopTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell setInsertTitle:@"验光单"];
            return cell;
        }else{
            IPCInsertCustomerOpometryCell * cell = [tableView dequeueReusableCellWithIdentifier:opometryIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCInsertCustomerOpometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            return cell;
        }
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row > 0)
        return isPackUping ? 350 : 200;
    else if (indexPath.section == 1 && indexPath.row > 0)
        return 100;
    else if (indexPath.section == 2 && indexPath.row > 0)
        return 165;
    return 60;
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

- (void)inputText:(NSString *)text Tag:(NSInteger)tag InCell:(IPCInsertCustomerBaseCell *)cell{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
