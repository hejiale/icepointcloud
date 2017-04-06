//
//  IPCBatchDegreeObject.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/6.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCBatchDegreeObject : NSObject

+ (NSArray<NSString *> *)batchReadingDegrees;

+ (NSArray<NSString *> *)batchSphs;

+ (NSArray<NSString *> *)batchCyls;

+ (NSArray<NSString *> *)batchDegrees;

@end
