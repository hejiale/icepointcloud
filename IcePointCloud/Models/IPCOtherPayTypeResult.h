//
//  IPCOtherPayTypeResult.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/16.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCOtherPayTypeResult : NSObject

@property (nonatomic, copy, readwrite) NSString * otherPayTypeName;
@property (nonatomic, assign, readwrite) double  otherPayAmount;


@end
