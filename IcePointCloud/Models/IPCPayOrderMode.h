//
//  IPCPayOrderMode.h
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCEmploye.h"

@interface IPCPayOrderMode : NSObject

+ (IPCPayOrderMode *)sharedManager;

@property (nonatomic,assign, readwrite) BOOL  isOrder;
@property (nonatomic,assign, readwrite) BOOL  isSelectEmploye;
@property (nonatomic, copy, readwrite) NSString *   payStyleName;
@property (nonatomic, copy, readwrite) NSString  *  orderMemo;

@property (nonatomic, assign, readwrite) double  prepaidAmount;//全款类商品定金
@property (nonatomic, assign, readwrite) double  preSellPrepaidAmount;//预售类商品定金

@property (nonatomic, assign, readwrite) double  employeAmount;//全款类商品员工价
@property (nonatomic, assign, readwrite) double  preEmployeAmount;//预售类商品员工价
@property (nonatomic, strong, readwrite) IPCEmploye * currentEmploye;

@property (nonatomic,assign, readwrite) IPCPayStyleType             payStyle;
@property (nonatomic,assign, readwrite) IPCOrderPayType            payType;
//@property (nonatomic,assign) IPCOrderPreSellPayType  prePayType;

- (void)clearData;

@end
