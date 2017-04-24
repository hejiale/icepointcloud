//
//  IPCCustomsizedParameterView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomsizedParameterView.h"

@interface IPCCustomsizedParameterView()

@end

@implementation IPCCustomsizedParameterView

- (instancetype)initWithFrame:(CGRect)frame Direction:(BOOL)isRight
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isRight = isRight;
        __weak typeof(self) weakSelf = self;
        
        if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedContactLens) {
            [self addSubview:self.contactLensView];
        
            [[self.contactLensView rac_signalForSelector:@selector(addOtherAction:)] subscribeNext:^(id x) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf addOtherParameter];
            }];
        }else if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens){
            [self addSubview:self.lensView];
        
            [[self.lensView rac_signalForSelector:@selector(addOtherAction:)] subscribeNext:^(id x) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf addOtherParameter];
            }];
        }
    }
    return self;
}


#pragma mark //Add Other Parameter
- (void)addOtherParameter{
    IPCCustomsizedOther * other = [[IPCCustomsizedOther alloc]init];
    if (self.isRight) {
        [[IPCCustomsizedItem sharedItem].rightEye.otherArray addObject:other];
    }else{
        [[IPCCustomsizedItem sharedItem].leftEye.otherArray addObject:other];
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadParameterInfoView)]) {
            [self.delegate reloadParameterInfoView];
        }
    }
}

#pragma mark //Set UI
- (IPCCustomsizedLensView *)lensView{
    if (!_lensView) {
        __weak typeof(self) weakSelf = self;
        _lensView = [[IPCCustomsizedLensView alloc]initWithFrame:self.bounds Update:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate) {
                if ([strongSelf.delegate respondsToSelector:@selector(reloadParameterInfoView)]) {
                    [strongSelf.delegate reloadParameterInfoView];
                }
            }
        }];
        _lensView.isRight = self.isRight;
    }
    return _lensView;
}

- (IPCCustomsizedContactLensView *)contactLensView{
    if (!_contactLensView) {
        __weak typeof(self) weakSelf = self;
        _contactLensView = [[IPCCustomsizedContactLensView alloc]initWithFrame:self.bounds Update:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf.delegate) {
                if ([strongSelf.delegate respondsToSelector:@selector(reloadParameterInfoView)]) {
                    [strongSelf.delegate reloadParameterInfoView];
                }
            }
        }];
        _contactLensView.isRight = self.isRight;
    }
    return _contactLensView;
}

- (void)reloadOtherParameterView{
    NSArray * otherArray = nil;
    if (self.isRight) {
        otherArray = [IPCCustomsizedItem sharedItem].rightEye.otherArray;
    }
    else{
        otherArray = [IPCCustomsizedItem sharedItem].leftEye.otherArray;
    }
    
    if (otherArray.count)
    {
        if (otherArray.count > 1) {
            CGRect frame = self.frame;
            frame.size.height += (otherArray.count - 1) * 50;
            self.frame = frame;
        }
    }
    
//    if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens) {
//        [self.lensView reloadUI];
//    }else if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedContactLens){
//        [self.contactLensView reloadUI];
//    }
}


@end
