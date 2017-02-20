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

@property (nonatomic) BOOL  isOrder;
@property (nonatomic, copy) NSString  *  orderMemo;
@property (nonatomic) double  prepaidAmount;
@property (nonatomic) IPCOrderPayType  payType;
@property (nonatomic) double  employeAmount;
@property (nonatomic) double  discountAmount;
@property (nonatomic, strong) IPCEmploye * currentEmploye;
@property (nonatomic,assign) BOOL  isSelectEmploye;
@property (nonatomic) IPCPayStyleType payStyle;
@property (nonatomic, copy) NSString * payStyleName;

- (void)clearData;

@end
