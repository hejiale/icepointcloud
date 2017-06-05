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
    InsertCustomerTypeMemberType
};

@interface IPCUpdateCustomerView()<IPCParameterTableViewDataSource,IPCParameterTableViewDelegate,IPCDatePickViewControllerDelegate,UITextFieldDelegate>

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
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *jobTextField;
@property (weak, nonatomic) IBOutlet UITextField *memoTextField;
@property (assign, nonatomic) InsertCustomerType insertType;

@end

@implementation IPCUpdateCustomerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCUpdateCustomerView" owner:self];
        [view setFrame:frame];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.mainView addSignleCorner:UIRectCornerAllCorners Size:5];
    
    [self.handlersTextField setRightButton:self Action:@selector(showEmployeeAction) OnView:self.contentView];
    [self.genderTextField setRightButton:self Action:@selector(showGenderPickViewAction) OnView:self.contentView];
    [self.memberLevelTextField setRightButton:self Action:@selector(showMemberLevelAction) OnView:self.contentView];
    [self.birthdayTextField setRightButton:self Action:@selector(showDatePickAction) OnView:self.packUpView];
}

- (void)setCurrentDetailCustomer:(IPCDetailCustomer *)currentDetailCustomer{
    _currentDetailCustomer = currentDetailCustomer;
    if (_currentDetailCustomer) {
        [self insertCustomerInfo];
    }
}

#pragma mark //Request Data
- (void)updateCustomerRequest{
    // 判断是否修改了性别
    __block BOOL isUpdateGender = NO;
    if ( ![self.currentDetailCustomer.contactorGengerString isEqualToString:[IPCCommon gender:self.genderTextField.text]]) {
        isUpdateGender = YES;
    }
    [IPCCustomerRequestManager updateCustomerInfoWithCustomID:self.currentDetailCustomer.customerID
                                                 CustomerName:self.userNameTextField.text
                                                  CustomPhone:self.phoneTextField.text
                                                       Gender:[IPCCommon gender:self.genderTextField.text]
                                                        Email:self.emailTextField.text
                                                     Birthday:self.birthdayTextField.text
                                                   EmployeeId:[[IPCEmployeeMode sharedManager] employeeId:self.handlersTextField.text]
                                                    MemberNum:self.memberNumTextField.text 
                                                MemberLevelId:[[IPCEmployeeMode sharedManager] memberLevelId:self.memberLevelTextField.text]
                                               CustomerTypeId:self.currentDetailCustomer.customerTypeId
                                                 EmployeeName:self.handlersTextField.text
                                                  MemberLevel:self.memberLevelTextField.text
                                                          Job:self.jobTextField.text
                                                       Remark:self.memoTextField.text
                                                      PhotoId:(isUpdateGender ? [NSString stringWithFormat:@"%d",[IPCHeadImage genderArcdom]] : (self.currentDetailCustomer.photoIdForPos ? : @""))
                                                 SuccessBlock:^(id responseValue)
     {
         [IPCCustomUI showSuccess:@"更改用户信息成功!"];
         if (self.delegate) {
             if ([self.delegate respondsToSelector:@selector(dismissCoverSubViews)]) {
                 [self.delegate dismissCoverSubViews];
             }
         }
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}


#pragma mark //Clicked Events
- (IBAction)removeCoverAction:(id)sender {
    
}


- (void)insertCustomerInfo{
    [self.userNameTextField setText:self.currentDetailCustomer.customerName];
    [self.genderTextField setText:[IPCCommon formatGender:self.currentDetailCustomer.contactorGengerString]];
    [self.phoneTextField setText:self.currentDetailCustomer.customerPhone];
    [self.handlersTextField setText:self.currentDetailCustomer.empName];
    [self.memberNumTextField setText:self.currentDetailCustomer.memberId];
    [self.memoTextField setText:self.currentDetailCustomer.remark];
    [self.memberLevelTextField setText:self.currentDetailCustomer.memberLevel];
    [self.emailTextField setText:self.currentDetailCustomer.email];
    [self.birthdayTextField setText:self.currentDetailCustomer.birthday];
    [self.jobTextField setText:self.currentDetailCustomer.occupation];
}


- (IBAction)updateCustomerAction:(id)sender {
    if (!self.userNameTextField.text.length || !self.phoneTextField.text.length) {
        [IPCCustomUI showError:@"用户名或手机号输入为空!"];
    }else{
        [self updateCustomerRequest];
    }
}

- (void)showGenderPickViewAction{
    self.insertType = InsertCustomerTypeGender;
    [self showParameterTableView:self.genderTextField Height:200];
}

- (void)showMemberLevelAction{
    self.insertType = InsertCustomerTypeMemberType;
    [self showParameterTableView:self.memberLevelTextField Height:200];
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
    [parameterTableVC showWithPosition:CGPointMake(sender.jk_left + sender.jk_width/2, sender.jk_bottom) Size:CGSizeMake(sender.jk_width, height) Owner:[sender superview] Direction:UIPopoverArrowDirectionUp];
}

- (void)showDatePickView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    IPCDatePickViewController * datePickVC = [[IPCDatePickViewController alloc]initWithNibName:@"IPCDatePickViewController" bundle:nil];
    datePickVC.delegate = self;
    [datePickVC showWithPosition:CGPointMake(self.birthdayTextField.jk_width/2, self.birthdayTextField.jk_height) Size:CGSizeMake(self.birthdayTextField.jk_width + 60, 150) Owner:self.birthdayTextField];
}


#pragma mark //IPCParameterTableViewDataSource
- (nonnull NSArray *)parameterDataInTableView:(IPCParameterTableViewController *)tableView{
    if (self.insertType == InsertCustomerTypeEmployee)
        return [[IPCEmployeeMode sharedManager] employeeNameArray];
    else if (self.insertType == InsertCustomerTypeMemberType)
        return [[IPCEmployeeMode sharedManager] memberLevelNameArray];
    return @[@"男" , @"女"];
}


#pragma mark /IPCParameterTableViewDelegate
- (void)didSelectParameter:(NSString *)parameter InTableView:(IPCParameterTableViewController *)tableView{
    if (self.insertType == InsertCustomerTypeEmployee) {
        [self.handlersTextField setText:parameter];
    }else if (self.insertType == InsertCustomerTypeMemberType){
        [self.memberLevelTextField setText:parameter];
    }else{
        [self.genderTextField setText:parameter];
        
    }
}

#pragma mark //IPCDatePickViewControllerDelegate
- (void)completeChooseDate:(NSString *)date{
    [self.birthdayTextField setText:date];
}

#pragma mark //UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:self.phoneTextField]) {
        if (![IPCCommon judgeIsIntNumber:string]) {
            return NO;
        }
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}


@end
