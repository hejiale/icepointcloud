//
//  NSObject+IPCObserver.h
//  IcePointCloud
//
//  Created by gerry on 2017/12/12.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (IPCObserver)

- (void)ipc_addObserver:(NSObject *)observer ForKeyPath:(NSString *)keyPath;

@end
