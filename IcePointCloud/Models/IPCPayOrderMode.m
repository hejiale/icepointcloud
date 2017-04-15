//
//  IPCPayOrderMode.m
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPayOrderMode.h"

@implementation IPCPayOrderMode

+ (IPCPayOrderMode *)sharedManager
{
    static dispatch_once_t token;
    static IPCPayOrderMode *_client;
    dispatch_once(&token, ^{
        _client = [[self alloc] init];
    });
    return _client;
}


- (void)clearData{
    [IPCPayOrderMode sharedManager].payStyle = IPCPayStyleTypeNone;
    [[IPCPayOrderMode sharedManager].employeeResultArray removeAllObjects];
}

- (double)judgeEmployeeResult:(double)result Employee:(IPCEmployeeResult *)employeeResult
{
    __block double  remainResult = 0;
    __block double  otherTotalResult = 0;//计算除当前员工下的总份额
    
    [[IPCPayOrderMode sharedManager].employeeResultArray enumerateObjectsUsingBlock:^(IPCEmployeeResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( ! [obj.employe.jobID isEqualToString:employeeResult.employe.jobID]) {
            otherTotalResult += obj.employeeResult;
        }
    }];
    
    remainResult = 100 - otherTotalResult;// 剩余份额
    
    if (remainResult < result && remainResult > 0) {
        [IPCCustomUI showError:[NSString stringWithFormat:@"该员工至多百分之%.f份额",remainResult]];
    }else{
        remainResult = result;
    }
    
    return remainResult;
}

- (NSMutableArray<IPCEmployeeResult *> *)employeeResultArray{
    if (!_employeeResultArray) {
        _employeeResultArray= [[NSMutableArray alloc]init];
    }
    return _employeeResultArray;
}


@end
