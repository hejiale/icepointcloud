//
//  IPCGlassParameterViewMode.h
//  IcePointCloud
//
//  Created by mac on 2016/11/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCBatchParameterViewMode : NSObject

- (instancetype)initWithGlasses:(IPCGlasses *)glasses;

- (void)queryBatchDegree:(NSString *)type Complete:(void(^)(CGFloat start, CGFloat end, CGFloat step))complete;

@end
