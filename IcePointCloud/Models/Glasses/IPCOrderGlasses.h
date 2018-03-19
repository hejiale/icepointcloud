//
//  IPCOrderGlasses.h
//  IcePointCloud
//
//  Created by gerry on 2018/3/19.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCOrderGlasses : NSObject

@property (nonatomic, assign) BOOL  batchAdd;
@property (nonatomic, assign) NSInteger  bizStock;
@property (nonatomic, copy) NSString *  prodCode;
@property (nonatomic, copy) NSString *  prodId;
@property (nonatomic, copy) NSString *  prodName;
@property (nonatomic, copy) NSString *  prodType;
@property (nonatomic, assign) CGFloat   suggestPrice;

@end
