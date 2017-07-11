//
//  IPCSingleModeView.h
//  IcePointCloud
//
//  Created by mac on 8/15/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCTryGlassView.h"

@interface IPCSingleModeView : IPCTryGlassView<UIGestureRecognizerDelegate>

@property (nonatomic, strong, readwrite) IPCMatchItem *matchItem;

@end

