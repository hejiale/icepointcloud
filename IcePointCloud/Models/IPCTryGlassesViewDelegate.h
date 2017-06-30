//
//  IPCTryGlassesViewDelegate.h
//  IcePointCloud
//
//  Created by gerry on 2017/6/30.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IPCTryGlassesViewDelegate <NSObject>

@optional

- (void)changeSingleOrCompareModeWithMatchItem:(IPCMatchItem *)item MatchType:(IPCModelUsage)type;

- (void)removeGlassesWithMatchItem:(IPCMatchItem *)item;

@end
