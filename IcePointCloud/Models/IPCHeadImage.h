//
//  IPCCustomerHeadImage.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCHeadImage : NSObject

+ (NSInteger)genderArcdom;

//---------------------------------根据性别 尺寸 标记来生成头像----------------------------------------//
+ (NSString *)gender:(NSString *)gender Tag:(NSString *)tag;

@end
