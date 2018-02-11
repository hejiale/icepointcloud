//
//  IPCProductViewController.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/11.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCProductViewController.h"

@interface IPCProductViewController ()
{
    pthread_mutex_t _lock;
}

@end

@implementation IPCProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pthread_mutex_init(&_lock, NULL);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavigationBarStatus:YES];
}

#pragma mark //Request Data
- (void)loadNormalProducts:(void(^)())complete
{
    pthread_mutex_lock(&_lock);
    
    //Reset Glasses Data
    [self.glassListViewMode resetData];
    
    __weak typeof(self) weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [weakSelf loadGlassesListData:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [weakSelf filterGlassesCategory:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (complete) {
            complete();
        }
        
        pthread_mutex_unlock(&_lock);
    });
}


- (void)loadGlassesListData:(void(^)())complete
{
    __weak typeof(self) weakSelf = self;
    [self.glassListViewMode reloadGlassListDataWithComplete:^(NSError * error){
        _isCancelRequest = NO;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.glassListViewMode.status == IPCFooterRefresh_HasNoMoreData){
            [strongSelf.refreshFooter noticeNoDataStatus];
        }else if (strongSelf.glassListViewMode.status == IPCRefreshError){
            if ([error code] == NSURLErrorCancelled) {
                _isCancelRequest = YES;
            }else{
                [IPCCommonUI showError:@"搜索商品失败,请稍后重试!"];
            }
        }
        if (complete) {
            complete();
        }
    }];
}

- (void)filterGlassesCategory:(void(^)())complete
{
    [self.glassListViewMode filterGlassCategoryWithFilterSuccess:^(NSError *error) {
        _isCancelRequest = NO;
        
        if (error) {
            if ([error code] == NSURLErrorCancelled) {
                _isCancelRequest = YES;
            }else{
                [IPCCommonUI showError:@"获取商品分类数据失败,请稍后重试!"];
            }
        }
        if (complete) {
            complete();
        }
    }];
}


#pragma mark //Set UI
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
        [weakSelf reload];
    }];
    self.parameterView.glasses = glasses;
    [[UIApplication sharedApplication].keyWindow addSubview:self.parameterView];
    [self.parameterView show];
}

//Show Edit Batch Paremeter View
- (void)editGlassesParemeterView:(IPCGlasses *)glasses
{
    __weak typeof(self) weakSelf = self;
    self.editParameterView = [[IPCEditBatchParameterView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds Glasses:glasses Dismiss:^{
        [weakSelf reload];
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
