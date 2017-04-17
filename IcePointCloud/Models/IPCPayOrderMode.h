//
//  IPCPayOrderMode.h
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCEmploye.h"
#import "IPCEmployeeResult.h"
#import "IPCOtherPayTypeResult.h"

@interface IPCPayOrderMode : NSObject

+ (IPCPayOrderMode *)sharedManager;

@property (nonatomic, assign, readwrite) BOOL    isPayOrderStatus;// 设置订单付款状态

@property (nonatomic,assign, readwrite) IPCPayStyleType      payStyle;//支付方式 \ 支付宝  微信  现金  刷卡
@property (nonatomic,assign, readwrite) IPCOrderPayType     payType;//全额  定金支付
@property (nonatomic, copy, readwrite) NSString     *   payStyleName;//支付名称

@property (nonatomic, assign, readwrite) double   orderTotalPrice;//订单总金额(可根据输入金额改变)
@property (nonatomic, assign, readwrite) double   realTotalPrice;//实付金额
@property (nonatomic, assign, readwrite) double   pointPrice;//积分金额
@property (nonatomic, assign, readwrite) double   usedPoint;//已使用积分
@property (nonatomic, assign, readwrite) double   point;//总积分
@property (nonatomic, assign, readwrite) double   presellAmount;//定金
@property (nonatomic, assign, readwrite) double   givingAmount;//赠送金额

@property (nonatomic, assign, readwrite) double   payTypeAmount;//支付宝  微信  现金  刷卡 \支付金额
@property (nonatomic, assign, readwrite) double   balanceAmount;//储值金额
@property (nonatomic, assign, readwrite) double   usedBalanceAmount;//已使用储值金额

@property (nonatomic, assign, readwrite) BOOL     isSelectPoint;// 是否选择积分
@property (nonatomic, assign, readwrite) BOOL     isSelectStoreValue;// 是否选择储值
@property (nonatomic, assign, readwrite) BOOL     isSelectPayType;// 是否选择支付方式


@property (nonatomic, strong, readwrite) NSMutableArray<IPCOtherPayTypeResult *> * otherPayTypeArray;//其它支付方式
@property (nonatomic, strong, readwrite) NSMutableArray<IPCEmployeeResult *> * employeeResultArray;//保存员工业绩

- (double)judgeEmployeeResult:(double)result Employee:(IPCEmployeeResult *)employeeResult;

- (double)totalEmployeeResult;

- (double)totalOtherPayTypeAmount;

- (double)minimumEmployeeDiscountPrice:(double)originPrice;

- (void)resetData;

- (void)clearPayTypeData;

- (void)reloadWithOtherTypeAmount;

- (double)waitPayAmount;

- (double)minumEmployeeResult;

- (BOOL)isExistEmptyEmployeeResult;

@end
