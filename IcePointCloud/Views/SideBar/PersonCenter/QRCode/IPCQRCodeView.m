//
//  QRCodeView.m
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCQRCodeView.h"

@interface IPCQRCodeView()

@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;

@end

@implementation IPCQRCodeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCQRCodeView" owner:self];
        [self addSubview:view];
        
//        [self.qrcodeImageView setImageURL:[NSURL URLWithString:[IPCAppManager sharedManager].profile.QRCodeURL]];
    }
    return self;
}

- (IBAction)closeAction:(id)sender {
    [self dismiss];
}

@end
