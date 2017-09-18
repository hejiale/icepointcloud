//
//  UICollectionView+Alert.h
//  IcePointCloud
//
//  Created by gerry on 2017/3/31.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (Alert)

@property (nonatomic, strong) IPCEmptyAlertView * emptyAlertView;
@property (nonatomic, strong) IPCEmptyAlertView * errorNetworkAlertView;
@property (nonatomic, strong) IPCEmptyAlertView * loadingAlertView;
@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, copy) NSString * emptyAlertTitle;
@property (nonatomic, copy) NSString  * emptyAlertImage;
@property (nonatomic, copy) NSString * noDataTitle;
@property (nonatomic)  BOOL  isHiden;
@property (nonatomic, assign) BOOL     isBeginLoad;

@end
