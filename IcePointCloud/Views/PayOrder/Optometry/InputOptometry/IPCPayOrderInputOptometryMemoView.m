//
//  IPCPayOrderInputOptometryMemoView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderInputOptometryMemoView.h"

@interface IPCPayOrderInputOptometryMemoView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *memoTextField;

@end


@implementation IPCPayOrderInputOptometryMemoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderInputOptometryMemoView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [self.memoTextField addBottomLine];
    }
    return self;
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [IPCPayOrderManager sharedManager].insertOptometry.remark = [textField.text jk_trimmingWhitespace];
}

@end
