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

- (void)setLeftBack:(BOOL)isPresent
{
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 80, 40)];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton setAdjustsImageWhenHighlighted:NO];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if (isPresent) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    UIBarButtonItem * backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
}

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
