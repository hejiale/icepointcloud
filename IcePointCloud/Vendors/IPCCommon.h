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

 @param text
 @return
 */
+ (BOOL)judgeIsNumber:(NSString *)text;

+ (BOOL)judgeIsIntNumber:(NSString *)text;

+ (BOOL)judgeIsFloatNumber:(NSString *)text;


/**
 The date format conversion
 
 */
+ (NSDate *)dateFromString:(NSString *)dateString;

+ (NSString *)formatDate:(NSDate *)date IsTime:(BOOL)isTime;


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
