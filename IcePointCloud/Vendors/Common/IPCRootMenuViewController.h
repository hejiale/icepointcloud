//
//  RootMenuViewController.h
//  IcePointCloud
//
//  Created by mac on 16/8/4.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCRootMenuViewControllerDelegate;

@interface IPCRootMenuViewController : UIViewController

@property (nonatomic, readwrite, copy)   NSArray *viewControllers;
@property (nonatomic, readwrite, assign) UIViewController *selectedViewController;
@property (nonatomic, readwrite, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) id<IPCRootMenuViewControllerDelegate>delegate;


@end

@protocol IPCRootMenuViewControllerDelegate <NSObject>

@optional
- (void)tabBarController:(IPCRootMenuViewController *)tabBarController didSelectViewController:(UIViewController *)viewController;
- (BOOL)tabBarController:(IPCRootMenuViewController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)showShoppingCartView;
- (void)showPersonView;//According to personal center page
- (void)judgeIsCheckoutOrder:(NSInteger)index;//Judge whether the current is to place an order
- (void)judgeIsInsertNewCustomer:(NSInteger)index;

@end
