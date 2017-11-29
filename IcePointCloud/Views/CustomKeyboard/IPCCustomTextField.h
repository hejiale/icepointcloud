//
//  IPCCustomTextField.h
//  IcePointCloud
//
//  Created by gerry on 2017/11/27.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCCustomTextFieldDelegate;

@interface IPCCustomTextField : UIView

@property(nonatomic,copy)   NSString   * text;

@property(nonatomic, strong) UIColor * backgroundNormalColor;

@property(nonatomic, strong) UIColor * backgroundEditingColor;

@property(nonatomic, assign) BOOL isEditing;

@property(nonatomic, assign) BOOL clearOnEditing;

@property(nonatomic, assign) NSTextAlignment textAlignment;

@property(nonatomic, assign) id<IPCCustomTextFieldDelegate>delegate;

@end

@protocol IPCCustomTextFieldDelegate <NSObject>

@optional
- (void)textFieldBeginEditing:(IPCCustomTextField *)textField;

- (void)textFieldPreEditing:(IPCCustomTextField *)textField;

- (void)textFieldNextEditing:(IPCCustomTextField *)textField;

- (void)textFieldEndEditing:(IPCCustomTextField *)textField;



@end
