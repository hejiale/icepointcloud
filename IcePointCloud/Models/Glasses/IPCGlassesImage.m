//
//  IPCGlassesImage.m
//  IcePointCloud
//
//  Created by mac on 9/12/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCGlassesImage.h"

@implementation IPCGlassesImage


+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"imageURL": @"photoLinkNormal",
             @"width"   : @"normalWidth",
             @"height"  : @"normalHeight",
             };
}


@end
