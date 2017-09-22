//
//  IPCWareHouseResult.h
//  IcePointCloud
//
//  Created by gerry on 2017/9/22.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCWareHouse.h"

@interface IPCWareHouseResult : NSObject

@property (nonatomic, strong) NSMutableArray<IPCWareHouse *> * wareHouseArray;

- (instancetype)initWithResponseValue:(id)responseValue;

@end
