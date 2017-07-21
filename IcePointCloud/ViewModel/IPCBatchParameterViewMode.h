//
//  IPCGlassParameterViewMode.h
//  IcePointCloud
//
//  Created by mac on 2016/11/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCBatchParameterViewMode : NSObject

@property (nonatomic, strong) IPCBatchParameterList * batchParameterList;

- (instancetype)initWithGlasses:(IPCGlasses *)glasses;

@end
