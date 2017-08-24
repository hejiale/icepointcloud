//
//  IPCTryGlassesView.h
//  IcePointCloud
//
//  Created by gerry on 2017/8/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCTryGlassesView : UIView

- (instancetype)initWithFrame:(CGRect)frame
              ChooseParameter:(void(^)())choose
                EditParameter:(void(^)())edit
                      AddCart:(void(^)())addCart
                   ReduceCart:(void(^)())reduceCart
                   TryGlasses:(void(^)())tryGlasses;

@property (nonatomic, copy) IPCGlasses *glasses;

@end
