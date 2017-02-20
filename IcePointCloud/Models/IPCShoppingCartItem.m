//
//  IPCShoppingCartItem.m
//  IcePointCloud
//
//  Created by mac on 8/30/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCShoppingCartItem.h"

@implementation IPCShoppingCartItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.IOROptions     = [NSMutableArray new];
        self.lensTypes      = [NSMutableArray new];
        self.lensFuncs      = [NSMutableArray new];
        self.thickenOptions = [NSMutableArray new];
        self.thinnerOptions = [NSMutableArray new];
        self.shiftOptions   = [NSMutableArray new];
    }
    return self;
}


- (void)setCount:(NSInteger)count
{
    _count = count;
    [[IPCShoppingCart sharedCart] postChangedNotification];
}

- (double)totalPrice
{
    return self.unitPrice * self.count;
}

- (double)unitPrice
{
    if (_unitPrice == 0)
        return self.glasses.price;
    return _unitPrice;
}


//Joining together to upload the order parameter
- (NSDictionary *)paramtersJSONForOrderRequest
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params setObject:self.glasses.glassesID forKey:@"productId"];
    [params setObject:@(self.count) forKey:@"count"];
    [params setObject:@(self.unitPrice) forKey:@"price"];
    
    NSMutableDictionary *attrs = [[NSMutableDictionary alloc]init];
    
    if (self.batchSph.length) {
        [attrs setObject:self.batchSph forKey:@"sphLeft"];
        [attrs setObject:self.batchSph forKey:@"sphRight"];
    }
    
    if (self.bacthCyl.length) {
        [attrs setObject:self.bacthCyl forKey:@"cylLeft"];
        [attrs setObject:self.bacthCyl forKey:@"cylRight"];
    }
    
    if (self.batchReadingDegree.length)
        [attrs setObject:self.batchReadingDegree forKey:@"degree"];
    

    if (self.contactDegree.length)
        [attrs setObject:self.contactDegree forKey:@"degree"];
    
    if (self.batchNum.length) {
        [attrs setObject:self.batchNum forKey:@"batchNumber"];
    }
    
    if (self.kindNum.length) {
        [attrs setObject:self.kindNum forKey:@"approvalNumber"];
    }
    
    if (self.validityDate.length) {
        [attrs setObject:self.validityDate forKey:@"expireDate"];
    }
    
    if (self.IOROptions.count)
        attrs[@"refraction"] = [self.IOROptions componentsJoinedByString:@","];
    
    if (self.lensTypes.count)
        attrs[@"orderLensType"] = [self.lensTypes componentsJoinedByString:@","];
    
    if (self.lensFuncs.count)
        attrs[@"orderLensFunction"] = [self.lensFuncs componentsJoinedByString:@","];
    
    if (self.thickenOptions.count)
        attrs[@"addThickness"] = [self.thickenOptions componentsJoinedByString:@","];
    
    if (self.thinnerOptions.count)
        attrs[@"isThinLens"] = [self.thinnerOptions componentsJoinedByString:@","];
    
    if (self.shiftOptions.count)
        attrs[@"moveCenter"] = [self.shiftOptions componentsJoinedByString:@","];
    
    if (self.remarks.length)
        attrs[@"memo"] = self.remarks;
    
    if (attrs.allKeys.count)
        [params setObject:attrs forKey:@"attributes"];
    
    return params;
}


@end
