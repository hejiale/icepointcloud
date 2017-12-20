//
//  IPCSearchCustomerViewController.h
//  IcePointCloud
//
//  Created by gerry on 2017/12/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCPresentModeViewController.h"
#import "IPCSearchViewDelegate.h"

@interface IPCSearchCustomerViewController : IPCPresentModeViewController

@property (nonatomic, assign) id<IPCSearchViewDelegate> searchDelegate;

- (void)showSearchCustomerViewWithSearchWord:(NSString *)word;

@end
