//
//  IPCUIKit.m
//  IcePointCloud
//
//  Created by mac on 8/14/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCUIKit.h"

@implementation IPCUIKit

#pragma mark //Gaussian blur
+ (UIVisualEffectView *)showBlurView:(CGRect)frame Target:(nullable id)target action:(nullable SEL)action
{
    UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualEfView.frame = frame;
    visualEfView.alpha = 0.9;
    [visualEfView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer * blurTap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [visualEfView addGestureRecognizer:blurTap];
    
    return visualEfView;
}

#pragma mark //Warning prompt box
+ (void)show{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD show];
}

+ (void)hiden{
    [SVProgressHUD dismiss];
}

+ (void)showError:(NSString *)message
{
    [SVProgressHUD setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightThin]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5f];
    [SVProgressHUD showErrorWithStatus:message];
}


+ (void)showSuccess:(NSString *)message{
    [SVProgressHUD setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightThin]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD showSuccessWithStatus:message];
}

+ (void)showAlert:(NSString *)alertTitle Message:(NSString *)alertMesg
{
    [[UIApplication sharedApplication].keyWindow.rootViewController showAlertWithTitle:alertTitle Message:alertMesg Process:^(IPCAlertController *alertController) {
        alertController.addCancelTitle(@"返回");
    } ActionBlock:nil];
}

+ (void)showAlert:(NSString *)title Message:(NSString *)message Owner:(id)owner Done:(void(^)())done
{
    if (owner && [owner isKindOfClass:[UIViewController class]]) {
        [owner showAlertWithTitle:title Message:message Process:^(IPCAlertController *alertController) {
            alertController.addCancelTitle(@"返回");
            alertController.addDestructiveTitle(@"确定");
        } ActionBlock:^(NSInteger buttonIndex, UIAlertAction *action, IPCAlertController *alertSelf) {
            if (buttonIndex == 1) {
                if (done) {
                    done();
                }
            }
        }];
    }
}

#pragma mark //UILabel String manipulation
+ (NSAttributedString *)subStringWithText:(NSString *)text BeginRang:(NSInteger)beginRang Rang:(NSInteger)rang Font:(UIFont *)font Color:(UIColor *)color
{
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    if (color)
        [aAttributedString addAttribute:NSForegroundColorAttributeName
                                  value:color
                                  range:NSMakeRange(beginRang, rang)];
    if (font)
        [aAttributedString addAttribute:NSFontAttributeName
                                  value:font
                                  range:NSMakeRange(beginRang, rang)];
    
    return aAttributedString;
}

#pragma mark //UITextField Add RightView
+ (void)textFieldLeftImageView:(NSString *)imageName InTextField:(UITextField *)textField
{
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, textField.jk_height, textField.jk_height)];
    [leftView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView * leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    [leftImageView setImage:[UIImage imageNamed:imageName]];
    [leftImageView setCenter:leftView.center];
    [leftView addSubview:leftImageView];
    
    [textField setLeftView:leftView];
    [textField setLeftViewMode:UITextFieldViewModeAlways];
}


+ (void)textFieldRightView:(id)target Action:(SEL)action InTextField:(UITextField *)textField
{
    UIButton * chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseButton setFrame:CGRectMake(0, 0, 40, 40)];
    [chooseButton setImage:[UIImage imageNamed:@"icon_right_down_btn"] forState:UIControlStateNormal];
    [chooseButton setBackgroundColor:[UIColor clearColor]];
    [chooseButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [textField setRightView:chooseButton];
    [textField setRightViewMode:UITextFieldViewModeAlways];
}


+ (void)textFieldRightButton:(id)target Action:(SEL)action InTextField:(UITextField *)textField OnView:(UIView *)onView
{
    UIButton * chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseButton setFrame:textField.frame];
    [chooseButton setBackgroundColor:[UIColor clearColor]];
    [chooseButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [onView addSubview:chooseButton];
    
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, textField.jk_height)];
    [rightView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView * rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, rightView.jk_height/2-6, 12, 12)];
    [rightImage setImage:[UIImage imageNamed:@"icon_right_down_btn"]];
    rightImage.contentMode = UIViewContentModeScaleAspectFit;
    [rightImage setBackgroundColor:[UIColor clearColor]];
    [rightView addSubview:rightImage];
    
    [textField setUserInteractionEnabled:NO];
    [textField setRightView:rightView];
    [textField setRightViewMode:UITextFieldViewModeAlways];
}

#pragma mark//TabBar Push Methods
+ (void)pushToRootIndex:(NSInteger)index{
    UIViewController * rootNavigation = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootNavigation isKindOfClass:[UINavigationController class]]) {
        UINavigationController * rootNav = (UINavigationController *)rootNavigation;
        UIViewController * rootVC = rootNav.viewControllers[0];
        if ([rootVC isKindOfClass:[IPCRootViewController class]]) {
            IPCRootViewController * mainRootVC = (IPCRootViewController *)rootVC;
            [mainRootVC setSelectedIndex:index];
        }
    }
}

#pragma mark //Main Viewcontroller
+ (UIViewController *)rootViewcontroller{
    UIViewController * rootNavigation = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootNavigation isKindOfClass:[UINavigationController class]]) {
        UINavigationController * rootNav = (UINavigationController *)rootNavigation;
        UIViewController * rootVC = rootNav.viewControllers[0];
        if ([rootVC isKindOfClass:[IPCRootMenuViewController class]]) {
            return rootVC;
        }
    }
    return nil;
}

#pragma mark //Remove automatically associate attribute of the input box
+ (void)clearAutoCorrection:(UIView *)view
{
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField * subTextField = (UITextField *)obj;
            [subTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [subTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        }
    }];
}

#pragma mark //Clear the input box on the specified View
+ (void)clearTextField:(UIView *)view
{
    [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField * subTextField = (UITextField *)obj;
            [subTextField setText:@""];
        }
    }];
}

@end
