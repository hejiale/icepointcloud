//
//  IPCBatchDegreeObject.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/6.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCBatchDegreeObject : NSObject

+ (IPCBatchDegreeObject *)instance;

@property (nonatomic, strong) NSMutableArray<NSString *> * readingDegrees;
@property (nonatomic, strong) NSMutableArray<NSString *> * lensSph;
@property (nonatomic, strong) NSMutableArray<NSString *> * lensCyl;

- (void)batchReadingDegrees:(CGFloat)start End:(CGFloat)end Step:(CGFloat)step;

- (void)batchContactlensWithStartSph:(CGFloat)startSph EndSph:(CGFloat)endSph StepSph:(CGFloat)stepSph StartCyl:(CGFloat)startCyl EndCyl:(CGFloat)endCyl StepCyl:(CGFloat)stepCyl;

@end

