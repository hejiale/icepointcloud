//
//  ContactLensMode.m
//  IcePointCloud
//
//  Created by mac on 16/9/29.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCContactLensMode.h"

@implementation IPCContactLensMode

- (instancetype)initWithResponseObject:(NSArray<IPCContactLenSpec *> *)specificationArray{
    self = [super init];
    if (self) {
        [specificationArray enumerateObjectsUsingBlock:^(IPCContactLenSpec * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.bizStock > 0) {
                if ([self.batchArray count]) {
                    [self.batchArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([dic[@"batchNum"] isEqualToString:obj.batchNumber])
                            [self.batchArray removeObject:dic];
                        
                        NSMutableDictionary * batchDic = [[NSMutableDictionary alloc]init];
                        [batchDic setObject:obj.batchNumber forKey:@"batchNum"];
                        [self.batchArray addObject:batchDic];
                    }];
                }else{
                    NSMutableDictionary * batchDic = [[NSMutableDictionary alloc]init];
                    [batchDic setObject:obj.batchNumber forKey:@"batchNum"];
                    [self.batchArray addObject:batchDic];
                }
            }
        }];
    }
    
    
    [specificationArray enumerateObjectsUsingBlock:^(IPCContactLenSpec * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.batchArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull batchDic, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.batchNumber isEqualToString:batchDic[@"batchNum"]]) {
                if (obj.bizStock > 0) {
                    if ([batchDic[@"kindList"] count]) {
                        NSMutableArray * kindArray = batchDic[@"kindList"];
                        [kindArray enumerateObjectsUsingBlock:^(NSMutableDictionary *  _Nonnull kindDic, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([kindDic[@"kind"] isEqualToString:obj.approvalNumber])
                                [kindArray removeObject:kindDic];
                            
                            NSMutableDictionary * Dic = [[NSMutableDictionary alloc]init];
                            [Dic setObject:obj.approvalNumber forKey:@"kind"];
                            [kindArray addObject:Dic];
                        }];
                    }else{
                        NSMutableArray * kindArray = [[NSMutableArray alloc]init];
                        NSMutableDictionary * kindDic = [[NSMutableDictionary alloc]init];
                        [kindDic setObject:obj.approvalNumber forKey:@"kind"];
                        [kindArray addObject:kindDic];
                        [batchDic setValue:kindArray forKey:@"kindList"];
                    }
                }
            }
        }];
    }];
    
    [specificationArray enumerateObjectsUsingBlock:^(IPCContactLenSpec * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.batchArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.batchNumber isEqualToString:dic[@"batchNum"]]) {
                [dic[@"kindList"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull kindDic, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([kindDic[@"kind"] isEqualToString:obj.approvalNumber]) {
                        NSMutableArray * dateArray = [[NSMutableArray alloc]init];
                        if (obj.bizStock > 0) {
                            if ([kindDic[@"dateList"] count]) {
                                NSMutableArray * dateList = kindDic[@"dateList"];
                                [dateList enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dateDic, NSUInteger idx, BOOL * _Nonnull stop) {
                                    if ([dateDic[@"expireDate"] isEqualToString:obj.expireDate])
                                        [dateList removeObject:dateDic];
                                    
                                    NSMutableDictionary * Dic = [[NSMutableDictionary alloc]init];
                                    [Dic setValue:obj.expireDate forKey:@"expireDate"];
                                    [Dic setValue:@(obj.bizStock) forKey:@"bizStock"];
                                    [dateList addObject:Dic];
                                }];
                            }else{
                                NSMutableDictionary * dateDic = [[NSMutableDictionary alloc]init];
                                [dateDic setObject:obj.expireDate forKey:@"expireDate"];
                                [dateDic setObject:@(obj.bizStock) forKey:@"bizStock"];
                                [dateArray addObject:dateDic];
                                [kindDic setValue:dateArray forKey:@"dateList"];
                            }
                        }
                    }
                }];
            }
        }];
    }];
    
    return self;
}



- (NSMutableArray<NSDictionary *> *)batchArray{
    if (!_batchArray)
        _batchArray = [[NSMutableArray alloc]init];
    return _batchArray;
}

@end

