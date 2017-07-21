//
//  IPCEditBatchParameterMode.h
//  IcePointCloud
//
//  Created by gerry on 2017/3/10.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCEditBatchParameterViewMode : NSObject

@property (strong, nonatomic) IPCGlasses * currentGlass;
@property (strong, nonatomic) IPCBatchParameterList * batchParameterList;

- (instancetype)initWithGlasses:(IPCGlasses *)glass UpdateUI:(void(^)())update;

- (void)queryBatchStockRequest;
- (void)queryBatchReadingDegreeRequest;
- (void)queryContactLensStockRequest;

- (NSInteger)queryLensStock:(IPCShoppingCartItem *)cartItem;
- (NSInteger)queryReadingLensStock:(IPCShoppingCartItem *)cartItem;
- (NSInteger)queryContactLensStock:(IPCShoppingCartItem *)cartItem;


@end
