//
//  LoginHistoryViewController.h
//  IcePointCloud
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginHistoryViewControllerDelegate;

@interface IPCLoginHistoryViewController : UIViewController

@property (nonatomic, weak) id<LoginHistoryViewControllerDelegate>delegate;

- (void)showWithSize:(CGSize)size Position:(CGPoint)position Owner:(UIView *)owner;

@end

@protocol LoginHistoryViewControllerDelegate <NSObject>

- (void)chooseHistoryLoginName:(NSString *)loginName;

@end
