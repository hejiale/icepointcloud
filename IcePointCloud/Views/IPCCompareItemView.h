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

@property (nonatomic, strong, readwrite) UIView * parentSingleModeView;
@property (nonatomic, assign, readwrite) CGPoint origin;
@property (nonatomic, assign, readwrite) CGPoint originalCenter;
@property (nonatomic, assign, readwrite) CGPoint singleModeViewAnchorPoint;
@property (nonatomic, strong, readwrite) IPCMatchItem *matchItem;

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


