//
//  SearchViewController.h
//  IcePointCloud
//
//  Created by mac on 8/14/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCPresentModeViewController.h"
#import "IPCSearchItemTableViewCell.h"


@protocol IPCSearchViewControllerDelegate;

@interface IPCSearchViewController : IPCPresentModeViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) id<IPCSearchViewControllerDelegate> searchDelegate;

- (void)showSearchProductViewWithSearchWord:(NSString *)word;
- (void)showSearchCustomerViewWithSearchWord:(NSString *)word;

@end


@protocol IPCSearchViewControllerDelegate <NSObject>

- (void)didSearchWithKeyword:(NSString *)keyword;

@end


