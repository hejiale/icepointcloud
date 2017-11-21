//
//  IPCPayOrderOptometryHeadView.h
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayOrderOptometryHeadView : UIView

- (instancetype)initWithFrame:(CGRect)frame ChooseBlock:(void(^)())choose;

- (void)updateOptometryInfo;

@end
