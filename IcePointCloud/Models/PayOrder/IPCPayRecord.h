//
//  IPCPayRecord.h
//  IcePointCloud
//
//  Created by gerry on 2017/6/5.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCPayRecord : NSObject

@property (nonatomic, copy) NSString * payTypeInfo;
@property (nonatomic, assign) double   payPrice;
@property (nonatomic, copy) NSDate * payDate;
@property (nonatomic, assign) NSInteger  integral;
@property (nonatomic, assign) double   pointPrice;
@property (nonatomic, assign) BOOL   isEditStatus;

@end
