//
//  IPCCustomsizedOtherView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedOtherView.h"

@implementation IPCCustomsizedOtherView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCCustomsizedOtherView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.otherParameterTextField addBorder:3 Width:0.5];
    [self.otherDescription addBorder:3 Width:0.5];
    [self.otherDescription setLeftSpace:10];
    [self.otherParameterTextField setLeftSpace:10];
    [self.deleteButton.layer setCornerRadius:3];
}

- (IBAction)deleteAction:(id)sender {
}

@end
