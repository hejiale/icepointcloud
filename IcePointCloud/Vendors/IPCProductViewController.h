//
//  IPCProductViewController.h
//  IcePointCloud
//
//  Created by gerry on 2017/7/11.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCRootNavigationViewController.h"

@interface IPCProductViewController : IPCRootNavigationViewController

- (void)reload;
- (void)removeCover;
- (void)onFilterProducts;
- (void)onSearchProducts;
-(void)startAnimationWithStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint;

@end
