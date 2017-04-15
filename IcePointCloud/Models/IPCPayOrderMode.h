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

@interface IPCPayOrderMode : NSObject

+ (IPCPayOrderMode *)sharedManager;

@property (nonatomic,assign, readwrite) IPCPayStyleType      payStyle;//支付方式
@property (nonatomic,assign, readwrite) IPCOrderPayType     payType;//全额  定金支付
@property (nonatomic, copy, readwrite) NSString     *   payStyleName;

@property (nonatomic, assign, readwrite) double   orderTotalPrice;//订单总金额(可根据输入金额改变)
@property (nonatomic, assign, readwrite) double   realTotalPrice;//实付金额
@property (nonatomic, assign, readwrite) double   pointPrice;//积分金额
@property (nonatomic, assign, readwrite) double   point;//积分
@property (nonatomic, assign, readwrite) double   presellAmount;//定金

@property (nonatomic, strong, readwrite) NSMutableArray<IPCEmployeeResult *> * employeeResultArray;//保存员工业绩

- (double)judgeEmployeeResult:(double)result Employee:(IPCEmployeeResult *)employeeResult;

- (void)clearData;

@end
