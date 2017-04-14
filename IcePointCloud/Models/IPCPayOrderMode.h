//
//  IPCPayOrderMode.h
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCEmploye.h"

@interface IPCPayOrderMode : NSObject

+ (IPCPayOrderMode *)sharedManager;

@property (nonatomic,assign, readwrite) IPCPayStyleType      payStyle;
@property (nonatomic, copy, readwrite) NSString     *   payStyleName;




- (void)clearData;

@end
