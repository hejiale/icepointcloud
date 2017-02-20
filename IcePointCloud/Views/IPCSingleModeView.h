//
//  IPCSingleModeView.h
//  IcePointCloud
//
//  Created by mac on 8/15/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCMatchItem.h"

@interface IPCSingleModeView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, strong) IPCMatchItem *matchItem;

//Update the model picture
- (void)updateModelPhoto;
- (void)updateItem:(BOOL)isDroped;
//Switch glasses
- (void)dropGlasses:(IPCGlasses *)glasses onLocaton:(CGPoint)location;
- (void)initGlassView;
/**
 *  Updated photo like glasses
 */
- (void)updateFaceUI:(CGPoint)point :(CGSize)size;

@end

