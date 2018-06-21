//
//  IPCCustomTextField.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/27.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomTextField.h"

@interface IPCCustomTextField()

@property (nonatomic, strong) UILabel * textLabel;

@end

@implementation IPCCustomTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(beginEditAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:self.textLabel];
}

#pragma mark //Set UI
- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.leftSpace, 0, self.jk_width-self.leftSpace-self.rightSpace, self.jk_height)];
        [_textLabel setTextColor:[UIColor redColor]];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [_textLabel setFont:[UIFont systemFontOfSize:15]];
        [_textLabel setTextAlignment:self.textAlignment];
    }
    return _textLabel;
}


- (void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    
    if (isEditing) {
        [self registerNotification];
        [self addBorder:0 Width:1 Color:COLOR_RGB_BLUE];
        [IPCTextFiledControl instance].preTextField = self;
    }else{
        [self removeNotification];
        [self addBorder:0 Width:0 Color:nil];
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    
   [self.textLabel setText:text];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IPCCustomKeyboardBeginNotification object:nil userInfo:@{@"text":text}];
}

- (void)beginEditAction
{
    [self becomFirstResponder];
}

- (void)becomFirstResponder
{
    [[IPCTextFiledControl  instance] clearPreTextField];
    [self setIsEditing:YES];
}

#pragma mark //Notification Methods
- (void)endEditingNotification:(NSNotification *)notification
{
    [self setIsEditing:NO];

    [self setText:notification.userInfo[IPCCustomKeyboardValue]];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(textFieldEndEditing:)]) {
            [self.delegate textFieldEndEditing:self];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IPCCustomKeyboardEndNotification object:nil];
}

- (void)clearEdingingNotification:(NSNotification *)notification
{
    [self setText:notification.userInfo[IPCCustomKeyboardValue]];
}

- (void)changeEditingNotification:(NSNotification *)notification
{
    [self setText:notification.userInfo[IPCCustomKeyboardValue]];
}

- (void)preEditingNotification:(NSNotification *)notification
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(textFieldPreEditing:)]) {
            [self.delegate textFieldPreEditing:self];
        }
    }
}

- (void)nextEditingNotification:(NSNotification *)notification
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(textFieldNextEditing:)]) {
            [self.delegate textFieldNextEditing:self];
        }
    }
}

#pragma mark //注册监听键盘输入通知
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditingNotification:) name:IPCCustomKeyboardDoneNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearEdingingNotification:) name:IPCCustomKeyboardClearNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeEditingNotification:) name:IPCCustomKeyboardChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preEditingNotification:) name:IPCCustomKeyboardPreNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextEditingNotification:) name:IPCCustomKeyboardNextNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IPCCustomKeyboardDoneNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IPCCustomKeyboardClearNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IPCCustomKeyboardChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IPCCustomKeyboardPreNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IPCCustomKeyboardNextNotification object:nil];
}

@end
