//
//  IPCAlertController.h
//  IcePointCloud
//
//  Created by mac on 2017/1/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IPCAlertController;

typedef IPCAlertController * (^IPCAlertActionTitle)(NSString * title);

typedef void(^IPCAlertActionBlock)(NSInteger buttonIndex, UIAlertAction * action, IPCAlertController *alertSelf);


NS_CLASS_AVAILABLE_IOS(8_0) @interface IPCAlertController : UIAlertController

@property (nullable, nonatomic, copy) void(^alertShowBlock)();

@property (nullable, nonatomic, copy) void(^alertDismissBlock)();

- (IPCAlertActionTitle)addDefaultTitle;

- (IPCAlertActionTitle)addCancelTitle;

- (IPCAlertActionTitle)addDestructiveTitle;


@end

typedef void(^IPCAlertControllerProcess)(IPCAlertController * alertController);

@interface UIViewController(IPCAlertController)

- (void)showAlertWithTitle:(NSString *)title
                   Message:(NSString *)message
                   Process:(IPCAlertControllerProcess)process
               ActionBlock:(IPCAlertActionBlock)actionBlock;

- (void)showActionSheetWithTitle:(NSString *)title
                         Message:(NSString *)message
                         Process:(IPCAlertControllerProcess)process
                     ActionBlock:(IPCAlertActionBlock)actionBlock;

@end
