//
//  IPCAddressView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/10.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCAddressView.h"

typedef void(^UpdateUIBlock)(void);

@interface IPCAddressView()<UITextFieldDelegate>

@property (copy, nonatomic) UpdateUIBlock updateBlock;

@end

@implementation IPCAddressView

- (instancetype)initWithFrame:(CGRect)frame Update:(void(^)())update
{
    self = [super initWithFrame:frame];
    if (self) {
        self.updateBlock = update;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCAddressView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.contacterTextField addBorder:3 Width:1];
    [self.phoneTextField addBorder:3 Width:1];
    [self.addressTextField addBorder:3 Width:1];
    [self.contacterTextField setLeftSpace:5];
    [self.phoneTextField setLeftSpace:5];
    [self.addressTextField setLeftSpace:5];
}


#pragma mark //Clicked Events
- (IBAction)selectedMaleAction:(id)sender {
    [self.maleButton setSelected:YES];
    [self.femaleButton setSelected:NO];
 
    if (self.updateBlock) {
        self.updateBlock();
    }
}

- (IBAction)selectFemalAction:(id)sender {
    [self.maleButton setSelected:NO];
    [self.femaleButton setSelected:YES];

    if (self.updateBlock) {
        self.updateBlock();
    }
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.addressTextField]) {
        [textField endEditing:YES];
    }else{
        UITextField * nextTextField = (UITextField *)[self viewWithTag:textField.tag + 1];
        [nextTextField becomeFirstResponder];
    }
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString * str = [textField.text jk_trimmingWhitespace];
    
    if (str.length) {
        if (self.updateBlock) {
            self.updateBlock();
        }
    }
    
}



@end
