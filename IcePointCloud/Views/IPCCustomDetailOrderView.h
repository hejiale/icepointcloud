//
//  IPCCustomDetailOrderView.h
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCCustomDetailOrderView : UIView

- (instancetype)initWithFrame:(CGRect)frame OrderNum:(NSString *)orderNum IsForSale:(BOOL)isForSale ProductDetail:(void(^)(IPCGlasses *glass))product Dismiss:(void(^)())dismiss;

@end
