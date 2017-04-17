//
//  IPCPayOrderParameter.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCPayOrderParameter : NSObject

- (NSDictionary *)offOrderParameterWithPayStatus:(BOOL)payStatus;

- (NSArray *)productListParamter;


@end
