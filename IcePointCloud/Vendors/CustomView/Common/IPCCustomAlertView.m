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
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (copy, nonatomic) NSString * title;
@property (copy, nonatomic) NSString * message;
@property (copy, nonatomic) NSString * cancelTitle;
@property (copy, nonatomic) NSString * doneTitle;

@property (copy, nonatomic) void(^CancleBlock)();
@property (copy, nonatomic) void(^DoneBlock)();

@end

@implementation IPCCustomAlertView


+ (void)showWithTitle:(NSString *)title Message:(NSString *)message SureTitle:(NSString *)sureTitle Done:(void(^)())done
{
    IPCCustomAlertView * alertView = [[IPCCustomAlertView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds Title:title Message:message SureTitle:sureTitle Done:done];
    [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:alertView];
}


- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title Message:(NSString *)message SureTitle:(NSString *)sureTitle Done:(void(^)())done
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCCustomAlertView" owner:self];
        [self addSubview:view];
        
        self.title = title;
        self.message = message;
        self.doneTitle = sureTitle;
        self.DoneBlock = done;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.contentView addBorder:8 Width:0 Color:nil];
    [self.sureButton addSignleCorner:UIRectCornerBottomRight Size:8];
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
        
        CGFloat height = [_message jk_sizeWithFont:self.contentTextView.font constrainedToWidth:self.contentTextView.jk_width].height;
        CGFloat maxHeight = MAX(height, 115);
        self.contentHeight.constant += maxHeight - 115;
    }
}

- (void)setDoneTitle:(NSString *)doneTitle{
    _doneTitle = doneTitle;
    
    if (_doneTitle.length) {
        [self.sureButton setTitle:_doneTitle forState:UIControlStateNormal];
    }
}


- (IBAction)doneAction:(id)sender {
    if (self.DoneBlock) {
        self.DoneBlock();
    }
}

@end
