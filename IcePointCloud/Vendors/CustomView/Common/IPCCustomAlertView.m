//
//  IPCCustomAlertView.m
//  IcePointCloud
//
//  Created by gerry on 2018/2/2.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCCustomAlertView.h"

@interface IPCCustomAlertView()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (copy, nonatomic) NSString * title;
@property (copy, nonatomic) NSString * message;
@property (copy, nonatomic) NSString * cancelTitle;
@property (copy, nonatomic) NSString * doneTitle;

@property (copy, nonatomic) void(^CancleBlock)();
@property (copy, nonatomic) void(^DoneBlock)();

@end

@implementation IPCCustomAlertView


+ (void)showWithTitle:(NSString *)title Message:(NSString *)message CancelTitle:(NSString *)cancelTitle SureTitle:(NSString *)sureTitle Done:(void(^)())done Cancel:(void(^)())cancel
{
    IPCCustomAlertView * alertView = [[IPCCustomAlertView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds Title:title Message:message CancelTitle:cancelTitle SureTitle:sureTitle Done:done Cancel:cancel];
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:alertView];
}


- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title Message:(NSString *)message CancelTitle:(NSString *)cancelTitle SureTitle:(NSString *)sureTitle Done:(void(^)())done Cancel:(void(^)())cancel
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCCustomAlertView" owner:self];
        [self addSubview:view];
        
        self.title = title;
        self.message = message;
        self.cancelTitle = cancelTitle;
        self.doneTitle = sureTitle;
        self.DoneBlock = done;
        self.CancleBlock = cancel;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.contentView addBorder:5 Width:0 Color:nil];
    [self.cancelButton addSignleCorner:UIRectCornerBottomLeft Size:5];
    [self.sureButton addSignleCorner:UIRectCornerBottomRight Size:5];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    if (_title.length) {
        [self.titleLabel setText:_title];
    }
}

- (void)setMessage:(NSString *)message{
    _message = message;
    
    if (_message.length) {
        [self.contentTextView setText:_message];
        
        CGFloat height = [_message jk_sizeWithFont:self.contentTextView.font constrainedToWidth:self.contentWidth.constant].height;
        CGFloat maxHeight = MAX(height, 105);
        self.contentHeight.constant += maxHeight - 105;
    }
}

- (void)setCancelTitle:(NSString *)cancelTitle{
    _cancelTitle = cancelTitle;
    
    if (_cancelTitle.length) {
        [self.cancelButton setTitle:_cancelTitle forState:UIControlStateNormal];
    }
}

- (void)setDoneTitle:(NSString *)doneTitle{
    _doneTitle = doneTitle;
    
    if (_doneTitle.length) {
        [self.sureButton setTitle:_doneTitle forState:UIControlStateNormal];
    }
}


- (IBAction)cancleAction:(id)sender {
    if (self.CancleBlock) {
        self.CancleBlock();
    }
    [self removeFromSuperview];
}


- (IBAction)doneAction:(id)sender {
    if (self.DoneBlock) {
        self.DoneBlock();
    }
    [self removeFromSuperview];
}

@end
