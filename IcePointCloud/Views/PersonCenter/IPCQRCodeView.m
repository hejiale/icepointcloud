//
//  QRCodeView.m
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCQRCodeView.h"

@implementation IPCQRCodeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCQRCodeView" owner:self];
        [self addSubview:view];
    }
    return self;
}

- (void)showWithClose:(void (^)())closeBlock
{
    self.CloseBlock = closeBlock;
    
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.frame;
        frame.origin.x -= self.jk_width;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.qrcodeImageView setImageURL:[NSURL URLWithString:[IPCAppManager sharedManager].profile.QRCodeURL]];
        }
    }];
}


- (IBAction)closeAction:(id)sender {
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.frame;
        frame.origin.x += self.jk_width;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.CloseBlock) {
                self.CloseBlock();
            }
        }
    }];
}

@end
