//
//  IPCCommon.h
//  IcePointCloud
//
//  Created by mac on 8/7/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCCommon : NSObject


/**
 Determine whether the Numbers

 */
+ (BOOL)judgeIsNumber:(NSString *)text;

+ (BOOL)judgeIsIntNumber:(NSString *)text;

+ (BOOL)judgeIsFloatNumber:(NSString *)text;

+ (NSString *)formatNumber:(double)number Location:(NSInteger)location;

+ (double)floorNumber:(double)number;

+ (double)afterDouble:(NSString *)begin :(NSString *)end;


/**
 The date format conversion
 
 */
+ (NSDate *)dateFromString:(NSString *)dateString;

+ (NSString *)formatDate:(NSDate *)date IsTime:(BOOL)isTime;

/**
  Format purpose
 
 */
+ (NSString *)formatPurpose:(NSString *)purpose;

+ (NSString *)purpose:(NSString *)text;

/**
 The optometry customer gender transformation

 */
+ (NSString *)gender:(NSString *)text;

+ (NSString *)formatGender:(NSString *)gender;


/**
 Determine  the true phoneNum

 */
+ (BOOL)checkTelNumber:(NSString*)telNumber;

@end
