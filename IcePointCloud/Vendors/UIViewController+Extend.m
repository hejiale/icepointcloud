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

- (void)addBackgroundViewWithAlpha:(CGFloat)alpha InView:(UIView *)view Complete:(void (^)())completed
{
    self.backGroudView = [[UIView alloc]initWithFrame:view.bounds];
    [self.backGroudView setBackgroundColor:[UIColor clearColor]];
    [view addSubview:self.backGroudView];
    [view bringSubviewToFront:self.backGroudView];
    
    UIImageView * coverView = [[UIImageView alloc]initWithFrame:self.backGroudView.bounds];
    [coverView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:alpha]];
    [coverView setUserInteractionEnabled:YES];
    [self.backGroudView addSubview:coverView];
    
    [coverView addTapActionWithDelegate:nil Block:^(UIGestureRecognizer *gestureRecoginzer) {
        if (completed)completed();
    }];
}

- (void)setBackGroudView:(UIView *)backGroudView{
    objc_setAssociatedObject(self,coverViewIdentifier , backGroudView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)backGroudView{
    return objc_getAssociatedObject(self, coverViewIdentifier);
}

@end
