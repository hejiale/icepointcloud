//
//  CompareItemView.h
//  IcePointCloud
//
//  Created by mac on 8/7/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCTryGlassView.h"

@protocol CompareItemViewDelegate;
@interface IPCCompareItemView : IPCTryGlassView

@property (nonatomic, strong, readwrite) UIView * parentSingleModeView;
@property (nonatomic, assign, readwrite) CGPoint origin;
@property (nonatomic, assign, readwrite) CGPoint originalCenter;
@property (nonatomic, assign, readwrite) CGPoint singleModeViewAnchorPoint;
@property (nonatomic, strong, readwrite) IPCMatchItem *matchItem;
@property (nonatomic, weak) id<CompareItemViewDelegate> delegate;

@end

@protocol CompareItemViewDelegate<NSObject>

@optional
- (void)didAnimateToSingleMode:(IPCCompareItemView *)itemView;
- (void)deleteCompareGlasses:(IPCCompareItemView *)itemView;

@end


