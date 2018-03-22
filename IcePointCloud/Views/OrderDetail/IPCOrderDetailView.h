//
//  IPCOrderDetailView.h
//  IcePointCloud
//
//  Created by gerry on 2018/3/21.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCOrderDetailView : UIView

- (instancetype)initWithOrderDetail:(void(^)(IPCCustomerOrderDetail * orderDetail))detail;

@property (nonatomic, copy) NSString * orderNum;

@end


