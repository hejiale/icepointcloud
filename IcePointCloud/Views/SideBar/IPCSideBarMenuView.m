//
//  IPCRootBarMenuView.m
//  IcePointCloud
//
//  Created by gerry on 2017/3/13.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCSideBarMenuView.h"
#import "IPCShowContentView.h"

#define IPCMenuShowWidth  400

@interface IPCSideBarMenuView()<IPCPersonConetentViewDelegate>

@property (nonatomic, strong) IPCShowContentView * showContentView;
@property (nonatomic, copy) void(^DismissBlock)();

@end

@implementation IPCSideBarMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCSideBarMenuView" owner:self];
        [view setFrame:frame];
        [self addSubview:view];
        
        [self addSubview:self.showContentView];
        [self.showContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(0);
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(0);
            make.width.mas_equalTo(IPCMenuShowWidth);
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.showContentView show];
}


#pragma mark //Set UI
- (IPCShowContentView *)showContentView
{
    if (!_showContentView) {
        _showContentView = [[IPCShowContentView alloc]init];
        _showContentView.delegate = self;
    }
    return _showContentView;
}

#pragma mark //Clicked Events
- (IBAction)tapBgAction:(id)sender
{
    [self.showContentView dismiss];
}

#pragma mark //
- (void)dismissContentView
{
    [self removeFromSuperview];
}


@end
