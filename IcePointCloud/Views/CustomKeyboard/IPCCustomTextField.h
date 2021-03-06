//
//  IPCCustomTextField.h
//  IcePointCloud
//
//  Created by gerry on 2017/11/27.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCCustomTextFieldDelegate;

@interface IPCCustomTextField : UIControl

@property(nonatomic,copy)   NSString   * text;

@property(nonatomic, assign) BOOL isEditing;

@property(nonatomic, assign) NSTextAlignment textAlignment;

@property(nonatomic, assign) CGFloat  leftSpace;

@property(nonatomic, assign) CGFloat  rightSpace;

@property(nonatomic, assign) id<IPCCustomTextFieldDelegate>delegate;

- (void)becomFirstResponder;

@end

