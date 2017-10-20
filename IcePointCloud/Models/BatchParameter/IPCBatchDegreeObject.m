//
//  IPCBatchDegreeObject.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/6.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCBatchDegreeObject.h"

@implementation IPCBatchDegreeObject

+ (IPCBatchDegreeObject *)instance
{
    static dispatch_once_t token;
    static IPCBatchDegreeObject *_client;
    dispatch_once(&token, ^{
        _client = [[self alloc] init];
    });
    return _client;
}

- (NSMutableArray<NSString *> *)readingDegrees{
    if (!_readingDegrees) {
        _readingDegrees = [[NSMutableArray alloc]init];
    }
    return _readingDegrees;
}

- (NSMutableArray<NSString *> *)lensSph{
    if (!_lensSph) {
        _lensSph = [[NSMutableArray alloc]init];
    }
    return _lensSph;
}

- (NSMutableArray<NSString *> *)lensCyl
{
    if (!_lensCyl) {
        _lensCyl = [[NSMutableArray alloc]init];
    }
    return _lensCyl;
}

- (void)batchReadingDegrees:(CGFloat)start End:(CGFloat)end Step:(CGFloat)step
{
    [self.readingDegrees removeAllObjects];
    
    float startDegree =start - step;
    
    while (startDegree < end) {
        startDegree += step;
        if (startDegree != 0) {
            [self.readingDegrees addObject:[NSString stringWithFormat:@"+%.2f",startDegree]];
        }
    }
}

- (void)batchContactlensWithStartSph:(CGFloat)startSph EndSph:(CGFloat)endSph StepSph:(CGFloat)stepSph StartCyl:(CGFloat)startCyl EndCyl:(CGFloat)endCyl StepCyl:(CGFloat)stepCyl
{
    [self.lensSph removeAllObjects];
    [self.lensCyl removeAllObjects];
    
    float start = startSph -stepSph;
    
    while (start < endSph) {
        start += stepSph;
        [self.lensSph addObject:[NSString stringWithFormat:@"%.2f",start]];
    }
    
    start = startCyl - stepCyl;
    
    while (start < endCyl) {
        start += stepCyl;
        [self.lensCyl addObject:[NSString stringWithFormat:@"%.2f",start]];
    }
}

//- (NSArray<NSString *> *)batchSphs{
//    NSMutableArray * sphArray = [[NSMutableArray alloc]init];
//    float startSph = 15.25;
//    
//    while (startSph > -15) {
//        startSph -= 0.25;
//        if (startSph > 0) {
//            [sphArray addObject:[NSString stringWithFormat:@"+%.2f",startSph]];
//        }else{
//            [sphArray addObject:[NSString stringWithFormat:@"%.2f",startSph]];
//        }
//    }
//    return sphArray;
//}
//
//- (NSArray<NSString *> *)batchCyls{
//    NSMutableArray * cylArray = [[NSMutableArray alloc]init];
//    float startCyl = 6.25;
//    
//    while (startCyl > -6) {
//        startCyl -= 0.25;
//        if (startCyl > 0) {
//            [cylArray addObject:[NSString stringWithFormat:@"+%.2f",startCyl]];
//        }else{
//            [cylArray addObject:[NSString stringWithFormat:@"%.2f",startCyl]];
//        }
//    }
//    return cylArray;
//}


@end