//
//  IPCCustomsizedProduct.m
//  IcePointCloud
//
//  Created by gerry on 2017/5/8.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedProduct.h"

@implementation IPCCustomsizedProduct

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"customsizedId"  : @"id",
             @"remark": @"description"};
}


- (NSDictionary *)displayFields
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[NSString stringWithFormat:@"%d天",self.period] forKey:@"定制周期"];
    [dic setObject:self.supplierName forKey:@"供应商"];
    [dic setObject:self.brand forKey:@"品牌"];
    [dic setObject:self.remark forKey:@"商品说明"];
    [dic setObject:self.lensFunction ? : @"" forKey:@"功能"];
    [dic setObject:[NSString stringWithFormat:@"%@~%@",self.sphStart,self.sphEnd] forKey:@"球镜范围"];
    [dic setObject:self.layer ? : @"" forKey:@"膜层"];
    [dic setObject:self.refraction ? : @"" forKey:@"折射率"];
    [dic setObject:[NSString stringWithFormat:@"%@~%@",self.cylStart,self.cylEnd] forKey:@"柱镜范围"];
    [dic setObject:self.material ? : @"" forKey:@"材质"];
    return dic;
}

@end
