//
//  IPCPayOrderMemberChooseCustomerView.h
//  IcePointCloud
//
//  Created by gerry on 2018/2/28.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayOrderMemberChooseCustomerView : UIView

- (instancetype)initWithFrame:(CGRect)frame BindSuccess:(void(^)(IPCCustomerMode *customer))success;

@end