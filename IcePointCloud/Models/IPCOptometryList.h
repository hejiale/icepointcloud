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

@property (nonatomic, strong, readwrite) NSMutableArray<IPCOptometryMode *> * listArray;
@property (nonatomic, assign, readwrite) NSInteger  totalCount;

- (instancetype)initWithResponseValue:(id)responseValue;

@end

@interface IPCOptometryMode : NSObject

@property (nonatomic, copy, readonly) NSString * optometryID;
@property (nonatomic, copy, readonly) NSString * cylRight;
@property (nonatomic, copy, readonly) NSString * axisRight;
@property (nonatomic, copy, readonly) NSString * addRight;
@property (nonatomic, copy, readonly) NSString * distance;//pd
@property (nonatomic, copy, readonly) NSString * cylLeft;
@property (nonatomic, copy, readonly) NSString * axisLeft;
@property (nonatomic, copy, readonly) NSString * addLeft;
@property (nonatomic, copy, readonly) NSString * correctedVisionRight;
@property (nonatomic, copy, readonly) NSString * refraction;//The refractive index
@property (nonatomic, copy, readonly) NSString * correctedVisionLeft;
@property (nonatomic, copy, readonly) NSString * sphLeft;
@property (nonatomic, copy, readonly) NSString * sphRight;
@property (nonatomic, copy, readonly) NSString * insertDate;//insert time


@end
