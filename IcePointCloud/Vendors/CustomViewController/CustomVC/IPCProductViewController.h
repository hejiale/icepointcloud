//
//  IPCProductViewController.h
//  IcePointCloud
//
//  Created by gerry on 2017/7/11.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCRootNavigationViewController.h"
#import "IPCGlassParameterView.h"
#import "IPCEditBatchParameterView.h"

@interface IPCProductViewController : IPCRootNavigationViewController

@property (strong, nonatomic) IPCGlassParameterView         *parameterView;
@property (strong, nonatomic) IPCEditBatchParameterView   *editParameterView;
@property (nonatomic, strong) IPCRefreshAnimationHeader  *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter   *refreshFooter;

- (void)reload;
- (void)removeCover;
- (void)onFilterProducts;
- (void)onSearchProducts;
- (void)startAnimationWithStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint;
- (void)showGlassesParameterView:(IPCGlasses *)glasses;
- (void)editGlassesParemeterView:(IPCGlasses *)glasses;
- (void)stopRefresh;

@end
