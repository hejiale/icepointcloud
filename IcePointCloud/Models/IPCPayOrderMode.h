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

@property (nonatomic,assign) BOOL  isOrder;
@property (nonatomic,assign) BOOL  isSelectEmploye;
@property (nonatomic, copy) NSString *   payStyleName;
@property (nonatomic, copy) NSString  *  orderMemo;

@property (nonatomic) double  prepaidAmount;//全款类商品定金
@property (nonatomic) double  preSellPrepaidAmount;//预售类商品定金

@property (nonatomic) double  employeAmount;//全款类商品员工价
@property (nonatomic) double  preEmployeAmount;//预售类商品员工价
@property (nonatomic, strong) IPCEmploye * currentEmploye;

@property (nonatomic,assign) IPCPayStyleType             payStyle;
@property (nonatomic,assign) IPCOrderPayType            payType;
//@property (nonatomic,assign) IPCOrderPreSellPayType  prePayType;

- (void)clearData;

@end
