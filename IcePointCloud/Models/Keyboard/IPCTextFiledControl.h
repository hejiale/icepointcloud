//
//  IPCTextFiledControl.h
//  IcePointCloud
//
//  Created by gerry on 2017/11/27.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCCustomTextField.h"

@interface IPCTextFiledControl : NSObject

+ (IPCTextFiledControl *)instance;

@property (nonatomic, strong) NSMutableArray<IPCCustomTextField *> * textFiledArray;

- (void)addTextField:(IPCCustomTextField *)textField;

- (void)clearAllEditingAddition:(IPCCustomTextField *)textField;

- (void)clearAllTextField;

@end
