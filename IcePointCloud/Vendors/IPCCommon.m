//
//  IPCCommon.m
//  IcePointCloud
//
//  Created by mac on 8/7/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCCommon.h"

#define NUMBERS                  @"0123456789.-+\n"
#define SecondFormatter      @"yyyy-MM-dd'T'HH:mm:ssZZZZZ"
#define TimeFormatter          @"yyyy-MM-dd HH:mm:ss"
#define DateFormatter           @"yyyy-MM-dd"

@implementation IPCCommon


+ (BOOL)judgeIsNumber:(NSString *)text{
    NSCharacterSet * cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [text isEqualToString:filtered];
}


+ (NSString *)formatDate:(NSDate *)date IsTime:(BOOL)isTime
{
    if ([date isKindOfClass:[NSNull class]] || !date)return nil;
    return [NSDate jk_stringWithDate:date format:isTime ? TimeFormatter: DateFormatter];
}

+ (NSDate *)dateFromString:(NSString *)dateString{
    if ([dateString isKindOfClass:[NSNull class]])return nil;
    return [NSDate jk_dateWithString:dateString format:SecondFormatter];
}


+ (NSString *)gender:(NSString *)text{
    NSString * gender = @"";
    if ([text isEqualToString:@"男"]) {
        gender = @"MALE";
    }else if ([text isEqualToString:@"女"]){
        gender = @"FEMALE";
    }else if ([text isEqualToString:@"未设置"]){
        gender = @"NOTSET";
    }
    return gender;
}

+ (NSString *)formatGender:(NSString *)gender{
    NSString * genderString = @"";
    
    if ([gender isEqualToString:@"MALE"]) {
        genderString = @"男";
    }else if ([gender isEqualToString:@"FEMALE"]){
        genderString = @"女";
    }else if ([gender isEqualToString:@"NOTSET"]){
        genderString = @"";
    }
    return genderString;
}


+(BOOL)checkTelNumber:(NSString*)telNumber
{
    if (telNumber.length < 11){
        return NO;
    }else{
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:telNumber];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:telNumber];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:telNumber];
        
        if (isMatch1 || isMatch2 || isMatch3)
            return YES;
    }
    return NO;
}


@end
