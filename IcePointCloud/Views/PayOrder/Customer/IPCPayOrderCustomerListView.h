//
//  IPCPayOrderCustomerListView.h
//  IcePointCloud
//
//  Created by gerry on 2018/2/27.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayOrderCustomerListView : UIView

- (instancetype)initWithFrame:(CGRect)frame
               IsChooseStatus:(BOOL)isChoose
                       Detail:(void(^)(IPCCustomerMode * customer, BOOL isMemberReload))detail
                   SelectType:(void(^)(BOOL isSelectMemeber))isMember;

- (void)reload;

- (void)loadData;

- (void)changeToMemberStatus;

@end
