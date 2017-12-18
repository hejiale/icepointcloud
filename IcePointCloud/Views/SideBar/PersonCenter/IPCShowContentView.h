//
//  IPCShowContentView.h
//  IcePointCloud
//
//  Created by gerry on 2017/10/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCShowContentView : IPCPersonContentView

- (void)showContent;

- (void)dismissContent:(void(^)())completeBlock;

@end

