//
//  UITableView+Alert.h
//  IcePointCloud
//
//  Created by gerry on 2017/3/31.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Alert)

@property (nonatomic, strong) IPCEmptyAlertView * emptyAlertView;
@property (nonatomic, strong) IPCEmptyAlertView * errorNetworkAlertView;
@property (nonatomic, copy) NSString * operationTitle;
@property (nonatomic, copy) NSString * emptyAlertTitle;
@property (nonatomic, copy) NSString  * emptyAlertImage;
@property (nonatomic)  BOOL  isHiden;

@end
