//
//  UserInfoViewController.m
//  IcePointCloud
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerViewController.h"
#import "IPCCustomerListViewController.h"
#import "IPCCustomerBaseInfoCell.h"
#import "IPCCustomerBaseOpometryCell.h"

static NSString * const baseIdentifier = @"UserBaseInfoCellIdentifier";
static NSString * const opometryIdentifier = @"UserBaseOpometryCellIdentifier";

@interface IPCCustomerViewController ()<UITableViewDelegate,UITableViewDataSource,UserBaseInfoCellDelegate>
{
    BOOL  isChooseCustomer;
}
@property (weak,   nonatomic) IBOutlet UITableView *userInfoTableView;
@property (strong, nonatomic) NSMutableArray<NSString *> * insertTextArray;

@end

@implementation IPCCustomerViewController

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
    
    isChooseCustomer = NO;
    [self.userInfoTableView setTableFooterView:[[UIView alloc]init]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToCartAction) name:@"ShowShoppingCartNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadUserBaseInfoView];
}


- (NSMutableArray<NSString *> *)insertTextArray{
    if (!_insertTextArray) {
        _insertTextArray = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < 8; i++)
            [self.insertTextArray addObject:[NSString string]];
    }
    return _insertTextArray;
}

#pragma mark //Request Data
- (void)saveNewCustomerRequest
{
    [IPCCustomerRequestManager saveCustomerInfoWithCustomName:self.insertTextArray[0]
                                                  CustomPhone:self.insertTextArray[4]
                                                       Gender:[IPCCommon gender:self.insertTextArray[1]]
                                                          Age:self.insertTextArray[3]
                                                        Email:self.insertTextArray[5]
                                                     Birthday:self.insertTextArray[2]
                                                       Remark:self.insertTextArray[7]
                                                    PhotoUUID:@""
                                                     Distance:[[self opometryCell].editOptometryView subString:10]
                                                      SphLeft:[[self opometryCell].editOptometryView subString:5]
                                                     SphRight:[[self opometryCell].editOptometryView subString:0]
                                                      CylLeft:[[self opometryCell].editOptometryView subString:6]
                                                     CylRight:[[self opometryCell].editOptometryView subString:1]
                                                     AxisLeft:[[self opometryCell].editOptometryView subString:7]
                                                    AxisRight:[[self opometryCell].editOptometryView subString:2]
                                                      AddLeft:[[self opometryCell].editOptometryView subString:8]
                                                     AddRight:[[self opometryCell].editOptometryView subString:3]
                                                CorrectedLeft:[[self opometryCell].editOptometryView subString:9]
                                               CorrectedRight:[[self opometryCell].editOptometryView subString:4]
                                                  ContactName:self.insertTextArray[0]
                                                ContactGender:[IPCCommon gender:self.insertTextArray[1]]
                                                 ContactPhone:self.insertTextArray[4]
                                               ContactAddress:self.insertTextArray[6]
                                                 SuccessBlock:^(id responseValue)
     {
         [IPCCustomUI showSuccess:@"新建用户成功!"];
         [self.insertTextArray removeAllObjects];self.insertTextArray = nil;
         [self.userInfoTableView reloadData];
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}

#pragma mark //Set UI
- (IPCCustomerBaseInfoCell *)baseInfoCell{
    IPCCustomerBaseInfoCell * cell = (IPCCustomerBaseInfoCell *)[self.userInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cell;
}

- (IPCCustomerBaseOpometryCell *)opometryCell{
    IPCCustomerBaseOpometryCell * cell = (IPCCustomerBaseOpometryCell *)[self.userInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    return cell;
}

#pragma mark //Refresh the page data
- (void)reloadUserBaseInfoView{
    if ([IPCCurrentCustomerOpometry sharedManager].currentCustomer) {
        isChooseCustomer = YES;
    }else{
        isChooseCustomer = NO;
    }
    [self.userInfoTableView reloadData];
    
    if ([IPCCurrentCustomerOpometry sharedManager].currentCustomer) {
        [[self baseInfoCell].userNameTextField setText:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.customerName];
        [[self baseInfoCell].genderTextField setText:[IPCCommon formatGender:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.contactorGengerString]];
        [[self baseInfoCell].birthdayTextField setText:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.birthday];
        [[self baseInfoCell].ageTextFiled setText:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.age];
        [[self baseInfoCell].phoneTextField setText:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.customerPhone];
        [[self baseInfoCell].mailTextField setText:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.email];
        [[self baseInfoCell].memoTextView setText:[IPCCurrentCustomerOpometry sharedManager].currentCustomer.remark];
        [self reloadGenderImage];
    }
    
    if ([IPCCurrentCustomerOpometry sharedManager].currentAddress){
        [[self baseInfoCell].addressTextView setText:[IPCCurrentCustomerOpometry sharedManager].currentAddress.detailAddress];
    }
    
    if ([IPCCurrentCustomerOpometry sharedManager].currentOpometry) {
        [[[self opometryCell].editOptometryView subTextField:0] setText:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.sphRight];
        [[[self opometryCell].editOptometryView subTextField:1] setText:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.cylRight];
        [[[self opometryCell].editOptometryView subTextField:2] setText:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.axisRight];
        [[[self opometryCell].editOptometryView subTextField:3] setText:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.addRight];
        [[[self opometryCell].editOptometryView subTextField:4] setText:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.correctedVisionRight];
        [[[self opometryCell].editOptometryView subTextField:5] setText:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.sphLeft];
        [[[self opometryCell].editOptometryView subTextField:6] setText:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.cylLeft];
        [[[self opometryCell].editOptometryView subTextField:7] setText:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.axisLeft];
        [[[self opometryCell].editOptometryView subTextField:8] setText:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.addLeft];
        [[[self opometryCell].editOptometryView subTextField:9] setText:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.correctedVisionLeft];
//        [[[self opometryCell].editOptometryView subTextField:10] setText:[IPCCurrentCustomerOpometry sharedManager].currentOpometry.distance];
    }
}


- (void)reloadGenderImage{
    if ([[self baseInfoCell].genderTextField.text isEqualToString:@"男"] || [[self baseInfoCell].genderTextField.text isEqualToString:@"未设置"]) {
        [[self baseInfoCell].userPhotoImageView setImageWithURL:nil placeholder:[UIImage imageNamed:@"icon_male"]];
    }else if ([[self baseInfoCell].genderTextField.text isEqualToString:@"女"]){
        [[self baseInfoCell].userPhotoImageView setImageWithURL:nil placeholder:[UIImage imageNamed:@"icon_female"]];
    }
}

#pragma mark //NSNotification Events
- (void)pushToCartAction{
    [IPCCustomUI pushToRootIndex:4];
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        IPCCustomerBaseInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:baseIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCCustomerBaseInfoCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            cell.delegate = self;
        }
        [cell setAllSubViewDisabled:isChooseCustomer];
        
        if ([self.insertTextArray count] > 0) {
            for (NSInteger i = 0; i < self.insertTextArray.count; i++) {
                if (i < 6) {
                    UITextField * textField = (UITextField *)[cell.mainView viewWithTag:i+10];
                    [textField setText:self.insertTextArray[i]];
                }else{
                    IQTextView * textView = (IQTextView *)[cell.mainView viewWithTag:i+10];
                    [textView setText:self.insertTextArray[i]];
                }
            }
        }
        return cell;
    }else{
        IPCCustomerBaseOpometryCell * cell = [tableView dequeueReusableCellWithIdentifier:opometryIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCCustomerBaseOpometryCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        [cell setAllSubViewDisabled:isChooseCustomer Complete:^{
            if ([self baseInfoCell].userNameTextField.text.length && [self baseInfoCell].phoneTextField.text.length && [self baseInfoCell].addressTextView.text.length){
                [self saveNewCustomerRequest];
            }else{
                [IPCCustomUI showError:@"请将必填项填写完整!"];
            }
        }];
        return cell;
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
        return 345;
    return 349;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 10)];
    [footView setBackgroundColor:[UIColor clearColor]];
    return footView;
}

#pragma mark //UserBaseInfoCellDelegate
- (void)searchCustomer{
    if (self.isInserting) {
        [self alertInsert:NO];
    }else{
        [self pushToSearchCustomer];
    }
}

- (void)insertNewCustomer{
    [self.view endEditing:YES];
    [self alertInsert:YES];
}

- (void)changeCustomerGender{
    [self reloadGenderImage];
}

- (void)inputText:(NSString *)text Tag:(NSInteger)tag InCell:(IPCCustomerBaseInfoCell *)cell{
    if (text.length) {
        [self.insertTextArray replaceObjectAtIndex:tag-10 withObject:text];
    }
}


#pragma mark //Insert Alert
- (void)alertInsert:(BOOL)isInsert
{
    if (![self judgeContactIsEmpty] || ![self judgeOptometryIsEmpty]) {
        [IPCCustomUI showAlert:@"冰点云" Message:@"您正在新增验光数据，如果点击确定，客户验光记录将丢失，确定清空吗？" Owner:self Done:^{
            [self clearAllInputInfo];
            if (!isInsert)[self pushToSearchCustomer];
        }];
    }
}


- (void)clearAllInputInfo{
    isChooseCustomer = NO;
    [IPCCurrentCustomerOpometry sharedManager].currentAddress  = nil;
    [IPCCurrentCustomerOpometry sharedManager].currentCustomer = nil;
    [IPCCurrentCustomerOpometry sharedManager].currentOpometry = nil;
    [self.insertTextArray removeAllObjects];self.insertTextArray = nil;
    [self.userInfoTableView reloadData];
}


#pragma mark //Push To Search Customer
- (void)pushToSearchCustomer{
    IPCCustomerListViewController * customerDetailVC = [[IPCCustomerListViewController alloc]initWithNibName:@"IPCCustomerListViewController" bundle:nil];
    [self.navigationController pushViewController:customerDetailVC animated:YES];
}


#pragma mark //Judge input empty
- (BOOL)judgeOptometryIsEmpty{
    __block BOOL isEmpty = YES;
    [[self opometryCell].editOptometryView.allTextFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.text.length) {
            isEmpty = NO;
            *stop = YES;
        }
    }];
    return isEmpty;
}

- (BOOL)judgeContactIsEmpty{
    __block BOOL isEmpty = YES;
    
    [[self baseInfoCell].mainView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField * textField = (UITextField *)obj;
            if (textField.text.length) {
                isEmpty = NO;
                *stop = YES;
            }
        }
    }];
    return isEmpty;
}

#pragma mark //Determine whether the current is the new customer information
- (BOOL)isInserting{
    return (!isChooseCustomer && ![self judgeContactIsEmpty]) || (!isChooseCustomer && ![self judgeOptometryIsEmpty]);
}

- (void)toExitInsertCustomer{
    [self clearAllInputInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
