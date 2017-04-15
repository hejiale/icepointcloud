//
//  IPCCustomerHeadImage.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomerHeadImage.h"

@implementation IPCCustomerHeadImage

+ (NSArray *)maleImageArray
{
    NSMutableArray * list = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 1 ; i < 17; i ++ ) {
        [list addObject:[NSString stringWithFormat:@"男%d",i]];
    }
    return list;
}

+ (NSArray *)femaleImageArray
{
    NSMutableArray * list = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 1 ; i < 17; i ++ ) {
        [list addObject:[NSString stringWithFormat:@"女%d",i]];
    }
    return list;
}

+ (NSString *)genderMaleImage
{
    int index =  1 + arc4random() % 16;
    return [self maleImageArray][index];
}

+ (NSString *)genderFemaleImage
{
    int index =  1 + arc4random() % 16;
    return [self femaleImageArray][index];
}


@end
