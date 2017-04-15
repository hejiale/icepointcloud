//
//  IPCOtherPayTypeView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCOtherPayTypeView.h"

@interface IPCOtherPayTypeView()<UITextFieldDelegate>

@end

@implementation IPCOtherPayTypeView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCOtherPayTypeView" owner:self];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.payTypeNameTextField addBorder:3 Width:1];
    [self.payAmountTextField addBorder:3 Width:1];
}


#pragma mark //Clicked Events
- (IBAction)onSelectPayTypeAction:(id)sender {
    
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}


@end
