//
//  IPCPayOrderManager.h
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCEmployeeResult.h"
#import "IPCPointValueMode.h"
#import "IPCPayRecord.h"

@interface IPCPayOrderManager : NSObject

+ (IPCPayOrderManager *)sharedManager;

@property (nonatomic, copy, readwrite) NSString * currentCustomerId;//当前客户Id

@property (nonatomic, assign, readwrite) BOOL    isTrade;//是否使用积分抵扣
@property (nonatomic, assign, readwrite) BOOL    isPayOrderStatus;// 设置订单付款状态

@property (nonatomic, assign, readwrite) double        pointPrice;//积分金额
@property (nonatomic, assign, readwrite) NSInteger    usedPoint;//已使用积分
@property (nonatomic, assign, readwrite) NSInteger    point;//总积分
@property (nonatomic, assign, readwrite) double        givingAmount;//赠送金额

@property (nonatomic, assign, readwrite) double   balanceAmount;//储值金额
@property (nonatomic, assign, readwrite) double   usedBalanceAmount;//已使用储值金额

@property (nonatomic, assign, readwrite) BOOL     isSelectPoint;// 是否选择积分
@property (nonatomic, assign, readwrite) BOOL     isChooseCustomer;//是否已选择客户
@property (nonatomic, assign, readwrite) double  customerDiscount;//客户折扣

@property (nonatomic, strong) IPCPayRecord * insertPayRecord;//正在输入中的付款方式记录
@property (nonatomic, assign) BOOL      isInsertRecordStatus;//是否正在输入付款记录的状态

@property (nonatomic, copy, readwrite) NSString * remark;//订单备注

@property (nonatomic, strong, readwrite) NSMutableArray<IPCPayRecord *> * payTypeRecordArray;//付款记录方式
@property (nonatomic, strong, readwrite) NSMutableArray<IPCEmployeeResult *> * employeeResultArray;//保存员工业绩

- (double)judgeEmployeeResult:(double)result Employee:(IPCEmployeeResult *)employeeResult;

- (double)totalEmployeeResult;

- (double)minimumEmployeeDiscountPrice:(double)originPrice;

//实付金额
- (double)realTotalPrice;
//剩余付款金额
- (double)remainPayPrice;
//已付款金额总计
- (double)payRecordTotalPrice;

- (void)calculatePointValue:(IPCPointValueMode *)pointValue;

- (double)minumEmployeeResult;

- (BOOL)isExistEmptyEmployeeResult;
//清空支付信息  选择客户信息  清空商品列表
- (void)resetData;


@end
