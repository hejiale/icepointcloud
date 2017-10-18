//
//  IPCProductViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/11.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCProductViewController.h"

@interface IPCProductViewController ()

@end

@implementation IPCProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:YES];
}

- (IPCRefreshAnimationHeader *)refreshHeader{
    if (!_refreshHeader){
        _refreshHeader = [IPCRefreshAnimationHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginRefresh)];
    }
    return _refreshHeader;
}

- (IPCRefreshAnimationFooter *)refreshFooter{
    if (!_refreshFooter)
    _refreshFooter = [IPCRefreshAnimationFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    return _refreshFooter;
}

#pragma mark //Clicked Events
- (void)reload
{
    
}

- (void)removeCover
{
    
}

- (void)onFilterProducts
{
    

}

- (void)onSearchProducts
{
    
}

//Show Choose Glasses Batch Paremeter View
- (void)showGlassesParameterView:(IPCGlasses *)glasses
{
    
    __weak typeof(self) weakSelf = self;
    self.parameterView = [[IPCGlassParameterView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds  Complete:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf reload];
    }];
    self.parameterView.glasses = glasses;
    [[UIApplication sharedApplication].keyWindow addSubview:self.parameterView];
    [self.parameterView show];
}

//Show Edit Batch Paremeter View
- (void)editGlassesParemeterView:(IPCGlasses *)glasses
{
    __weak typeof (self) weakSelf = self;
    self.editParameterView = [[IPCEditBatchParameterView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds Glasses:glasses Dismiss:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf reload];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self.editParameterView];
    [self.editParameterView show];
}

//Add To Shopping Cart Animation
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

- (void)stopRefresh{
    if (self.refreshHeader.isRefreshing) {
        [self.refreshHeader endRefreshing];
    }
    if (self.refreshFooter.isRefreshing) {
        [self.refreshFooter endRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
