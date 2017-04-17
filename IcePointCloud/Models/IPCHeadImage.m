//
//  IPCCustomerHeadImage.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCHeadImage.h"

@implementation IPCHeadImage


+ (NSInteger)genderArcdom
{
    return arc4random() % 16;
}

//---------------------------------根据性别 尺寸 标记来生成头像----------------------------------------//

+ (NSString *)gender:(NSString *)gender Size:(NSString *)size  Tag:(NSString *)tag
{
    NSString * headImage = nil;
    
    if (tag.length && tag) {
        headImage = [NSString stringWithFormat:@"%@_%@_%@", gender, size, tag];
    }else{
        if ([gender isEqualToString:@"NOTSET"]) {
            headImage = @"MALE_small_11";
        }else{
            headImage = [IPCHeadImage  gender:gender Size:size Tag:@"1"];
        }
    }
    return headImage;
}

@end
