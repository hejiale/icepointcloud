//
//  UserDetailInfoCell.m
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCustomerDetailCell.h"

@interface IPCCustomerDetailCell()




@end

@implementation IPCCustomerDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.memoTextView addBorder:5 Width:0.6];
    [self.memoTextView setPlaceholder:@"备注其他信息"];
    [self.mainView addSubview:self.userPhotoImageView];
    [self.userPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(40);
        make.top.equalTo(self.mas_top).with.offset(64);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(247);
    }];
    [IPCCustomUI clearAutoCorrection:self.mainView];
}

- (UIImageView *)userPhotoImageView{
    if (!_userPhotoImageView) {
        _userPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_userPhotoImageView zy_cornerRadiusAdvance:15.f rectCornerType:UIRectCornerAllCorners];
    }
    return _userPhotoImageView;
}

- (void)setCurrentCustomer:(IPCDetailCustomer *)currentCustomer
{
    _currentCustomer = currentCustomer;
    
    if (_currentCustomer) {
        [self.userNameTextField setText:_currentCustomer.customerName];
        [self.phoneTextField setText:_currentCustomer.customerPhone];
        [self.birthdayTextField setText:_currentCustomer.birthday];
        [self.ageTextFiled setText:_currentCustomer.age];
        [self.mailTextField setText:_currentCustomer.email];
        [self.memoTextView setText:_currentCustomer.remark];
        [self.genderTextField setText:[IPCCommon formatGender:_currentCustomer.contactorGengerString]];
        if ([self.genderTextField.text isEqualToString:@"男"] || [self.genderTextField.text isEqualToString:@"未设置"]) {
            [self.userPhotoImageView setImageWithURL:[NSURL URLWithString:_currentCustomer.photo_url] placeholder:[UIImage imageNamed:@"icon_male"]];
        }else if ([self.genderTextField.text isEqualToString:@"女"]){
            [self.userPhotoImageView setImageWithURL:[NSURL URLWithString:_currentCustomer.photo_url] placeholder:[UIImage imageNamed:@"icon_female"]];
        }
    }
}

- (void)setAllSubViewIsEnable
{
    [self.mainView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setUserInteractionEnabled:YES];
    }];
    [self.genderTextField setRightButton:self Action:@selector(showGenderPickViewAction) OnView:self.mainView];
    [self.birthdayTextField setRightButton:self Action:@selector(showDatePickViewAction) OnView:self.mainView];
}


#pragma mark //Clicked Events
- (void)showGenderPickViewAction{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    IPCDataPickViewController * pickerVC = [[IPCDataPickViewController alloc]initWithNibName:@"IPCDataPickViewController" bundle:nil];
    pickerVC.dataSource = self;
    pickerVC.delegate     = self;
    [pickerVC showWithPosition:CGPointMake(self.genderTextField.jk_width/2, self.genderTextField.jk_height) Size:CGSizeMake(self.genderTextField.jk_width, 150) Owner:self.genderTextField];
}

- (IBAction)editAction:(id)sender {
}

- (void)showDatePickViewAction{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    IPCDatePickViewController * datePickVC = [[IPCDatePickViewController alloc]initWithNibName:@"IPCDatePickViewController" bundle:nil];
    datePickVC.delegate = self;
    [datePickVC showWithPosition:CGPointMake(self.birthdayTextField.jk_width/2, self.birthdayTextField.jk_height) Size:CGSizeMake(self.birthdayTextField.jk_width, 150) Owner:self.birthdayTextField];
}

- (void)clear{
    [self.mainView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField * subTextField = (UITextField *)obj;
            [subTextField setText:@""];
        }
    }];
    [self.memoTextView setText:@""];
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
    return row == 0 ? @"男":@"女";
}

- (void)didSelectContent:(NSString *)content titleForRow:(NSInteger)row{
    self.currentCustomer.contactorGengerString = row == 0 ? @"MALE":@"FEMALE";
    if ([self.delegate respondsToSelector:@selector(reloadCustomer:)])
        [self.delegate reloadCustomer:self.currentCustomer];
}

#pragma mark //CustomDatePickViewControllerDelegate
- (void)completeChooseDate:(NSString *)date{
    self.currentCustomer.birthday = date;
    if ([self.delegate respondsToSelector:@selector(reloadCustomer:)])
        [self.delegate reloadCustomer:self.currentCustomer];
}

#pragma mark //UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:self.ageTextFiled]) {
        if (![IPCCommon judgeIsNumber:string])
            return NO;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * str = [textField.text jk_trimmingWhitespace];
   
    if (str.length > 0) {
        if ([textField isEqual:self.userNameTextField]) {
            self.currentCustomer.customerName = str;
        }else if ([textField isEqual:self.mailTextField]){
            self.currentCustomer.email = str;
        }else if ([textField isEqual:self.phoneTextField]) {
            if (![IPCCommon checkTelNumber:str]) {
                [IPCCustomUI showError:@"请输入有效的手机号码!"];
                [textField setText:@""];
            }else{
                self.currentCustomer.customerPhone = str;
            }
        }else if ([textField isEqual:self.ageTextFiled]){
            if ([str integerValue] > 0) {
                str = [NSString stringWithFormat:@"%ld",(long)[str integerValue]];
                self.currentCustomer.age = str;
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(reloadCustomer:)])
        [self.delegate reloadCustomer:self.currentCustomer];
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
    self.currentCustomer.remark = [textView.text jk_trimmingWhitespace];
    
    if ([self.delegate respondsToSelector:@selector(reloadCustomer:)])
        [self.delegate reloadCustomer:self.currentCustomer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
