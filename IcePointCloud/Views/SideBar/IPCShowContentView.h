//
//  IPCShowContentView.h
//  IcePointCloud
//
//  Created by gerry on 2017/10/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCPersonConetentViewDelegate;

@interface IPCShowContentView : UIView

@property (nonatomic, assign) id<IPCPersonConetentViewDelegate>delegate;

- (void)show;

- (void)dismiss;

@end

@protocol IPCPersonConetentViewDelegate <NSObject>

- (void)dismissContentView;

@end
