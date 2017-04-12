//
//  IPCUpdateCustomerView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/11.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCUpdateCustomerView.h"

typedef NS_ENUM(NSInteger, InsertCustomerType){
    InsertCustomerTypeGender = 0,
    InsertCustomerTypeEmployee,
    InsertCustomerTypeCustomerType,
    InsertCustomerTypeMemberType
};

@interface IPCUpdateCustomerView()<IPCParameterTableViewDataSource,IPCParameterTableViewDelegate,IPCDatePickViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *packUpView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *memberNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *handlersTextField;//经手人
@property (weak, nonatomic) IBOutlet UITextField *memberLevelTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField *customerCategoryTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *jobTextField;
@property (weak, nonatomic) IBOutlet UITextField *memoTextField;
@property (nonatomic, strong) IPCEmployeList * employeList;
@property (nonatomic, strong) NSMutableArray * employeeNameArray;
@property (assign, nonatomic) InsertCustomerType insertType;

@end

@implementation IPCUpdateCustomerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCUpdateCustomerView" owner:self];
        [view setFrame:frame];
        [self addSubview:view];
        
        [self queryMemberLevel];
        [self queryCustomerType];
        [self queryEmployee];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.mainView addSignleCorner:UIRectCornerAllCorners Size:5];
    
    [self.handlersTextField setRightButton:self Action:@selector(showEmployeeAction) OnView:self.contentView];
    [self.genderTextField setRightButton:self Action:@selector(showGenderPickViewAction) OnView:self.contentView];
    [self.customerCategoryTextField setRightButton:self Action:@selector(showCustomTypeAction) OnView:self.packUpView];
    [self.memberLevelTextField setRightButton:self Action:@selector(showMemberLevelAction) OnView:self.contentView];
    [self.birthdayTextField setRightButton:self Action:@selector(showDatePickAction) OnView:self.packUpView];
}

- (void)setCurrentDetailCustomer:(IPCDetailCustomer *)currentDetailCustomer{
    _currentDetailCustomer = currentDetailCustomer;
    if (_currentDetailCustomer) {
        [self insertCustomerInfo];
    }
}

- (NSMutableArray *)employeeNameArray{
    if (!_employeeNameArray) {
        _employeeNameArray = [[NSMutableArray alloc]init];
    }
    return _employeeNameArray;
}


#pragma mark //Clicked Events
- (IBAction)removeCoverAction:(id)sender {
    
}


- (void)insertCustomerInfo{
    [self.userNameTextField setText:self.currentDetailCustomer.customerName];
    [self.phoneTextField setText:self.currentDetailCustomer.customerPhone];
    [self.handlersTextField setText:self.currentDetailCustomer.empName];
    [self.memberNumTextField setText:self.currentDetailCustomer.memberId];
    [self.memoTextField setText:self.currentDetailCustomer.remark];
    [self.memberLevelTextField setText:self.currentDetailCustomer.memberLevel];
    [self.emailTextField setText:self.currentDetailCustomer.email];
    [self.birthdayTextField setText:self.currentDetailCustomer.birthday];
    [self.customerCategoryTextField setText:self.currentDetailCustomer.customerType];
    [self.jobTextField setText:self.currentDetailCustomer.occupation];
}


- (IBAction)updateCustomerAction:(id)sender {
    
}

- (void)showGenderPickViewAction{
    self.insertType = InsertCustomerTypeGender;
    [self showParameterTableView:self.genderTextField Height:200];
}

- (void)showMemberLevelAction{
    self.insertType = InsertCustomerTypeMemberType;
    [self showParameterTableView:self.memberLevelTextField Height:200];
}

- (void)showCustomTypeAction{
    self.insertType = InsertCustomerTypeCustomerType;
    [self showParameterTableView:self.customerCategoryTextField Height:200];
}

- (void)showDatePickAction{
    [self showDatePickView];
}

- (void)showEmployeeAction{
    self.insertType = InsertCustomerTypeEmployee;
    [self showParameterTableView:self.handlersTextField Height:200];
}


#pragma mark //Set UI
- (void)showParameterTableView:(UITextField *)sender Height:(CGFloat)height
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    IPCParameterTableViewController * parameterTableVC = [[IPCParameterTableViewController alloc]initWithNibName:@"IPCParameterTableViewController" bundle:nil];
    [parameterTableVC setDataSource:self];
    [parameterTableVC setDelegate:self];
    [parameterTableVC showWithPosition:CGPointMake(sender.jk_left + sender.jk_width/2 + self.mainView.jk_left, self.contentView.jk_top + self.mainView.jk_top + sender.jk_bottom) Size:CGSizeMake(sender.jk_width, height) Owner:self Direction:UIPopoverArrowDirectionUp];
}

- (void)showDatePickView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    IPCDatePickViewController * datePickVC = [[IPCDatePickViewController alloc]initWithNibName:@"IPCDatePickViewController" bundle:nil];
    datePickVC.delegate = self;
    [datePickVC showWithPosition:CGPointMake(self.birthdayTextField.jk_width/2, self.birthdayTextField.jk_height) Size:CGSizeMake(self.birthdayTextField.jk_width + 60, 150) Owner:self.birthdayTextField];
}


#pragma mark //Request Data
- (void)queryMemberLevel{
    [IPCCustomerRequestManager getMemberLevelWithSuccessBlock:^(id responseValue) {
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)queryCustomerType{
    [IPCCustomerRequestManager getCustomerTypeSuccessBlock:^(id responseValue) {
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)queryEmployee{
    [IPCPayOrderRequestManager queryEmployeWithKeyword:@"" SuccessBlock:^(id responseValue) {
        _employeList = [[IPCEmployeList alloc] initWithResponseObject:responseValue];
        [_employeList.employeArray enumerateObjectsUsingBlock:^(IPCEmploye * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.employeeNameArray addObject:obj.name];
        }];
    } FailureBlock:^(NSError *error) {
        
    }];
}


#pragma mark //IPCParameterTableViewDataSource
- (nonnull NSArray *)parameterDataInTableView:(IPCParameterTableViewController *)tableView{
    if (self.insertType == InsertCustomerTypeEmployee)
        return self.employeeNameArray;
    return @[@"男" , @"女"];
}


#pragma mark /IPCParameterTableViewDelegate
- (void)didSelectParameter:(NSString *)parameter InTableView:(IPCParameterTableViewController *)tableView{

}

#pragma mark //IPCDatePickViewControllerDelegate
- (void)completeChooseDate:(NSString *)date{
    
}

@end
