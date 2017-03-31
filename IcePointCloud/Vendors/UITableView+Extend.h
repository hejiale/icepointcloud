//
//  UITableView+Extend.h
//  IcePointCloud
//
//  Created by mac on 2016/12/13.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Extend)

@property (nonatomic, strong) IPCEmptyAlertView * emptyAlertView;
@property (nonatomic, strong) IPCEmptyAlertView * errorNetworkAlertView;
@property (nonatomic, copy) NSString * emptyAlertTitle;
@property (nonatomic, copy) NSString  * emptyAlertImage;
@property (nonatomic)  BOOL  isHiden;

@end
