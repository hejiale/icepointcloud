//
//  IPCPayOrderMemberCustomerListView.h
//  IcePointCloud
//
//  Created by gerry on 2018/2/28.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayOrderMemberCustomerListView : UIView

- (instancetype)initWithFrame:(CGRect)frame Select:(void(^)(IPCCustomerMode *customer))select;

- (void)reloadCustomerListView:(NSArray<IPCCustomerMode *> *)customerList;

@end
