//
//  IPCPayOrderSubViewDelegate.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/16.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IPCPayOrderSubViewDelegate <NSObject>

- (void)reloadUI;

- (void)getPointPrice:(double)point;

@end
