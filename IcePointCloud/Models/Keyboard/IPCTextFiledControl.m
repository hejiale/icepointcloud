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

- (void)clearPreTextField
{
    if (self.preTextField) {
        [self.preTextField setIsEditing:NO];
        [self.preTextField setText:@""];
        
        if ([self.preTextField.delegate respondsToSelector:@selector(textFieldEndEditing:)]) {
            [self.preTextField.delegate textFieldEndEditing:self.preTextField];
        }
        self.preTextField = nil;
    }
}

@end
