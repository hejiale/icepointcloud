//
//  IPCUpdateCustomerView.h
//  IcePointCloud
//
//  Created by gerry on 2018/1/5.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCUpdateCustomerView : UIView

- (instancetype)initWithFrame:(CGRect)frame DetailCustomer:(IPCDetailCustomer *)customer UpdateBlock:(void (^)(NSString *customerId))update;

@end