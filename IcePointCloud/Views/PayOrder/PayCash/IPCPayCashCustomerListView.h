//
//  IPCPayCashCustomerListView.h
//  IcePointCloud
//
//  Created by gerry on 2018/1/31.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayCashCustomerListView : UIView

- (instancetype)initWithFrame:(CGRect)frame Complete:(void(^)(IPCCustomerMode * customer))complete;

@end
