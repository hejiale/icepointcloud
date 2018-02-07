//
//  IPCSearchViewDelegate.h
//  IcePointCloud
//
//  Created by gerry on 2017/12/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IPCSearchViewDelegate <NSObject>

- (void)didSearchWithKeyword:(NSString *)keyword;

@end
