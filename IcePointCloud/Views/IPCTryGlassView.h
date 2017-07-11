//
//  IPCTryGlassView.h
//  IcePointCloud
//
//  Created by gerry on 2017/7/11.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCMatchItem.h"
#import "IPCGlasses.h"

@interface IPCTryGlassView : UIView

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

- (void)amplificationLargeModelView;

@end
