//
//  IPCBatchDegreeObject.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/6.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCBatchDegreeObject.h"

@implementation IPCBatchDegreeObject

+ (NSArray<NSString *> *)batchReadingDegrees{
    NSMutableArray * degreeArray = [[NSMutableArray alloc]init];
    float startDegree =0;
    
    while (startDegree < 6) {
        startDegree += 0.25;
        if (startDegree != 0) {
            [degreeArray addObject:[NSString stringWithFormat:@"+%.2f",startDegree]];
        }
    }
    return degreeArray;
}

+ (NSArray<NSString *> *)batchSphs{
    NSMutableArray * sphArray = [[NSMutableArray alloc]init];
    float startSph = 15.25;
    
    while (startSph > -15) {
        startSph -= 0.25;
        if (startSph > 0) {
            [sphArray addObject:[NSString stringWithFormat:@"+%.2f",startSph]];
        }else{
            [sphArray addObject:[NSString stringWithFormat:@"%.2f",startSph]];
        }
    }
    return sphArray;
}

+ (NSArray<NSString *> *)batchCyls{
    NSMutableArray * cylArray = [[NSMutableArray alloc]init];
    float startCyl = 6.25;
    
    while (startCyl > -6) {
        startCyl -= 0.25;
        if (startCyl > 0) {
            [cylArray addObject:[NSString stringWithFormat:@"+%.2f",startCyl]];
        }else{
            [cylArray addObject:[NSString stringWithFormat:@"%.2f",startCyl]];
        }
    }
    return cylArray;
}

+ (NSArray<NSString *> *)batchDegrees{
    NSMutableArray * degreeArray = [[NSMutableArray alloc]init];
    float startDegree = 0.25;
    
    while (startDegree > -20) {
        startDegree -= 0.25;
        [degreeArray addObject:[NSString stringWithFormat:@"%.2f",startDegree]];
    }
    return degreeArray;
}

@end
