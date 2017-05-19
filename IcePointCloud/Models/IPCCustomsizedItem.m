//
//  IPCCustomsizedManager.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedItem.h"

@implementation IPCCustomsizedItem

+ (IPCCustomsizedItem *)sharedItem
{
    static IPCCustomsizedItem *cart;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        cart = [[IPCCustomsizedItem alloc] init];
    });
    return cart;
}

- (NSMutableArray<IPCShoppingCartItem *> *)normalProducts{
    if (!_normalProducts) {
        _normalProducts = [[NSMutableArray alloc] init];
    }
    return _normalProducts;
}


- (void)resetData{
    self.customsizdType = IPCCustomsizedTypeNone;
    self.payOrderType = IPCPayOrderTypeNormal;
    self.customsizedProduct = nil;
    [self.normalProducts removeAllObjects];
    self.normalProducts = nil;
    self.leftEye       = nil;
    self.rightEye     = nil;
}

- (double)totalPrice
{
    __block double price = 0;
    [self.normalProducts enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        price += obj.totalPrice;
    }];
    if (self.customsizdType == IPCCustomsizedTypeUnified) {
        price += self.rightEye.customsizedCount * self.rightEye.customsizedPrice;
    }else if(self.customsizdType == IPCCustomsizedTypeLeftOrRightEye){
        price += self.rightEye.customsizedCount * self.rightEye.customsizedPrice;
        price += self.leftEye.customsizedCount * self.leftEye.customsizedPrice;
    }
    return price;
}

//Joining together to upload the order parameter
- (NSDictionary *)paramtersJSONForOrderRequest
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    //--------------定制商品--------------//
    if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens) {
        [params setObject:@"CUSTOMIZED_LENS" forKey:@"customizedProdType"];
    }else if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedContactLens){
        [params setObject:@"CUSTOMIZED_CONTACT_LENS" forKey:@"customizedProdType"];
    }
    [params setObject:@"true" forKey:@"isCustomizedLens"];
    [params setObject:[IPCCustomsizedItem sharedItem].customsizedProduct.customsizedId forKey:@"customizedId"];
    
    IPCCustomsizedEye * rightEye = [IPCCustomsizedItem sharedItem].rightEye;
    IPCCustomsizedEye * leftEye   = [IPCCustomsizedItem sharedItem].leftEye;
    
    if ([IPCCustomsizedItem sharedItem].customsizdType == IPCCustomsizedTypeUnified)
    {
        [params setObject:@"true" forKey:@"isUnifiedCustomizd"];
        leftEye = rightEye;
    }else if ([IPCCustomsizedItem sharedItem].customsizdType == IPCCustomsizedTypeLeftOrRightEye){
        [params setObject:@"false" forKey:@"isUnifiedCustomizd"];
    }
    
    if ([IPCCustomsizedItem sharedItem].customsizdType == IPCCustomsizedTypeUnified) {
        [params setObject:[NSString stringWithFormat:@"%.2f",rightEye.customsizedPrice] forKey:@"afterDiscountPrice"];
    }else if ([IPCCustomsizedItem sharedItem].customsizdType == IPCCustomsizedTypeLeftOrRightEye){
        [params setObject:[NSString stringWithFormat:@"%.2f",rightEye.customsizedPrice + leftEye.customsizedPrice] forKey:@"afterDiscountPrice"];
    }
    
    [params setObject:rightEye.channel ? : @"" forKey:@"chanelRight"];
    [params setObject:rightEye.sph ? : @"" forKey:@"sphRight"];
    [params setObject:rightEye.cyl ? : @"" forKey:@"cylRight"];
    [params setObject:rightEye.distance ? : @"" forKey:@"distanceRight"];
    [params setObject:rightEye.axis ? : @"" forKey:@"axisRight"];
    [params setObject:rightEye.add ? : @"" forKey:@"addRight"];
    [params setObject:rightEye.dyeing ? : @"" forKey:@"dyeRight"];
    [params setObject:rightEye.membrane ? : @"" forKey:@"layerRight"];
    [params setObject:rightEye.channel ? : @"" forKey:@"chanelRight"];
    [params setObject:[NSString stringWithFormat:@"%.2f",rightEye.customsizedPrice] forKey:@"customizedRightPrice"];
    [params setObject:@(rightEye.customsizedCount) forKey:@"customizedRightCount"];
    
    NSMutableDictionary * rightCustomsizedDic = [[NSMutableDictionary alloc]init];
    [rightEye.otherArray enumerateObjectsUsingBlock:^(IPCCustomsizedOther * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [rightCustomsizedDic setObject:obj.otherParameter forKey:obj.otherParameterRemark];
    }];
    [params setObject:rightCustomsizedDic forKey:@"customizedRight"];
    
    [params setObject:leftEye.channel ? : @"" forKey:@"chanelLeft"];
    [params setObject:leftEye.sph ? : @"" forKey:@"sphLeft"];
    [params setObject:leftEye.cyl ? : @"" forKey:@"cylLeft"];
    [params setObject:leftEye.distance ? : @"" forKey:@"distance"];
    [params setObject:leftEye.axis ? : @"" forKey:@"axisLeft"];
    [params setObject:leftEye.add ? : @"" forKey:@"addLeft"];
    [params setObject:leftEye.dyeing ? : @"" forKey:@"dyeLeft"];
    [params setObject:leftEye.membrane ? : @"" forKey:@"layerLeft"];
    [params setObject:leftEye.channel ? : @"" forKey:@"chanelLeft"];
    if ([IPCCustomsizedItem sharedItem].customsizdType == IPCCustomsizedTypeLeftOrRightEye) {
        [params setObject:[NSString stringWithFormat:@"%.2f",leftEye.customsizedPrice] forKey:@"customizedLeftPrice"];
        [params setObject:@(leftEye.customsizedCount) forKey:@"customizedCount"];
    }

    NSMutableDictionary * leftCustomsizedDic = [[NSMutableDictionary alloc]init];
    [leftEye.otherArray enumerateObjectsUsingBlock:^(IPCCustomsizedOther * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [leftCustomsizedDic setObject:obj.otherParameter forKey:obj.otherParameterRemark];
    }];
    [params setObject:leftCustomsizedDic forKey:@"customizedLeft"];
    
    return params;
}



@end
