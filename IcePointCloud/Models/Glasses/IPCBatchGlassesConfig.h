//
//  IPCBatchGlassesConfig.h
//  IcePointCloud
//
//  Created by gerry on 2017/12/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCBatchGlassesConfig : NSObject

@property (nonatomic, copy) NSString *  prodId;
@property (nonatomic, copy) NSString *  type;
@property (nonatomic, assign) double    suggestPrice;
@property (nonatomic, copy) NSString *  code;
@property (nonatomic, copy) NSString *  sph;
@property (nonatomic, copy) NSString *  cyl;

- (instancetype)initWithResponseValue:(id)responseValue;

@end
