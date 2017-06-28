//
//  IPCEmployeeePerformanceView.m
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
    [self.progressBarView addSubview:self.progress];
}


- (IPCProgressView *)progress{
    if (!_progress) {
        _progress = [[IPCProgressView alloc] initWithFrame:CGRectMake(0, 0, self.progressBarView.jk_width, self.progressBarView.jk_height)];
        _progress.progressColor = COLOR_RGB_BLUE;
        _progress.bottomColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    }
    return _progress;
}


- (void)setEmployeeResult:(IPCEmployeeResult *)employeeResult{
    _employeeResult = employeeResult;
    
    if (_employeeResult) {
        [self.customerNameLabel setText:_employeeResult.employee.name];
        [self.amountButton setTitle:[NSString stringWithFormat:@"%.f%%",_employeeResult.achievement] forState:UIControlStateNormal];
        [self.progress setProgressValue:[NSString stringWithFormat:@"%.2f",_employeeResult.achievement/100]];
        if (employeeResult.isUpdateStatus) {
            [self.amountButton setEnabled:NO];
            [self.closeButton setHidden:YES];
        }
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![IPCCommon judgeIsIntNumber:string]) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    double  result = [[IPCPayOrderManager sharedManager] judgeEmployeeResult:[textField.text doubleValue] Employee:self.employeeResult];
    
    if (result > 0) {
        self.employeeResult.achievement = result;
    }
    
    if (self.UpdateBlock) {
        self.UpdateBlock();
    }
}

@end
