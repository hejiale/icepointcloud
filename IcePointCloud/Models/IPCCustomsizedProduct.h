//
//  IPCCustomsizedProduct.h
//  IcePointCloud
//
//  Created by gerry on 2017/5/8.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCCustomsizedProduct : NSObject

@property (nonatomic, copy, readonly) NSString *  brand;
@property (nonatomic, copy, readonly) NSString *  cylStart;
@property (nonatomic, copy, readonly) NSString *  cylEnd;
@property (nonatomic, copy, readonly) NSString *  sphStart;
@property (nonatomic, copy, readonly) NSString *  sphEnd;
@property (nonatomic, copy, readonly) NSString *  layer;
@property (nonatomic, copy, readonly) NSString *  lensFunction;
@property (nonatomic, copy, readonly) NSString *  material;
@property (nonatomic, copy, readonly) NSString *  customsizedId;
@property (nonatomic, copy, readonly) NSString *  refraction;
@property (nonatomic, assign, readonly) double    suggestPrice;
@property (nonatomic, copy, readonly) NSString *  thumbnailURL;
@property (nonatomic, copy, readonly) NSString *  supplierName;
@property (nonatomic, copy, readonly) NSString *  name;
@property (nonatomic, assign, readonly) double    bizPriceOrigin;
@property (nonatomic, copy, readonly) NSString *   packingSpec;//规格
@property (nonatomic, copy, readonly) NSString *   waterContent;//含水量
@property (nonatomic, copy, readonly) NSString *   lensPeriod;
@property (nonatomic, copy, readonly) NSString *   lensDistance;
@property (nonatomic, copy, readonly) NSString *   lensThickness;//厚度
@property (nonatomic, copy, readonly) NSString *   baseCurve;
@property (nonatomic, assign, readonly) NSInteger   period;//周期
@property (nonatomic, copy, readonly) NSString *   remark;

- (NSDictionary *)displayFields;

@end
