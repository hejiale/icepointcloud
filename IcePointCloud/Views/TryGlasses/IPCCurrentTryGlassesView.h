//
//  IPCTryGlassesView.h
//  IcePointCloud
//
//  Created by gerry on 2017/8/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCCurrentTryGlassesView : UIView

- (instancetype)initWithFrame:(CGRect)frame
              ChooseParameter:(void(^)())choose
                EditParameter:(void(^)())edit
                   Reload:(void(^)())reload;

@property (nonatomic, copy) IPCGlasses *glasses;

- (void)reload;
- (void)setDefaultGlasses;

@end
