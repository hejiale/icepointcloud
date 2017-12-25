//
//  IPCShoppingCartItem.h
//  IcePointCloud
//
//  Created by mac on 8/30/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCGlasses.h"

@interface IPCShoppingCartItem : NSObject

///CustomsizedLens Parameter
@property (nonatomic, copy, readwrite) NSString  *IOROptions;//折射率
@property (nonatomic, copy, readwrite) NSString  *lensTypes;//镜片类型
@property (nonatomic, strong, readwrite) NSMutableArray  *lensFuncsArray;//镜片功能
@property (nonatomic, copy, readwrite) NSString  *thickenOptions;//加厚
@property (nonatomic, copy, readwrite) NSString  *thinnerOptions;//美薄
@property (nonatomic, copy, readwrite) NSString  *shiftOptions;//移心
///Glasses Parameter
@property (nonatomic, strong, readwrite) IPCGlasses *glasses;
@property (nonatomic, assign, readwrite) NSInteger    glassCount;
@property (nonatomic, assign, readwrite) BOOL        selected;
@property (nonatomic, assign, readwrite) double      prePrice;//商品原价
@property (nonatomic, assign, readwrite) double      unitPrice;//可修改单价
@property (nonatomic, assign, readwrite) double      totalUpdatePrice;//可修改商品总价
@property (nonatomic, copy, readwrite)   NSString   *remarks;//note
/**
 *  Bulk data parameter
 */
@property (nonatomic, copy, readwrite) NSString * batchSph;//Batch Sph parameters
@property (nonatomic, copy, readwrite) NSString * bacthCyl;//Batch cyl.ul parameters
@property (nonatomic, copy, readwrite) NSString * batchReadingDegree;//Batch aging degree

- (double)totalPrePrice;
- (double)totalPrice;
- (NSDictionary *)paramtersJSONForOrderRequest;


@end
