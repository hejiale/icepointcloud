//
//  IPCPayorderScrollPageView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/16.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayorderScrollPageView.h"

#define   SpaceRectSize    100
#define   RoundRectSize   40

@interface IPCPayorderScrollPageView()

@property (nonatomic, strong) NSMutableArray<UIImageView *> *  allCornerViews;

@end

@implementation IPCPayorderScrollPageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (NSMutableArray<UIImageView *> *)allCornerViews
{
    if (!_allCornerViews) {
        _allCornerViews = [[NSMutableArray alloc]init];
    }
    return _allCornerViews;
}

- (void)setNumberPages:(NSInteger)numberPages
{
    _numberPages = numberPages;
    
    if (_numberPages > 0) {
        [self createPageControlView];
        [self setCurrentPage:0];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    
    [self.allCornerViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == currentPage) {
            [obj addBorder:RoundRectSize/2 Width:2 Color:COLOR_RGB_BLUE];
            UIImage * onImage = [UIImage imageNamed:self.onPageImages[idx]];
            [obj setImage:onImage];
        }else{
            [obj addBorder:RoundRectSize/2 Width:1 Color:nil];
            UIImage * image = [UIImage imageNamed:self.pageImages[idx]];
            [obj setImage:image];
        }
    }];
}

#pragma mark //Set UI
- (void)createPageControlView
{
    __weak typeof(self) weakSelf = self;
    __block CGFloat lineHeight = self.jk_height - (SpaceRectSize*2) - RoundRectSize;
    __block CGFloat space = lineHeight/(self.numberPages-1);
    
    for (NSInteger i = 0; i < self.numberPages; i++) {
        UIImageView * cornerView = [[UIImageView alloc]initWithFrame:CGRectMake(self.jk_centerX-RoundRectSize/2, i*space+SpaceRectSize, RoundRectSize, RoundRectSize)];
        [cornerView setBackgroundColor:[UIColor clearColor]];
        [cornerView setUserInteractionEnabled:YES];
        [cornerView setTag:i];
        [self addSubview:cornerView];
        [self.allCornerViews addObject:cornerView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCornerAction:)];
        [cornerView addGestureRecognizer:tap];
    }
}

#pragma mark //Clicked Events
- (void)tapCornerAction:(UITapGestureRecognizer *)sender
{
    if ([sender.view tag] == _currentPage)return;
    
    if (![IPCPayOrderManager sharedManager].currentCustomerId)
    {
        [IPCCommonUI showError:@"请先选择客户信息!"];
    }else{
        self.currentPage = [sender.view tag];
        
        if ([self.delegate respondsToSelector:@selector(changePageIndex:)]) {
            [self.delegate changePageIndex:[sender.view tag]];
        }
    }
}

@end


