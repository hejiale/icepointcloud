//
//  IPCShoppingCartItem.h
//  IcePointCloud
//
//  Created by mac on 8/30/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCGlasses.h"

@interface IPCShoppingCartItem : NSObject

@property (nonatomic, copy) NSString  *IOROptions;//折射率
@property (nonatomic, copy) NSString  *lensTypes;//镜片类型
@property (nonatomic, strong) NSMutableArray  *lensFuncsArray;//镜片功能
@property (nonatomic, copy) NSString  *thickenOptions;//加厚
@property (nonatomic, copy) NSString  *thinnerOptions;//美薄
@property (nonatomic, copy) NSString  *shiftOptions;//移心

@property (nonatomic, strong) IPCGlasses *glasses;
@property (nonatomic, assign) NSInteger   count;
@property (nonatomic, assign) BOOL        selected;
@property (nonatomic, assign) double      unitPrice;
@property (nonatomic, copy)   NSString   *remarks;//note

/**
 *  Bulk data parameter
 */
@property (nonatomic, copy) NSString * batchSph;//Batch Sph parameters
@property (nonatomic, copy) NSString * bacthCyl;//Batch cyl.ul parameters
@property (nonatomic, copy) NSString * batchReadingDegree;//Batch aging degree
@property (nonatomic, copy) NSString * contactLensID;//Batch contact ID
@property (nonatomic, copy) NSString * contactDegree;//Batch contact degree
@property (nonatomic, copy) NSString * batchNum;//Batch stealth batch number
@property (nonatomic, copy) NSString * kindNum;//Batch invisible kind
@property (nonatomic, copy) NSString * validityDate;//Batch stealth is valid
@property (nonatomic, assign) BOOL     isPreSell;

- (double)totalPrice;
- (NSDictionary *)paramtersJSONForOrderRequest;


@end
