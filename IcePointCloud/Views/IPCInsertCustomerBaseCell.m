//
//  UserBaseInfoCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCInsertCustomerBaseCell.h"
#import "IPCParameterTableViewController.h"

@interface IPCInsertCustomerBaseCell()<IPCParameterTableViewDelegate,IPCParameterTableViewDataSource>

@end

@implementation IPCInsertCustomerBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [IPCCustomUI clearAutoCorrection:self.mainView];
    [self.genderTextField setRightButton:self Action:@selector(showGenderPickViewAction) OnView:self.mainView];
    [self.birthdayTextField setRightButton:self Action:@selector(showDatePickViewAction) OnView:self.packUpView];
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
}


- (void)showGenderPickViewAction{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    IPCParameterTableViewController * pickerVC = [[IPCParameterTableViewController alloc]initWithNibName:@"IPCParameterTableViewController" bundle:nil];
    pickerVC.dataSource = self;
    pickerVC.delegate = self;
    [pickerVC showWithPosition:CGPointMake(self.genderTextField.jk_width/2, self.genderTextField.jk_height) Size:CGSizeMake(self.genderTextField.jk_width, 150) Owner:self.genderTextField Direction:UIPopoverArrowDirectionUp];
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
    return @[@"男" , @"女"];
}


#pragma mark //UIPickerViewDelegate
- (void)didSelectParameter:(NSString *)parameter InTableView:(IPCParameterTableViewController *)tableView{
    [self.genderTextField setText:parameter];
    
    if ([self.delegate respondsToSelector:@selector(inputText:Tag:InCell:)]) {
        [self.delegate inputText:self.genderTextField.text Tag:self.genderTextField.tag InCell:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(changeCustomerGender)]) {
        [self.delegate changeCustomerGender];
    }
}

#pragma mark //CustomDatePickViewControllerDelegate
- (void)completeChooseDate:(NSString *)date{
    [self.birthdayTextField setText:date];
    if ([self.delegate respondsToSelector:@selector(inputText:Tag:InCell:)]) {
        [self.delegate inputText:self.birthdayTextField.text Tag:self.birthdayTextField.tag InCell:self];
    }
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.emailTextField]) {
        [self.jobTextField becomeFirstResponder];
    }else{
        if (textField.tag == 10) {
            [self showGenderPickViewAction];
        }else{
            UITextField * nextTextField = (UITextField *)[self.mainView viewWithTag:textField.tag + 1];
            [nextTextField becomeFirstResponder];
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.phoneTextField]) {
        if (![IPCCommon checkTelNumber:[textField.text jk_trimmingWhitespace]]) {
            [IPCCustomUI showError:@"请输入有效的手机号码!"];
            [textField setText:@""];
        }
    }
    
    if (textField.tag != 11 && textField.tag != 16) {
        if ([self.delegate respondsToSelector:@selector(inputText:Tag:InCell:)]) {
            [self.delegate inputText:textField.text Tag:textField.tag InCell:self];
        }
    }
}



@end
