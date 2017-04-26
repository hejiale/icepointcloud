//
//  UserBaseInfoCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCInsertCustomerBaseCell.h"
#import "IPCParameterTableViewController.h"

typedef NS_ENUM(NSInteger, IPCInsertType){
    IPCInsertTypeEmployee,
    IPCInsertTypeMemberLevel,
    IPCInsertTypeCustomerType,
    IPCInsertTypeGender
};

@interface IPCInsertCustomerBaseCell()<IPCParameterTableViewDelegate,IPCParameterTableViewDataSource>

@property (assign, nonatomic) IPCInsertType insertType;

@end

@implementation IPCInsertCustomerBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.packUpButton setTitleColor:COLOR_RGB_BLUE forState:UIControlStateNormal];
    [self.packDownButton setTitleColor:COLOR_RGB_BLUE forState:UIControlStateNormal];
    
    [IPCCustomUI clearAutoCorrection:self.mainView];
    [self.genderTextField setRightButton:self Action:@selector(showGenderPickViewAction) OnView:self.mainView];
    [self.birthdayTextField setRightButton:self Action:@selector(showDatePickViewAction) OnView:self.packUpView];
    [self.handlersTextField setRightButton:self Action:@selector(showEmployeeAction) OnView:self.mainView];
    [self.memberLevelTextField setRightButton:self Action:@selector(showMemberLevelAction) OnView:self.mainView];
    [self.customerCategoryTextField setRightButton:self Action:@selector(showCustomerTypeAction) OnView:self.packUpView];
    
    [self.mainView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField * textField = (UITextField *)obj;
            [textField addBorder:3 Width:0.5];
            [textField setLeftSpace:10];
        }
    }];
    
    [self.packUpView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField * textField = (UITextField *)obj;
            [textField addBorder:3 Width:0.5];
            [textField setLeftSpace:10];
        }
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


#pragma mark //Set UI
- (void)updatePackUpUI:(BOOL)isPackUp
{
    [self.packUpView setHidden:!isPackUp];
    [self.packDownButton setHidden:isPackUp];
    
    [self.userNameTextField setText:[IPCInsertCustomer instance].customerName];
    [self.phoneTextField setText:[IPCInsertCustomer instance].customerPhone];
    [self.emailTextField setText:[IPCInsertCustomer instance].email];
    [self.memoTextField setText:[IPCInsertCustomer instance].remark];
    [self.customerCategoryTextField setText:[IPCInsertCustomer instance].customerType];
    [self.genderTextField setText:[IPCInsertCustomer instance].genderString];
    [self.handlersTextField setText:[IPCInsertCustomer instance].empName];
    [self.birthdayTextField setText:[IPCInsertCustomer instance].birthday];
    [self.memberNumTextField setText:[IPCInsertCustomer instance].memberNum];
    [self.memberLevelTextField setText:[IPCInsertCustomer instance].memberLevel];
    [self.jobTextField setText:[IPCInsertCustomer instance].job];
    
    NSString * headImage  = [IPCHeadImage gender:[IPCInsertCustomer instance].gender Size:@"middle" Tag:[IPCInsertCustomer instance].photo_udid];
    [self.customerImageView setImage:[UIImage imageNamed:headImage]];
}


- (void)showEmployeeAction{
    self.insertType = IPCInsertTypeEmployee;
    [self showParameterTabelView:self.handlersTextField];
}

- (void)showMemberLevelAction{
    self.insertType = IPCInsertTypeMemberLevel;
    [self showParameterTabelView:self.memberLevelTextField];
}

- (void)showCustomerTypeAction{
    self.insertType = IPCInsertTypeCustomerType;
    [self showParameterTabelView:self.customerCategoryTextField];
}

- (void)showGenderPickViewAction{
    self.insertType = IPCInsertTypeGender;
    [self showParameterTabelView:self.genderTextField];
}

- (void)showParameterTabelView:(UITextField *)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    IPCParameterTableViewController * pickerVC = [[IPCParameterTableViewController alloc]initWithNibName:@"IPCParameterTableViewController" bundle:nil];
    pickerVC.dataSource = self;
    pickerVC.delegate = self;
    [pickerVC showWithPosition:CGPointMake(sender.jk_width/2, sender.jk_height) Size:CGSizeMake(sender.jk_width, 150) Owner:sender Direction:UIPopoverArrowDirectionUp];
}


