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
@property (nonatomic, copy) NSString * preText;

@end

@implementation IPCCustomTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLabel];
        
        __weak typeof(self) weakSelf =self;
        [self jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf beginEditAction];
        }];
        
        self.backgroundNormalColor = [UIColor clearColor];
        self.backgroundEditingColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
    }
    return self;
}

#pragma mark //Set UI
- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]initWithFrame:self.bounds];
        [_textLabel setTextColor:[UIColor redColor]];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [_textLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _textLabel;
}


- (void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    
    if (isEditing) {
        [self registerNotification];
        
        [self setBackgroundColor:self.backgroundEditingColor];
        
        if (self.clearOnEditing) {
            [self.textLabel setText:@""];
            [[NSNotificationCenter defaultCenter] postNotificationName:IPCCustomKeyboardBeginNotification object:nil];
        }
    }else{
        [self setBackgroundColor:self.backgroundNormalColor];
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    ///原始值
    _preText = text;
    
   [self.textLabel setText:text];
}

- (void)beginEditAction
{
    [[IPCTextFiledControl instance] clearAllEditingAddition:self];
}

- (void)reload
{
    [self.textLabel setText:self.preText];
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
    
    [self removeNotification];
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
