//
//  ShareChatView.h
//  IcePointCloud
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCShareChatView : UIView

- (instancetype)initWithFrame:(CGRect)frame Chat:(void(^)())chat Line:(void(^)())line Favorite:(void(^)())favorite;
- (void)show;

@end
