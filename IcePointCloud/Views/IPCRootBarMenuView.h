//
//  IPCRootBarMenuView.h
//  IcePointCloud
//
//  Created by gerry on 2017/3/13.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCRootBarMenuView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                    MenuIndex:(NSInteger)index
                     PayOrder:(void(^)())payOrder
                       Logout:(void(^)())logout
                         Help:(void(^)())help
                      Dismiss:(void(^)())dismiss;

@end
