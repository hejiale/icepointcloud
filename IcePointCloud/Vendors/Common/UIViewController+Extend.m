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

- (void)setNavigationTitle:(NSString *)title
{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    [titleLabel setTextColor:[UIColor darkGrayColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightThin]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:title];
    [self.navigationItem setTitleView:titleLabel];
}


-(void)startAnimationWithStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint
{
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addCurveToPoint:CGPointMake(endPoint.x, endPoint.y)
            controlPoint1:CGPointMake(startPoint.x, startPoint.y)
            controlPoint2:CGPointMake(startPoint.x - 50, startPoint.y - 50)];
    
    CALayer *layer = [CALayer layer];
    layer.contentsGravity = kCAGravityResizeAspectFill;
    layer.bounds = CGRectMake(0, 0, 20, 20);
    layer.backgroundColor = COLOR_RGB_BLUE.CGColor;
    [layer setCornerRadius:10];
    layer.position = startPoint;
    [self.view.superview.layer addSublayer:layer];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation];
    groups.duration   = 0.5f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    [layer addAnimation:groups forKey:@"group"];
    
    [self performSelector:@selector(removeFromLayer:) withObject:layer afterDelay:0.5f];
}

- (void)removeFromLayer:(CALayer *)layerAnimation{
    [layerAnimation removeFromSuperlayer];
}

- (void)addBackgroundViewWithAlpha:(CGFloat)alpha Complete:(void (^)())completed
{
    self.backGroudView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.backGroudView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.backGroudView];
    [self.view bringSubviewToFront:self.backGroudView];
    [self.backGroudView addTapActionWithDelegate:nil Block:^(UIGestureRecognizer *gestureRecoginzer) {
        if (completed)completed();
    }];
    
    UIImageView * coverView = [[UIImageView alloc]initWithFrame:self.backGroudView.bounds];
    [coverView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:alpha]];
    [self.backGroudView addSubview:coverView];
}

- (void)setBackGroudView:(UIView *)backGroudView{
    objc_setAssociatedObject(self,coverViewIdentifier , backGroudView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)backGroudView{
    return objc_getAssociatedObject(self, coverViewIdentifier);
}



@end
