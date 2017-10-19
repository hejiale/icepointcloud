//
//  EditBatchParameterView.h
//  IcePointCloud
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCEditBatchParameterView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                      Glasses:(IPCGlasses *)glasses
                      Dismiss:(void(^)())dismiss;
- (void)show;

@end
