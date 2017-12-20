//
//  SearchViewController.h
//  IcePointCloud
//
//  Created by mac on 8/14/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCPresentModeViewController.h"
#import "IPCSearchViewDelegate.h"

@interface IPCSearchGlassesViewController : IPCPresentModeViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) id<IPCSearchViewDelegate> searchDelegate;
@property (nonatomic, assign) IPCTopFilterType filterType;

- (void)showSearchProductViewWithSearchWord:(NSString *)word;

@end


