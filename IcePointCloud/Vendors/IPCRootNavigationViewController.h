//
//  IPCRootNavigationViewController.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/13.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCRootNavigationViewController : UIViewController

- (void)setNavigationBarStatus:(BOOL)isHiden;
- (void)setRightItem:(NSString *)itemImageName Selection:(SEL)selection;
- (void)setRightTitle:(NSString *)itemName Selection:(SEL)selection;
- (void)setRightEmptyView;
- (void)setTopSearchBar:(void(^)(NSString * text))searchBlock;

@end
