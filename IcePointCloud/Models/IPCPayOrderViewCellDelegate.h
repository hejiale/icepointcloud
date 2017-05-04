//
//  IPCPayOrderViewCellDelegate.h
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCOrder.h"

@protocol IPCPayOrderViewCellDelegate <NSObject>

- (void)showEmployeeView;
- (void)reloadPayOrderView;
- (void)searchCustomerMethod;
- (void)showPaySuccessViewWithOrderInfo:(IPCOrder *)orderResult;
- (void)selectNormalGlasses;

@end
