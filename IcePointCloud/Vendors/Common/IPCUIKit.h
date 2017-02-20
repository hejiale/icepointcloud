//
//  IPCUIKit.h
//  IcePointCloud
//
//  Created by mac on 8/14/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IPCUIKit : NSObject

+ (nonnull UIVisualEffectView *)showBlurView:(CGRect)frame Target:(nullable id)target action:(nullable SEL)action;

+ (void)show;

+ (void)hiden;

+ (void)showError:(nonnull NSString *)message;

+ (void)showSuccess:(nonnull NSString *)message;

+ (void)showAlert:(NSString *)alertTitle Message:(NSString *)alertMesg;

+ (void)showAlert:(NSString *)title Message:(NSString *)message Owner:(id)owner Done:(void(^)())done;

+ (nonnull NSAttributedString *)subStringWithText:(nonnull NSString *)text
                                BeginRang:(NSInteger)beginRang
                                     Rang:(NSInteger)rang
                                     Font:(nonnull UIFont *)font
                                    Color:(nonnull UIColor *)color;

+ (void)textFieldLeftImageView:(NSString *)imageName
                   InTextField:(UITextField *)textField;

+ (void)textFieldRightView:(nullable id)target
                    Action:(nonnull SEL)action
               InTextField:(nonnull UITextField *)textField;

+ (void)textFieldRightButton:(nullable id)target
                      Action:(nonnull SEL)action
                 InTextField:(nonnull UITextField *)textField
                      OnView:(nonnull UIView *)onView;

+ (void)pushToRootIndex:(NSInteger)index;

+ (UIViewController *)rootViewcontroller;

+ (void)clearAutoCorrection:(UIView *)view;

+ (void)clearTextField:(UIView *)view;

@end
