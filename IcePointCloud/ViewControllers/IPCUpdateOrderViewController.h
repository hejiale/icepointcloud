//
//  IPCUpdateOrderViewController.h
//  IcePointCloud
//
//  Created by gerry on 2017/6/7.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCUpdateOrderViewControllerDelegate;
@interface IPCUpdateOrderViewController : IPCRootNavigationViewController

@property (nonatomic, assign) id<IPCUpdateOrderViewControllerDelegate>delegate;

@end

@protocol IPCUpdateOrderViewControllerDelegate <NSObject>

- (void)updatePayOrder;

@end
