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
#import "IPCProductViewMode.h"

@interface IPCProductViewController : IPCRootNavigationViewController

@property (strong, nonatomic) IPCGlassParameterView         *parameterView;
@property (strong, nonatomic) IPCEditBatchParameterView   *editParameterView;
@property (nonatomic, strong) IPCRefreshAnimationHeader  *refreshHeader;
@property (nonatomic, strong) IPCRefreshAnimationFooter   *refreshFooter;
@property (strong, nonatomic) IPCProductViewMode    *glassListViewMode;
@property (assign, nonatomic) BOOL    isCancelRequest;

- (void)reload;
- (void)removeCover;
- (void)onFilterProducts;
- (void)onSearchProducts;
- (void)startAnimationWithStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint;
- (void)showGlassesParameterView:(IPCGlasses *)glasses;
- (void)editGlassesParemeterView:(IPCGlasses *)glasses;
- (void)stopRefresh;
- (void)loadNormalProducts:(void(^)())complete;
- (void)loadGlassesListData:(void(^)())complete;

@end
