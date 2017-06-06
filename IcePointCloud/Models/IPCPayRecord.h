//
//  IPCPayRecord.h
//  IcePointCloud
//
//  Created by gerry on 2017/6/5.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCPayRecord : NSObject

@property (nonatomic, assign) IPCPayStyleType payStyle;
@property (nonatomic, copy) NSString * payStyleName;
@property (nonatomic, assign) double   payAmount;
@property (nonatomic, copy) NSString * payDate;

@end
