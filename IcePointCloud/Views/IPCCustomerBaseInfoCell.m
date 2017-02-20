//
//  UserBaseInfoCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerBaseInfoCell.h"

@implementation IPCCustomerBaseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.queryOptometryButton.layer.cornerRadius  = 5;
    self.queryOptometryButton.layer.borderColor   = COLOR_RGB_BLUE.CGColor;
    self.queryOptometryButton.layer.borderWidth   = 1;
    self.insertOptometryButton.layer.cornerRadius = 5;
    [self.insertOptometryButton setBackgroundColor:COLOR_RGB_BLUE];
    [self.addressTextView addBorder:5 Width:0.6];
    [self.addressTextView setPlaceholder:@"请输入地址"];
    self.addressTextView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [self.memoTextView addBorder:5 Width:0.6];
    [self.memoTextView setPlaceholder:@"备注其他信息"];
    self.memoTextView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [self.mainView addSubview:self.userPhotoImageView];
    [self.userPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.mas_left).with.offset(40);
        make.top.equalTo(self.mainView.mas_top).with.offset(72);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(247);
    }];
    [self.userPhotoImageView setImage:[UIImage imageNamed:@"icon_male@2x"]];
    [IPCUIKit clearAutoCorrection:self.mainView];
}

- (UIImageView *)userPhotoImageView{
    if (!_userPhotoImageView) {
        _userPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_userPhotoImageView zy_cornerRadiusAdvance:15.f rectCornerType:UIRectCornerAllCorners];
    }
    return _userPhotoImageView;
}


- (void)setAllSubViewDisabled:(BOOL)isDisable{
    [self.mainView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag != 100 && obj.tag != 101) {
            [obj setUserInteractionEnabled:!isDisable];
        }
    }];
    
    if (!isDisable) {
        [IPCUIKit textFieldRightButton:self Action:@selector(showGenderPickViewAction) InTextField:self.genderTextField OnView:self.mainView];
        [IPCUIKit textFieldRightButton:self Action:@selector(showDatePickViewAction) InTextField:self.birthdayTextField OnView:self.mainView];
    }else{
        [self.genderTextField setRightView:nil];
        [self.birthdayTextField setRightView:nil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)queryOptometryInfoAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(searchCustomer)])
        [self.delegate searchCustomer];
}


- (IBAction)creatNewOptometryAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(insertNewCustomer)])
        [self.delegate insertNewCustomer];
}

- (void)showGenderPickViewAction{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    IPCDataPickViewController * pickerVC = [[IPCDataPickViewController alloc]initWithNibName:@"IPCDataPickViewController" bundle:nil];
    pickerVC.dataSource = self;
    pickerVC.delegate = self;
    [pickerVC showWithPosition:CGPointMake(self.genderTextField.jk_width/2, self.genderTextField.jk_height) Size:CGSizeMake(self.genderTextField.jk_width, 150) Owner:self.genderTextField];
}


- (void)showDatePickViewAction{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    IPCDatePickViewController * datePickVC = [[IPCDatePickViewController alloc]initWithNibName:@"IPCDatePickViewController" bundle:nil];
    datePickVC.delegate = self;
    [datePickVC showWithPosition:CGPointMake(self.birthdayTextField.jk_width/2, self.birthdayTextField.jk_height) Size:CGSizeMake(self.birthdayTextField.jk_width, 150) Owner:self.birthdayTextField];
}

#pragma mark //uiPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView{
    return 1;
}

- (NSInteger)pickerViewNumberOfRowsInComponent:(NSInteger)component{
    return 2;
}

#pragma mark //UIPickerViewDelegate
- (NSString *)pickerViewTitleForRow:(NSInteger)row{
    return row == 0 ?@"男":@"女";
}

- (void)didSelectContent:(NSString *)content titleForRow:(NSInteger)row{
    [self.genderTextField setText:content];
    
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
    if ([textField isEqual:self.mailTextField]) {
        [self.addressTextView becomeFirstResponder];
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
            [IPCUIKit showError:@"请输入有效的手机号码!"];
            [textField setText:@""];
        }
    }
    
    if (textField.tag != 11 && textField.tag != 12) {
        if ([self.delegate respondsToSelector:@selector(inputText:Tag:InCell:)]) {
            [self.delegate inputText:textField.text Tag:textField.tag InCell:self];
        }
    }
}


#pragma mark //UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        NSString * trimmedString = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [textView setText:trimmedString];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(inputText:Tag:InCell:)]) {
        [self.delegate inputText:textView.text Tag:textView.tag InCell:self];
    }
}


@end
