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
#import "IPCPointValueMode.h"
#import "IPCPayRecord.h"

@interface IPCPayOrderMode : NSObject

+ (IPCPayOrderMode *)sharedManager;

@property (nonatomic, assign, readwrite) BOOL    isTrade;//是否使用积分抵扣
@property (nonatomic, assign, readwrite) BOOL    isPayOrderStatus;// 设置订单付款状态

@property (nonatomic,assign, readwrite) IPCPayStyleType      payStyle;//支付方式 \ 支付宝  微信  现金  刷卡
@property (nonatomic, copy, readwrite) NSString     *   payStyleName;//支付名称

@property (nonatomic, assign, readwrite) double   orderTotalPrice;//订单总金额(可根据输入金额改变)
@property (nonatomic, assign, readwrite) double   realTotalPrice;//实付金额
@property (nonatomic, assign, readwrite) double   pointPrice;//积分金额
@property (nonatomic, assign, readwrite) NSInteger    usedPoint;//已使用积分
@property (nonatomic, assign, readwrite) NSInteger    point;//总积分
@property (nonatomic, assign, readwrite) double   givingAmount;//赠送金额

@property (nonatomic, assign, readwrite) double   payTypeAmount;//支付宝  微信  现金  刷卡 \支付金额
@property (nonatomic, assign, readwrite) double   balanceAmount;//储值金额
@property (nonatomic, assign, readwrite) double   usedBalanceAmount;//已使用储值金额

@property (nonatomic, assign, readwrite) BOOL     isSelectPoint;// 是否选择积分
@property (nonatomic, assign, readwrite) BOOL     isSelectStoreValue;// 是否选择储值
@property (nonatomic, assign, readwrite) BOOL     isSelectPayType;// 是否选择支付方式

@property (nonatomic, assign, readwrite) BOOL     isChooseCustomer;//选择客户
@property (nonatomic, assign, readwrite) double  customerDiscount;//客户折扣

@property (nonatomic, strong) IPCPayRecord * insertPayRecord;//正在输入中的付款方式记录
@property (nonatomic, assign) BOOL      isInsertRecordStatus;//是否正在输入付款记录的状态

@property (nonatomic, copy, readwrite) NSString * remark;//订单备注

@property (nonatomic, strong, readwrite) NSMutableArray<IPCOtherPayTypeResult *> * otherPayTypeArray;//其它支付方式
@property (nonatomic, strong, readwrite) NSMutableArray<IPCPayRecord *> * payTypeRecordArray;//付款记录方式
@property (nonatomic, strong, readwrite) NSMutableArray<IPCEmployeeResult *> * employeeResultArray;//保存员工业绩

- (double)judgeEmployeeResult:(double)result Employee:(IPCEmployeeResult *)employeeResult;

- (double)totalEmployeeResult;

- (double)totalOtherPayTypeAmount;

- (double)minimumEmployeeDiscountPrice:(double)originPrice;

- (void)resetData;

- (void)clearPayTypeData;

- (void)reloadWithOtherTypeAmount;

- (void)calculatePointValue:(IPCPointValueMode *)pointValue;

- (double)minumEmployeeResult;

- (BOOL)isExistEmptyEmployeeResult;

- (BOOL)isExistZeroOtherTypeAmount;

- (BOOL)isExistEmptyOtherTypeName;

@end
