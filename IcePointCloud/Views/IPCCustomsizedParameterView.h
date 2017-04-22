//
//  IPCCustomsizedParameterView.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCCustomsizedEyeDelegate.h"
#import "IPCCustomsizedLensView.h"
#import "IPCCustomsizedContactLensView.h"
#import "IPCCustomsizedOtherView.h"

@protocol IPCCustomsizedParameterViewDelegate;

@interface IPCCustomsizedParameterView : UIView<UITextFieldDelegate>
//定制镜片商品
@property (strong, nonatomic)  IPCCustomsizedLensView *lensView;
//定制隐形眼镜商品
@property (strong, nonatomic)  IPCCustomsizedContactLensView *contactLensView;
//判断左右眼
@property (assign, nonatomic) BOOL isRight;

@property (assign, nonatomic) id<IPCCustomsizedEyeDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame Direction:(BOOL)isRight;

- (void)reloadOtherParameterView;


@end
