//
//  CustomDatePickViewController.h
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCDatePickViewControllerDelegate;

@interface IPCDatePickViewController : UIViewController

@property (assign, nonatomic) id<IPCDatePickViewControllerDelegate>delegate;

- (void)showWithPosition:(CGPoint)position Size:(CGSize)size Owner:(UIView *)owner;

@end

@protocol IPCDatePickViewControllerDelegate <NSObject>

- (void)completeChooseDate:(NSString *)date;

@end
