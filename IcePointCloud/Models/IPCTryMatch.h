//
//  IPCTryMatch.h
//  IcePointCloud
//
//  Created by gerry on 2017/8/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCMatchItem.h"

@interface IPCTryMatch : NSObject

@property (nonatomic, strong) NSMutableArray<IPCMatchItem *> *matchItems;
@property (nonatomic, assign) NSInteger    activeMatchItemIndex;

+ (IPCTryMatch *)instance;
-  (void)initMatchItems;
-  (void)setCurrentMatchItem:(IPCGlasses *)glass;
-  (IPCMatchItem *)currentMatchItem;

@end
