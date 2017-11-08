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
        [[IPCTryMatch instance].matchItems addObject:mi];
    }
    [IPCTryMatch instance].activeMatchItemIndex = 0;
}

- (void)setCurrentMatchItem:(IPCGlasses *)glass
{
    IPCMatchItem * item = [IPCTryMatch instance].matchItems[[IPCTryMatch instance].activeMatchItemIndex];
    item.glass = glass;
}

- (IPCMatchItem *)currentMatchItem
{
    if ([IPCTryMatch instance].matchItems.count)
        return [IPCTryMatch instance].matchItems[[IPCTryMatch instance].activeMatchItemIndex];
    return nil;
}

- (CGPoint)singleModeViewAnchorPoint
{
    switch ([IPCTryMatch instance].activeMatchItemIndex) {
        case 0:
            return CGPointMake(0, 0);
        case 1:
            return CGPointMake(1, 0);
        case 2:
            return CGPointMake(0, 1);
        case 3:
            return CGPointMake(1, 1);
        default:
            return CGPointZero;
    }
}

- (void)clearData{
    [[IPCTryMatch instance].matchItems removeAllObjects];
    [IPCTryMatch instance].matchItems = nil;
    [IPCTryMatch instance].activeMatchItemIndex = 0;
}

@end
