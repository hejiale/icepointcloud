//
//  IPCCommonUI.h
//  IcePointCloud
//
//  Created by mac on 8/14/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IPCCommonUI : NSObject

+ (nonnull UIVisualEffectView *)showBlurView:(CGRect)frame Target:(nullable id)target action:(nullable SEL)action;

+ (void)show;

+ (void)showInfo:(nonnull NSString *)message;

+ (void)hiden;

+ (void)showAlert:(NSString *)alertTitle Message:(NSString *)alertMesg;

+ (void)showAlert:(NSString *)title Message:(NSString *)message Owner:(id)owner Done:(void(^)())done;

+ (nonnull NSAttributedString *)subStringWithText:(nonnull NSString *)text
                                BeginRang:(NSInteger)beginRang
                                     Rang:(NSInteger)rang
                                     Font:(nonnull UIFont *)font
                                    Color:(nonnull UIColor *)color;

+ (void)pushToRootIndex:(NSInteger)index;

+ (void)clearAutoCorrection:(UIView *)view;

+ (UIView *)nearestAncestorForView:(UIView *)aView withClass:(Class)aClass;

@end