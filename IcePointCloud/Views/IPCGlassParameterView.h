//
//  GlassParameterView.h
//  IcePointCloud
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCGlassParameterView : UIView

@property (nonatomic, copy) IPCGlasses * glasses;

- (instancetype)initWithFrame:(CGRect)frame Complete:(void(^)())complete;

@end

