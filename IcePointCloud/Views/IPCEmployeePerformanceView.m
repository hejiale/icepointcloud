//
//  IPCEmployeePerformanceView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCEmployeePerformanceView.h"

@interface IPCEmployeePerformanceView()

@property (nonatomic, copy) void(^UpdateBlock)(void);

@end

@implementation IPCEmployeePerformanceView

- (instancetype)initWithFrame:(CGRect)frame Update:(void (^)())update
{
    self = [super initWithFrame:frame];
    if (self) {
        self.UpdateBlock = update;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCEmployeePerformanceView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self addBorder:3 Width:0.5];
    [self.amountTextField addBorder:3 Width:0.5];
    [self.amountTextField setLeftSpace:5];
    
    UIImage *progressImage = [UIImage imageNamed:@"icon_progress"];
    UIImage *trackImage = [UIImage imageNamed:@"icon_progress_track"];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 20, 10, 20);
    progressImage = [progressImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    trackImage = [trackImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.progressView.trackImage = trackImage;
    self.progressView.progressImage = progressImage;
}

- (void)setEmployeeResult:(IPCEmployeeResult *)employeeResult{
    _employeeResult = employeeResult;
    
    if (_employeeResult) {
        [self.customerNameLabel setText:_employeeResult.employe.name];
        [self.amountButton setTitle:[NSString stringWithFormat:@"%.f%%",_employeeResult.employeeResult] forState:UIControlStateNormal];
        [self.progressView setProgress:_employeeResult.employeeResult/100];
    }
}

#pragma mark //Clicked Events
- (IBAction)removeAction:(id)sender {
    
}


- (IBAction)inputAmountAction:(id)sender {
    [self.amountButton setHidden:YES];
    [self.amountTextField setHidden:NO];
    [self.amountTextField becomeFirstResponder];
}

#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    double result = [[IPCPayOrderMode sharedManager] judgeEmployeeResult:[textField.text doubleValue] Employee:self.employeeResult];
    
    if (result > 0) {
        self.employeeResult.employeeResult = result;
    }
    
    if (self.UpdateBlock) {
        self.UpdateBlock();
    }
}

@end
