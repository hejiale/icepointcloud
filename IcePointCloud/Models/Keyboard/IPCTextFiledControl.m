//
//  IPCTextFiledControl.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/27.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCTextFiledControl.h"

@implementation IPCTextFiledControl

+ (IPCTextFiledControl *)instance
{
    static dispatch_once_t token;
    static IPCTextFiledControl *_client;
    dispatch_once(&token, ^{
        _client = [[self alloc] init];
    });
    return _client;
}

- (NSMutableArray<IPCCustomTextField *> *)textFiledArray
{
    if (!_textFiledArray) {
        _textFiledArray = [[NSMutableArray alloc]init];
    }
    return _textFiledArray;
}

- (void)addTextField:(IPCCustomTextField *)textField
{
    [self.textFiledArray addObject:textField];
}

- (void)clearAllTextField
{
    [self.textFiledArray removeAllObjects];
}

- (void)clearAllEditingAddition:(IPCCustomTextField *)textField
{
    [self.textFiledArray enumerateObjectsUsingBlock:^(IPCCustomTextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:textField]) {
            [obj setIsEditing:NO];
            [obj reload];
            [[NSNotificationCenter defaultCenter] removeObserver:obj];
        }else{
            [obj setIsEditing:YES];
        }
    }];
}

@end
