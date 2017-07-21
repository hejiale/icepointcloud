//
//  IPCGlassParameterViewMode.m
//  IcePointCloud
//
//  Created by mac on 2016/11/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCBatchParameterViewMode.h"

@interface IPCBatchParameterViewMode()

@property (nonatomic, strong) IPCGlasses * glasses;

@end

@implementation IPCBatchParameterViewMode

- (instancetype)initWithGlasses:(IPCGlasses *)glasses
{
    self = [super init];
    if (self) {
        self.glasses = glasses;
        if ([self.glasses filterType] == IPCTopFilterTypeContactLenses) {
            [self queryBatchContactDegreeRequest];
        }
    }
    return self;
}

#pragma mark //Network Request
- (void)queryBatchContactDegreeRequest
{
    if (self.glasses.stock <= 0)return;
    
    [IPCBatchRequestManager queryBatchContactProductsStockWithLensID:[self.glasses glassId]
                                                        SuccessBlock:^(id responseValue)
     {
         _batchParameterList = [[IPCBatchParameterList alloc]initWithResponseObject:responseValue];
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}

@end
