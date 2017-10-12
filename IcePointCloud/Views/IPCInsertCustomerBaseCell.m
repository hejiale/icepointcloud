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
    
    [IPCCommonUI clearAutoCorrection:self.mainView];
    [self.genderTextField setRightButton:self Action:@selector(showGenderPickViewAction) OnView:self.mainView];
    [self.birthdayTextField setRightButton:self Action:@selector(showDatePickViewAction) OnView:self.packUpView];
    [self.handlersTextField setRightButton:self Action:@selector(showEmployeeAction) OnView:self.mainView];
    [self.memberLevelTextField setRightButton:self Action:@selector(showMemberLevelAction) OnView:self.mainView];
    [self.customerCategoryTextField setRightButton:self Action:@selector(showCustomerTypeAction) OnView:self.packUpView];
    [self.introducerTextField setRightButton:self Action:@selector(showCustomerListAction) OnView:self.introducerView];
    
    [self.mainView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField * textField = (UITextField *)obj;
            [textField addBorder:3 Width:0.5 Color:nil];
            [textField setLeftSpace:10];
        }
    }];
    
    [self.packUpView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField * textField = (UITextField *)obj;
            [textField addBorder:3 Width:0.5 Color:nil];
            [textField setLeftSpace:10];
        }
    }];
    
    [self.introducerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField * textField = (UITextField *)obj;
            [textField addBorder:3 Width:0.5 Color:nil];
            [textField setLeftSpace:10];
        }
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateUI];
}

#pragma mark //Set UI
- (void)updateUI
{
    [self.packUpView setHidden:![IPCInsertCustomer instance].isPackUp];
    [self.packDownButton setHidden:[IPCInsertCustomer instance].isPackUp];
    
    [self.userNameTextField setText:[IPCInsertCustomer instance].customerName];
    [self.phoneTextField setText:[IPCInsertCustomer instance].customerPhone];
    [self.emailTextField setText:[IPCInsertCustomer instance].email];
    [self.memoTextField setText:[IPCInsertCustomer instance].remark];
    [self.customerCategoryTextField setText:[IPCInsertCustomer instance].customerType];
    [self.genderTextField setText:[IPCCommon formatGender:[IPCInsertCustomer instance].gender]];
    [self.handlersTextField setText:[IPCInsertCustomer instance].empName];
    [self.birthdayTextField setText:[IPCInsertCustomer instance].birthday];
    [self.memberNumTextField setText:[IPCInsertCustomer instance].memberNum];
    [self.memberLevelTextField setText:[IPCInsertCustomer instance].memberLevel];
    [self.jobTextField setText:[IPCInsertCustomer instance].job];
    [self.introducerTextField setText:[IPCInsertCustomer instance].introducerName];
    [self.introducerInteger setText:[IPCInsertCustomer instance].introducerInteger];
    
    NSString * headImage  = [IPCHeadImage gender:[IPCInsertCustomer instance].gender Tag:[IPCInsertCustomer instance].photo_udid];
    [self.customerImageView setImage:[UIImage imageNamed:headImage]];
    
    if ([[IPCInsertCustomer instance].customerType isEqualToString:@"转介绍"]) {
        [self.introducerView setHidden:NO];
        self.introduceTop.constant = 15;
        self.introduceHeight.constant = 30;
    }else{
        [self.introducerView setHidden:YES];
        self.introduceTop.constant = 0;
        self.introduceHeight.constant = 0;
    }
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

- (void)showCustomerListAction{
    if ([self.delegate respondsToSelector:@selector(selectIntroducer)]) {
        [self.delegate selectIntroducer];
    }
}

#pragma mark //Clicked Events
//展开
- (IBAction)packUpAction:(id)sender {
    [IPCInsertCustomer instance].isPackUp = YES;
    if ([self.delegate respondsToSelector:@selector(reloadInsertCustomUI)]) {
        [self.delegate reloadInsertCustomUI];
    }
}

//收起
- (IBAction)packDownAction:(id)sender {
    [IPCInsertCustomer instance].isPackUp = NO;
    if ([self.delegate respondsToSelector:@selector(reloadInsertCustomUI)]) {
        [self.delegate reloadInsertCustomUI];
    }
}


#pragma mark //uiPickerViewDataSource
- (nonnull NSArray *)parameterDataInTableView:(IPCParameterTableViewController *)tableView{
    if (self.insertType == IPCInsertTypeEmployee) {
        return [[IPCEmployeeeManager sharedManager] employeeNameArray];
    }else if (self.insertType == IPCInsertTypeCustomerType){
        return [[IPCEmployeeeManager sharedManager] customerTypeNameArray];
    }else if (self.insertType == IPCInsertTypeMemberLevel){
        return [[IPCEmployeeeManager sharedManager] memberLevelNameArray];
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
        [IPCInsertCustomer instance].memberLevelId = [[IPCEmployeeeManager sharedManager] memberLevelId:parameter];
    }else if (self.insertType == IPCInsertTypeEmployee){
        [IPCInsertCustomer instance].empName = parameter;
        [IPCInsertCustomer instance].empNameId = [[IPCEmployeeeManager sharedManager] employeeId:parameter];
    }else if (self.insertType == IPCInsertTypeCustomerType){
        if (![[IPCInsertCustomer instance].customerType isEqualToString:parameter]) {
            [IPCInsertCustomer instance].customerType =parameter;
            [IPCInsertCustomer instance].customerTypeId = [[IPCEmployeeeManager sharedManager] customerTypeId:parameter];
            [IPCInsertCustomer instance].introducerInteger = @"";
            [IPCInsertCustomer instance].introducerName = @"";
        }
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:self.introducerInteger] || [textField isEqual:self.phoneTextField]) {
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

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * str = [textField.text jk_trimmingWhitespace];
    
    if (str.length) {
        if ([textField isEqual:self.phoneTextField]) {
//            if ([self.delegate respondsToSelector:@selector(judgePhone:)]) {
//                [self.delegate judgePhone:str];
//            }
            [IPCInsertCustomer instance].customerPhone = str;
        }else if ([textField isEqual:self.userNameTextField]){
//            if ([self.delegate respondsToSelector:@selector(judgeName:)]) {
//                [self.delegate judgeName:str];
//            }
            [IPCInsertCustomer instance].customerName = str;
        }else if ([textField isEqual:self.memberNumTextField]){
            [IPCInsertCustomer instance].memberNum = str;
        }else if ([textField isEqual:self.emailTextField]){
            [IPCInsertCustomer instance].email = str;
        }else if ([textField isEqual:self.jobTextField]){
            [IPCInsertCustomer instance].job = str;
        }else if ([textField isEqual:self.memoTextField]){
            [IPCInsertCustomer instance].remark = str;
        }else if ([textField isEqual:self.introducerInteger]){
            [IPCInsertCustomer instance].introducerInteger = str;
        }
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadInsertCustomUI)]) {
            [self.delegate reloadInsertCustomUI];
        }
    }
}



@end
