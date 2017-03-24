//
//  IPCPayOrderPayTypeView.m
//  IcePointCloud
//
//  Created by gerry on 2017/3/23.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderPayTypeView.h"

@interface IPCPayOrderPayTypeView()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@end

@implementation IPCPayOrderPayTypeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderPayTypeView" owner:self];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.contentView addSignleCorner:UIRectCornerAllCorners Size:5];
    [self.completeButton setBackgroundColor:COLOR_RGB_BLUE];
    [self.completeButton addSignleCorner:UIRectCornerBottomLeft|UIRectCornerBottomRight Size:5];
}



@end
