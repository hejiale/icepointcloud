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

@property (nonatomic, copy, readwrite) NSString * optometryID;
@property (nonatomic, copy, readwrite) NSString * cylRight;
@property (nonatomic, copy, readwrite) NSString * axisRight;
@property (nonatomic, copy, readwrite) NSString * addRight;
@property (nonatomic, copy, readwrite) NSString * distanceLeft;//pd
@property (nonatomic, copy, readwrite) NSString * distanceRight;//pd
@property (nonatomic, copy, readwrite) NSString * cylLeft;
@property (nonatomic, copy, readwrite) NSString * axisLeft;
@property (nonatomic, copy, readwrite) NSString * addLeft;
@property (nonatomic, copy, readwrite) NSString * correctedVisionRight;
@property (nonatomic, copy, readwrite) NSString * refraction;//The refractive index
@property (nonatomic, copy, readwrite) NSString * correctedVisionLeft;
@property (nonatomic, copy, readwrite) NSString * sphLeft;
@property (nonatomic, copy, readwrite) NSString * sphRight;
@property (nonatomic, copy, readwrite) NSString * insertDate;//insert time
@property (nonatomic, copy, readwrite) NSString * purpose;
@property (nonatomic, copy, readwrite) NSString * employeeId;
@property (nonatomic, copy, readwrite) NSString * employeeName;
@property (nonatomic, copy, readonly) NSString * optometryEmployee;
@property (nonatomic, copy, readonly) NSString * optometryInsertDate;
@property (nonatomic, assign, readwrite) BOOL     isUpdateStatus;


@end
