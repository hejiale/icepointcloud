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

@protocol IPCSearchViewControllerDelegate <NSObject>

- (void)didSearchWithKeyword:(NSString *)keyword;

@end

@interface IPCSearchViewController : IPCPresentModeViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate>

@property (nonatomic, copy) NSString * currentSearchword;
@property (nonatomic, assign) id<IPCSearchViewControllerDelegate> delegate;

@end
