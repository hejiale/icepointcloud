//
//  IPCCustomTextFieldDelegate.h
//  IcePointCloud
//
//  Created by gerry on 2017/11/30.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IPCCustomTextFieldDelegate <NSObject>

@optional
- (void)textFieldBeginEditing:(IPCCustomTextField *)textField;

- (void)textFieldPreEditing:(IPCCustomTextField *)textField;

- (void)textFieldNextEditing:(IPCCustomTextField *)textField;

- (void)textFieldEndEditing:(IPCCustomTextField *)textField;

@end
