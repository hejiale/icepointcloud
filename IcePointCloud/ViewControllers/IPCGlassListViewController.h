//
//  GlassListViewController.h
//  IcePointCloud
//
//  Created by mac on 7/23/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCGlassListViewController : IPCRootNavigationViewController

- (void)addNotifications;
- (void)reload;
- (void)rootRefresh;
- (void)removeCover;

@end
