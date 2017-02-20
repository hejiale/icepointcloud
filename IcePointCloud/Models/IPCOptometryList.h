//
//  OptometryListObject.h
//  IcePointCloud
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCOptometryMode;
@interface IPCOptometryList : NSObject

@property (nonatomic, strong) NSMutableArray<IPCOptometryMode *> * listArray;
@property (nonatomic, assign) NSInteger  totalCount;

- (instancetype)initWithResponseValue:(id)responseValue;

@end

@interface IPCOptometryMode : NSObject

@property (nonatomic, copy) NSString * optometryID;
@property (nonatomic, copy) NSString * cylRight;
@property (nonatomic, copy) NSString * axisRight;
@property (nonatomic, copy) NSString * addRight;
@property (nonatomic, copy) NSString * distance;//pd
@property (nonatomic, copy) NSString * cylLeft;
@property (nonatomic, copy) NSString * axisLeft;
@property (nonatomic, copy) NSString * addLeft;
@property (nonatomic, copy) NSString * correctedVisionRight;
@property (nonatomic, copy) NSString * refraction;//The refractive index
@property (nonatomic, copy) NSString * correctedVisionLeft;
@property (nonatomic, copy) NSString * sphLeft;
@property (nonatomic, copy) NSString * sphRight;
@property (nonatomic, copy) NSString * insertDate;//insert time


@end
