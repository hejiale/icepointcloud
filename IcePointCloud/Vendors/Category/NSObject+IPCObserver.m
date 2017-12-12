//
//  NSObject+IPCObserver.m
//  IcePointCloud
//
//  Created by gerry on 2017/12/12.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "NSObject+IPCObserver.h"

@interface IPCObserver: NSObject

@property (nonatomic, unsafe_unretained) id target;
@property (nonatomic, unsafe_unretained) id observer;
@property (nonatomic, strong) NSString * keyPath;
@property (nonatomic, weak) IPCObserver * factor;

@end


@implementation IPCObserver

- (void)dealloc
{
    if (_factor) {
        [_target removeObserver:_observer forKeyPath:_keyPath];
    }
}

@end


@implementation NSObject (IPCObserver)

- (void)ipc_addObserver:(NSObject *)observer ForKeyPath:(NSString *)keyPath
{
    [self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
    
    IPCObserver * helper = [[IPCObserver alloc]init];
    IPCObserver * sub = [[IPCObserver alloc]init];
    
    sub.target = helper.target = self;
    sub.observer = helper.observer = observer;
    sub.keyPath = helper.keyPath = keyPath;
    helper.factor = sub;
    sub.factor = helper;
    
    const char *helpKey = [NSString stringWithFormat:@"%zd",[observer hash]].UTF8String;
    objc_setAssociatedObject(self, helpKey, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(observer, helpKey, sub, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
