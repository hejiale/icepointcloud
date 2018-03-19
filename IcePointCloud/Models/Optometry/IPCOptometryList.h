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

- (instancetype)initWithResponseValue:(id)responseValue;

@end

@interface IPCOptometryMode : NSObject

@property (nonatomic, copy, readwrite) NSString * optometryID;
@property (nonatomic, copy, readwrite) NSString * sphLeft;
@property (nonatomic, copy, readwrite) NSString * sphRight;
@property (nonatomic, copy, readwrite) NSString * cylLeft;
@property (nonatomic, copy, readwrite) NSString * cylRight;
@property (nonatomic, copy, readwrite) NSString * axisLeft;
@property (nonatomic, copy, readwrite) NSString * axisRight;
@property (nonatomic, copy, readwrite) NSString * addLeft;
@property (nonatomic, copy, readwrite) NSString * addRight;
@property (nonatomic, copy, readwrite) NSString * distanceLeft;//pd
@property (nonatomic, copy, readwrite) NSString * distanceRight;//pd
@property (nonatomic, copy, readwrite) NSString * correctedVisionLeft;
@property (nonatomic, copy, readwrite) NSString * correctedVisionRight;
@property (nonatomic, copy, readwrite) NSString * basalInLeft;//基底内
@property (nonatomic, copy, readwrite) NSString * basalInRight;//基底内
@property (nonatomic, copy, readwrite) NSString * basalOutLeft;//基底外
@property (nonatomic, copy, readwrite) NSString * basalOutRight;//基底外
@property (nonatomic, copy, readwrite) NSString * basalUpLeft;//基底上
@property (nonatomic, copy, readwrite) NSString * basalUpRight;//基底上
@property (nonatomic, copy, readwrite) NSString * basalDownLeft;//基底下
@property (nonatomic, copy, readwrite) NSString * basalDownRight;//基底下
@property (nonatomic, copy, readwrite) NSString * prismLeft;//棱镜
@property (nonatomic, copy, readwrite) NSString * prismRight;//棱镜
@property (nonatomic, copy, readwrite) NSString * originalMirrorPD;//原镜瞳距
@property (nonatomic, copy, readwrite) NSString * refraction;//The refractive index
@property (nonatomic, copy, readwrite) NSString * insertDate;//insert time
@property (nonatomic, copy, readwrite) NSString * purpose;
@property (nonatomic, copy, readwrite) NSString * employeeId;
@property (nonatomic, copy, readwrite) NSString * employeeName;
@property (nonatomic, copy, readwrite) NSString * optometryEmployee;
@property (nonatomic, copy, readwrite) NSString * optometryInsertDate;
@property (nonatomic, copy, readwrite) NSString * comprehensive;//综合瞳距
@property (nonatomic, copy, readwrite) NSString * remark;


@end
