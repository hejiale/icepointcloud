//
//  IPCCustomKeyboard.h
//  IcePointCloud
//
//  Created by gerry on 2017/11/14.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCCustomKeyboardDelegate;

@interface IPCCustomKeyboard : UIView

@property (nonatomic, assign) id<IPCCustomKeyboardDelegate>delegate;

@end

@protocol IPCCustomKeyboardDelegate <NSObject>

- (void)endEditingForKeyboard:(IPCCustomKeyboard *)keyboard Text:(NSString *)text;

- (void)beginEditPrefixTextFieldForKeyboard:(IPCCustomKeyboard *)keyboard;

- (void)beginEditSuffixTextFieldForKeyboard:(IPCCustomKeyboard *)keyboard;

@end
