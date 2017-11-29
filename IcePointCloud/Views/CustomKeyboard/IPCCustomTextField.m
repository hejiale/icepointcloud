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
        [self addSubview:self.textLabel];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(beginEditAction)];
        [self addGestureRecognizer:tap];
        
        self.backgroundNormalColor = [UIColor clearColor];
        self.backgroundEditingColor = [[UIColor jk_colorWithHexString:@"#4D9FD8"] colorWithAlphaComponent:0.2];
        self.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

#pragma mark //Set UI
- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.jk_width-10, self.jk_height)];
        [_textLabel setTextColor:[UIColor redColor]];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [_textLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _textLabel;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    
    [self.textLabel setTextAlignment:textAlignment];
}


- (void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    
    if (isEditing) {
        [self registerNotification];
        [self addBorder:0 Width:1 Color:COLOR_RGB_BLUE];
        
        if (self.clearOnEditing) {
            [[NSNotificationCenter defaultCenter] postNotificationName:IPCCustomKeyboardBeginNotification object:nil];
        }
    }else{
        [self removeNotification];
        [self addBorder:0 Width:0 Color:nil];
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    
   [self.textLabel setText:text];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:IPCCustomKeyboardStringNotification object:nil userInfo:@{@"text":text}];
}

- (void)beginEditAction
{
    [[IPCTextFiledControl instance] clearAllEditingAddition:self];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(textFieldBeginEditing:)]) {
            [self.delegate textFieldBeginEditing:self];
        }
    }
    
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
    if (!self.isEditing) {
        return;
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(textFieldPreEditing:)]) {
            [self.delegate textFieldPreEditing:self];
        }
    }
}

- (void)nextEditingNotification:(NSNotification *)notification
{
    if (!self.isEditing) {
        return;
    }
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
