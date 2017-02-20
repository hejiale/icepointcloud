//
//  CompareItemView.h
//  IcePointCloud
//
//  Created by mac on 8/7/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCMatchItem.h"
#import "IPCGlasses.h"

@protocol CompareItemViewDelegate;
@interface IPCCompareItemView : UIView

@property (nonatomic, strong) UIView * parentSingleModeView;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign) CGPoint singleModeViewAnchorPoint;
@property (nonatomic, strong) IPCMatchItem *matchItem;

@property (nonatomic, weak) id<CompareItemViewDelegate> delegate;

//Update the model picture
- (void)updateItem:(BOOL)isDroped;
- (void)updateModelPhoto;
- (void)amplificationLargeModelView;
- (void)dropGlasses:(IPCGlasses *)glasses onLocaton:(CGPoint)location;
- (void)initGlassView;
/**
 *  Updated photo like glasses
 */
- (void)updateFaceUI:(CGPoint)point :(CGSize)size;

@end

@protocol CompareItemViewDelegate<NSObject>

- (void)didAnimateToSingleMode:(IPCCompareItemView *)itemView withIndex:(NSInteger)index;
- (void)deleteCompareGlasses:(IPCCompareItemView *)itemView;

@end


