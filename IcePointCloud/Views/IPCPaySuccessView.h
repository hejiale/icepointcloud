//
//  IPCPaySuccessView.h
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCOrder.h"

@interface IPCPaySuccessView : UIView

- (instancetype)initWithFrame:(CGRect)frame OrderInfo:(IPCOrder *)orderInfo Dismiss:(void(^)())dismiss;

@end
