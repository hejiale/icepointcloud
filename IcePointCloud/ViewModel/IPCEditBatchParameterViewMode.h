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
@property (strong, nonatomic) NSMutableArray<IPCContactLenSpecList *> * contactSpecificationArray;
@property (strong, nonatomic) IPCAccessorySpecList * accessorySpecification;

- (instancetype)initWithGlasses:(IPCGlasses *)glass UpdateUI:(void(^)())update;
- (void)queryBatchStockRequest;
- (void)queryBatchReadingDegreeRequest;
//- (void)getContactLensSpecification;
//- (void)queryAccessoryStock;
- (NSInteger)queryLensStock:(IPCShoppingCartItem *)cartItem;
- (NSInteger)queryReadingLensStock:(IPCShoppingCartItem *)cartItem;
//- (NSInteger)queryContactLensStock:(IPCShoppingCartItem *)cartItem;
//- (NSInteger)queryAccessoryStock:(IPCShoppingCartItem *)cartItem;

@end
