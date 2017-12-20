//
//  PresentModeViewController.m
//  IcePointCloud
//
//  Created by mac on 16/8/4.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPresentModeViewController.h"

@interface ModalTransition : NSObject <UIViewControllerAnimatedTransitioning>

@end

@implementation ModalTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return .5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (!transitionContext)return;
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    BOOL isPresenting = [toVC isKindOfClass:[IPCPresentModeViewController class]];
    
    if (isPresenting) {
        [[transitionContext containerView] addSubview:toVC.view];
        
        CGRect fullFrame = [transitionContext initialFrameForViewController:fromVC];
        toVC.view.frame = CGRectMake(0, -fullFrame.size.height, fullFrame.size.width, fullFrame.size.height);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect    rect = toVC.view.frame;
                             rect.origin.y += toVC.view.jk_height;
                             toVC.view.frame = rect;
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [transitionContext completeTransition:YES];
                             }
                         }];
    } else {
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect    rect = fromVC.view.frame;
                             rect.origin.y -= fromVC.view.jk_height;
                             fromVC.view.frame = rect;
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [transitionContext completeTransition:YES];
                             }
                         }];
    }
}

@end

@interface IPCPresentModeViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation IPCPresentModeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark //UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [ModalTransition new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [ModalTransition new];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
