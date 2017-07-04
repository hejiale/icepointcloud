//
//  IPCPayOrderViewCellDelegate.h
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IPCPayOrderViewModelDelegate <NSObject>

- (void)showEmployeeView;
- (void)reloadPayOrderView;
- (void)selectNormalGlasses;
- (void)successPayOrder;
- (void)failPayOrder;
@end
