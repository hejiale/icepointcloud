//
//  IPCCustomsizedProductList.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/19.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCCustomsizedProduct;
@interface IPCCustomsizedProductList : NSObject

@property (nonatomic, strong, readwrite) NSMutableArray<IPCCustomsizedProduct *> * productsList;

- (instancetype)initWithResponseObject:(id)responseObject;

@end

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

@end
