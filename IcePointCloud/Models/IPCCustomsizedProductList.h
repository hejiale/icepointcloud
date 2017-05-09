//
//  IPCCustomsizedProductList.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/19.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCCustomsizedProduct.h"

@interface IPCCustomsizedProductList : NSObject

@property (nonatomic, strong, readwrite) NSMutableArray<IPCCustomsizedProduct *> * productsList;

- (instancetype)initWithResponseObject:(id)responseObject;

@end

