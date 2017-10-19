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
        self.lensFuncsArray = [[NSMutableArray alloc]init];
    }
    return self;
}


- (void)setGlassCount:(int)glassCount
{
    _glassCount = glassCount;
    [[IPCShoppingCart sharedCart] postChangedNotification];
}

- (double)totalPrice
{
    NSString * priceStr = [NSString stringWithFormat:@"%.2f",self.unitPrice];
    return [priceStr doubleValue] * self.glassCount;
}

- (double)unitPrice
{
    //下订单页面 选择客户的折扣计算
    if ([IPCPayOrderManager sharedManager].isChooseCustomer) {
        _unitPrice = 0;
        [IPCPayOrderManager sharedManager].isChooseCustomer = NO;
    }
    if (_unitPrice == 0){
        if ([IPCPayOrderManager sharedManager].customerDiscount > 0) {
            return self.glasses.price * [IPCPayOrderManager sharedManager].customerDiscount;
        }
        return self.glasses.price;
    }
    return _unitPrice;
}


//Joining together to upload the order parameter
- (NSDictionary *)paramtersJSONForOrderRequest
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSString stringWithFormat:@"%.2f",self.unitPrice] forKey:@"afterDiscountPrice"];

    if ([self.glasses filterType] == IPCTopFIlterTypeFrames || [self.glasses filterType] == IPCTopFilterTypeSunGlasses || [self.glasses filterType] == IPCTopFilterTypeCustomized || [self.glasses filterType] == IPCTopFilterTypeReadingGlass)
    {
        [params setObject:@(self.glassCount) forKey:@"glassCount"];
        [params setObject:@(self.glasses.price) forKey:@"glassPrice"];
        [params setObject:[self.glasses glassId] forKey:@"glassId"];
    }else if ([self.glasses filterType] == IPCTopFilterTypeLens || [self.glasses filterType] == IPCTopFilterTypeContactLenses)
    {
        [params setObject:@(self.glassCount) forKey:@"lensCount"];
        [params setObject:@(self.glasses.price) forKey:@"lensPrice"];
        [params setObject:[self.glasses glassId] forKey:@"lensId"];
    }else if ([self.glasses filterType] == IPCTopFilterTypeAccessory)
    {
        [params setObject:@(self.glassCount) forKey:@"accessoryCount"];
        [params setObject:@(self.glasses.price) forKey:@"accessoryPrice"];
        [params setObject:[self.glasses glassId] forKey:@"accessoryId"];
    }else if ([self.glasses filterType] == IPCTopFilterTypeOthers)
    {
        [params setObject:@(self.glassCount) forKey:@"othersProductCount"];
        [params setObject:@(self.glasses.price) forKey:@"othersProductPrice"];
        [params setObject:[self.glasses glassId] forKey:@"othersProductId"];
    }
    
    //=--------定制类眼镜参数-----=//
    NSMutableDictionary *attrs = [[NSMutableDictionary alloc]init];
    
    if ([self.glasses filterType] == IPCTopFilterTypeCustomized) {
        if (self.IOROptions.length)
            attrs[@"refraction"] = self.IOROptions;
        
        if (self.lensTypes.length)
            attrs[@"orderLensType"] = self.lensTypes;
        
        if (self.lensFuncsArray.count)
            attrs[@"orderLensFunction"] = [self.lensFuncsArray componentsJoinedByString:@","];
        
        if (self.thickenOptions.length)
            attrs[@"addThickness"] = self.thickenOptions;
        
        if (self.thinnerOptions.length)
            attrs[@"isThinLens"] = self.thinnerOptions;
        
        if (self.shiftOptions.length)
            attrs[@"moveCenter"] = self.shiftOptions;
        
        if (self.remarks.length)
            attrs[@"memo"] = self.remarks;
    }
    
    //--------------批量眼镜--------------//
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
    
    [attrs setObject:@[] forKey:@"batchProductInfoList"];
    
    if (attrs.allKeys.count)
        [params setObject:attrs forKey:@"attributes"];

    return params;
}


@end
