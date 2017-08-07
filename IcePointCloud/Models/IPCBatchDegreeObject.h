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
@property (nonatomic, strong) NSMutableArray<NSString *> * contactLensDegrees;

- (void)batchReadingDegrees:(CGFloat)start End:(CGFloat)end Step:(CGFloat)step;
- (void)batchContactlensDegrees:(CGFloat)start End:(CGFloat)end Step:(CGFloat)step;

- (NSArray<NSString *> *)batchSphs;
- (NSArray<NSString *> *)batchCyls;

@end
