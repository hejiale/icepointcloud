//
//  IPCRootBarMenuView.h
//  IcePointCloud
//
//  Created by gerry on 2017/3/13.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCSideBarMenuView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                       Logout:(void(^)())logout
                      Dismiss:(void(^)())dismiss;

@end
