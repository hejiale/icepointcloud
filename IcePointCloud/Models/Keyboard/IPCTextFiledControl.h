//
//  IPCTextFiledControl.h
//  IcePointCloud
//
//  Created by gerry on 2017/11/27.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCCustomTextField.h"
#import "IPCCustomTextFieldDelegate.h"

@interface IPCTextFiledControl : NSObject

+ (IPCTextFiledControl *)instance;

@property (nonatomic, strong) IPCCustomTextField * preTextField;

- (void)clearPreTextField;


@end
