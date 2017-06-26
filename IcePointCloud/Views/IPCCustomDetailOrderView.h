//
//  IPCCustomDetailOrderView.h
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCCustomDetailOrderView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                     OrderNum:(NSString *)orderNum
                ProductDetail:(void(^)(IPCGlasses *glass))product
                          Pay:(void(^)())pay
                      Dismiss:(void(^)())dismiss;

- (void)show;

@end
