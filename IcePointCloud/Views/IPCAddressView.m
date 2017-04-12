//
//  IPCAddressView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/10.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCAddressView.h"

@interface IPCAddressView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *contacterTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;

@end

@implementation IPCAddressView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCAddressView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        self.insertAddress = [[IPCCustomerAddressMode alloc]init];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.contacterTextField addBorder:3 Width:1];
    [self.phoneTextField addBorder:3 Width:1];
    [self.addressTextField addBorder:3 Width:1];
}

#pragma mark //Clicked Events
- (IBAction)selectedMaleAction:(id)sender {
    [self.maleButton setSelected:YES];
    [self.femaleButton setSelected:NO];
    self.insertAddress.gender = @"MALE";
}

- (IBAction)selectFemalAction:(id)sender {
    [self.maleButton setSelected:NO];
    [self.femaleButton setSelected:YES];
    self.insertAddress.gender = @"FEMALE";
}

#pragma mark //UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.contacterTextField]) {
        self.insertAddress.contactName = textField.text;
    }else if ([textField isEqual:self.phoneTextField]){
        self.insertAddress.phone = self.phoneTextField.text;
    }else if ([textField isEqual:self.addressTextField]){
        self.insertAddress.detailAddress = self.addressTextField.text;
    }
}



@end