- (void)showDatePickViewAction{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    IPCDatePickViewController * datePickVC = [[IPCDatePickViewController alloc]initWithNibName:@"IPCDatePickViewController" bundle:nil];
    datePickVC.delegate = self;
    [datePickVC showWithPosition:CGPointMake(self.birthdayTextField.jk_width/2, self.birthdayTextField.jk_height) Size:CGSizeMake(self.birthdayTextField.jk_width+60, 150) Owner:self.birthdayTextField];
}

#pragma mark //Clicked Events
//展开
- (IBAction)packUpAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(updatePackUpStatus:)]) {
        [self.delegate updatePackUpStatus:YES];
    }
}

//收起
- (IBAction)packDownAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(updatePackUpStatus:)]) {
        [self.delegate updatePackUpStatus:NO];
    }
}


#pragma mark //uiPickerViewDataSource
- (nonnull NSArray *)parameterDataInTableView:(IPCParameterTableViewController *)tableView{
    if (self.insertType == IPCInsertTypeEmployee) {
        return [[IPCEmployeeMode sharedManager] employeeNameArray];
    }else if (self.insertType == IPCInsertTypeCustomerType){
        return [[IPCEmployeeMode sharedManager] customerTypeNameArray];
    }else if (self.insertType == IPCInsertTypeMemberLevel){
        return [[IPCEmployeeMode sharedManager] memberLevelNameArray];
    }
    return @[@"男" , @"女"];
}


#pragma mark //UIPickerViewDelegate
- (void)didSelectParameter:(NSString *)parameter InTableView:(IPCParameterTableViewController *)tableView
{
    if (self.insertType == IPCInsertTypeGender) {
        [IPCInsertCustomer instance].genderString = parameter;
        [IPCInsertCustomer instance].gender = [IPCCommon gender:parameter];
        [IPCInsertCustomer instance].photo_udid = [NSString stringWithFormat:@"%d",[IPCHeadImage genderArcdom]];
    }else if (self.insertType == IPCInsertTypeMemberLevel){
        [IPCInsertCustomer instance].memberLevel = parameter;
        [IPCInsertCustomer instance].memberLevelId = [[IPCEmployeeMode sharedManager] memberLevelId:parameter];
    }else if (self.insertType == IPCInsertTypeEmployee){
        [IPCInsertCustomer instance].empName = parameter;
        [IPCInsertCustomer instance].empNameId = [[IPCEmployeeMode sharedManager] employeeId:parameter];
    }else if (self.insertType == IPCInsertTypeCustomerType){
        [IPCInsertCustomer instance].customerType =parameter;
        [IPCInsertCustomer instance].customerTypeId = [[IPCEmployeeMode sharedManager] customerTypeId:parameter];
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadInsertCustomUI)]) {
            [self.delegate reloadInsertCustomUI];
        }
    }
}

#pragma mark //CustomDatePickViewControllerDelegate
- (void)completeChooseDate:(NSString *)date{
    [IPCInsertCustomer instance].birthday = date;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadInsertCustomUI)]) {
            [self.delegate reloadInsertCustomUI];
        }
    }
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * str = [textField.text jk_trimmingWhitespace];
    
    if (str.length) {
        if ([textField isEqual:self.phoneTextField]) {
            if (![IPCCommon checkTelNumber:str]) {
                [IPCCustomUI showError:@"手机号码输入有误!"];
            }else{
                [IPCInsertCustomer instance].customerPhone = str;
            }
        }else if ([textField isEqual:self.userNameTextField]){
            [IPCInsertCustomer instance].customerName = str;
        }else if ([textField isEqual:self.memberNumTextField]){
            [IPCInsertCustomer instance].memberNum = str;
        }else if ([textField isEqual:self.emailTextField]){
            [IPCInsertCustomer instance].email = str;
        }else if ([textField isEqual:self.jobTextField]){
            [IPCInsertCustomer instance].job = str;
        }else if ([textField isEqual:self.memoTextField]){
            [IPCInsertCustomer instance].remark = str;
        }
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadInsertCustomUI)]) {
            [self.delegate reloadInsertCustomUI];
        }
    }
}



@end
