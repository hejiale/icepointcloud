//
//  IPCCustomsizedItem.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCCustomsizedOther;
@interface IPCCustomsizedEye : NSObject

@property (nonatomic, copy, readwrite) NSString * sph;
@property (nonatomic, copy, readwrite) NSString * cyl;
@property (nonatomic, copy, readwrite) NSString * axis;
@property (nonatomic, copy, readwrite) NSString * distance;
@property (nonatomic, copy, readwrite) NSString * add;
@property (nonatomic, copy, readwrite) NSString * membrane;//加膜
@property (nonatomic, copy, readwrite) NSString * channel;//通道长度
@property (nonatomic, copy, readwrite) NSString * dyeing;//染色
@property (nonatomic, strong, readwrite) NSMutableArray<IPCCustomsizedOther *> * otherArray;
@property (nonatomic, assign, readwrite) double    customsizedPrice;//定制价格
@property (nonatomic, assign, readwrite) NSInteger  customsizedCount;//定制数量

@end

@interface IPCCustomsizedOther : NSObject//自定义参数

@property (nonatomic, copy, readwrite) NSString * otherParameter;//自定义参数
@property (nonatomic, copy, readwrite) NSString * otherParameterRemark;//参数说明


@end
