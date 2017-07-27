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
    }
    return self;
}

#pragma mark //Network Request
- (void)queryBatchDegree:(NSString *)type Complete:(void(^)(CGFloat start, CGFloat end, CGFloat step))complete
{
    [IPCBatchRequestManager queryBatchContactLensConfig:type
                                           SuccessBlock:^(id responseValue)
    {
        id values = responseValue[@"values"];
        
        if ([values isKindOfClass:[NSDictionary class]]) {
            if (complete) {
                complete([values[@"startDegree"] floatValue],[values[@"endDegree"] floatValue],[values[@"step"] floatValue]);
            }
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}


@end
