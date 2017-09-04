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

+ (NSString *)gender:(NSString *)gender Tag:(NSString *)tag
{
    return [NSString stringWithFormat:@"%@_middle_%@", gender, tag];
}

@end
