//
//  IPCTryMatch.m
//  IcePointCloud
//
//  Created by gerry on 2017/8/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCTryMatch.h"

@implementation IPCTryMatch

+ (IPCTryMatch *)instance
{
    static dispatch_once_t token;
    static IPCTryMatch *_client;
    dispatch_once(&token, ^{
        _client = [[self alloc] init];
    });
    return _client;
}

#pragma mark //Init Array
- (NSMutableArray<IPCMatchItem *> *)matchItems{
    if (!_matchItems)
        _matchItems = [[NSMutableArray alloc]init];
    return _matchItems;
}

- (void)initMatchItems
{
    for (NSInteger i = 0; i < 4; i++) {
        IPCMatchItem *mi = [[IPCMatchItem alloc]init];
        mi.modelType = IPCModelTypeGirlWithLongHair;//current model
        [self.matchItems addObject:mi];
    }
    self.activeMatchItemIndex = 0;
}

- (void)setCurrentMatchItem:(IPCGlasses *)glass
{
    IPCMatchItem * item = self.matchItems[self.activeMatchItemIndex];
    item.glass = glass;
}

- (IPCMatchItem *)currentMatchItem
{
    if (self.matchItems.count)
        return self.matchItems[self.activeMatchItemIndex];
    return nil;
}

@end
