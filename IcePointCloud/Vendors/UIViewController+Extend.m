//
//  UIViewController+Extend.m
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "UIViewController+Extend.h"


static char const *  coverViewIdentifier = "coverViewIdentifier";

@implementation UIViewController (Extend)

- (void)setBackground{
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F4F4F4"]];
}

- (void)addCoverWithAlpha:(CGFloat)alpha Complete:(void (^)())completed
{
    self.coverView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.coverView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.coverView];
    [self.view bringSubviewToFront:self.coverView];
    
    UIImageView * coverView = [[UIImageView alloc]initWithFrame:self.coverView.bounds];
    [coverView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:alpha]];
    [coverView setUserInteractionEnabled:YES];
    [self.coverView addSubview:coverView];
    
    [coverView addTapActionWithDelegate:nil Block:^(UIGestureRecognizer *gestureRecoginzer) {
        if (completed)completed();
    }];
}

- (void)setCoverView:(UIView *)coverView{
    objc_setAssociatedObject(self,coverViewIdentifier , coverView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)coverView{
    return objc_getAssociatedObject(self, coverViewIdentifier);
}

@end
