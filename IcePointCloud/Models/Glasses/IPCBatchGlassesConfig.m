//
//  IPCBatchGlassesConfig.m
//  IcePointCloud
//
//  Created by gerry on 2017/12/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCBatchGlassesConfig.h"

@implementation IPCBatchGlassesConfig

- (instancetype)initWithResponseValue:(id)responseValue
{
    self = [super init];
    if (self) {
        if ([responseValue isKindOfClass:[NSArray class]]) {
            id req = responseValue[0];
            if ([req isKindOfClass:[NSDictionary class]]) {
                self.prodId = req[@"prodId"];
                self.type = req[@"type"];
                if ([req[@"opticsBeans"] isKindOfClass:[NSArray class]]) {
                    id beans = req[@"opticsBeans"][0];
                    self.sph = beans[@"sph"];
                    self.cyl = beans[@"cyl"];
                    self.code = beans[@"code"];
                    self.suggestPrice = [beans[@"suggestPrice"] doubleValue];
                }
            }
        }
    }
    return self;
}

@end
