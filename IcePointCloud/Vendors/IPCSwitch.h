//
//  NKColorSwitch.h
//  IcePointCloud
//
//  Created by mac on 16/5/5.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    IPCColorSwitchShapeOval,
    IPCColorSwitchShapeRectangle,
    IPCColorSwitchShapeRectangleNoCorner
} IPCColorSwitchShape;

@interface IPCSwitch : UIControl <UIGestureRecognizerDelegate>


@property (nonatomic, getter = isOn) BOOL on;

@property (nonatomic, assign) IPCColorSwitchShape shape;


@property (nonatomic, strong) UIColor *onTintColor;


@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, strong) UIColor *thumbTintColor;

@property (nonatomic, assign) BOOL shadow;

@property (nonatomic, strong) UIColor *tintBorderColor;
@property (nonatomic, strong) UIColor *onTintBorderColor;


@property (nonatomic, strong) UILabel *onBackLabel;//open label
@property (nonatomic, strong) UILabel *offBackLabel;//close label

@end
