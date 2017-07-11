//
//  RootMenuViewController.h
//  IcePointCloud
//
//  Created by mac on 16/8/4.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCRootMenuViewControllerDelegate;

@interface IPCTabBarViewController : UIViewController

@property (nonatomic, readwrite, copy)   NSArray<UIViewController *> *viewControllers;
@property (nonatomic, readwrite, copy) UIViewController *selectedViewController;
@property (nonatomic, readwrite, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) id<IPCRootMenuViewControllerDelegate>delegate;

@end

@protocol IPCRootMenuViewControllerDelegate <NSObject>

@optional
- (void)tabBarController:(IPCTabBarViewController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end
