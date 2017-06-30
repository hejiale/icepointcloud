//
//  IPCSingleModeView.m
//  IcePointCloud
//
//  Created by mac on 8/15/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCSingleModeView.h"

@interface IPCSingleModeView()

@property (nonatomic, strong) IPCTryGlassView * tryGlassesView;

@end

@implementation IPCSingleModeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        _tryGlassesView = [[IPCTryGlassView alloc]initWithFrame:frame];
        _tryGlassesView.modelUsage = IPCModelUsageSingleMode;
        [self addSubview:self.tryGlassesView];
        
        __weak typeof(self) weakSelf = self;
        [[_tryGlassesView rac_signalForSelector:@selector(scaleAction:)] subscribeNext:^(RACTuple * _Nullable x) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate) {
                if ([strongSelf.delegate respondsToSelector:@selector(changeSingleOrCompareModeWithMatchItem:MatchType:)]) {
                    [strongSelf.delegate changeSingleOrCompareModeWithMatchItem:strongSelf.matchItem MatchType:IPCModelUsageCompareMode];
                }
            }
        }];
    }
    return self;
}

- (void)setMatchItem:(IPCMatchItem *)matchItem
{
    _matchItem = matchItem;
    [self.tryGlassesView updateItemForItem:matchItem :NO];
}

#pragma mark //Clicked Events
//Update the model picture
- (void)updateModelPhoto
{
    [self.tryGlassesView updateModelPhotoForItem:self.matchItem];
}

/**
 *  Updated photo like glasses
 */
- (void)updateFaceUI:(CGPoint)point :(CGSize)size
{
    [self.tryGlassesView updateFaceUIForItem:self.matchItem : point : size];
}

//Place the glasses
- (void)dropGlasses:(IPCGlasses *)glasses onLocaton:(CGPoint)location
{
    self.matchItem.glass = glasses;
//    [self initGlassView];
    [self.tryGlassesView updateItemForItem:self.matchItem :YES];
}

@end
