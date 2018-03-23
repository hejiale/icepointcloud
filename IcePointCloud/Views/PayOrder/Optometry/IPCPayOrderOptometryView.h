//
//  IPCPayOrderOptometryView.h
//  IcePointCloud
//
//  Created by gerry on 2018/3/20.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayOrderOptometryView : UIView

- (instancetype)initWithFrame:(CGRect)frame UpdateBlock:(void(^)())update;

@property (copy, nonatomic) IPCOptometryMode * optometry;

- (void)updateStatus;

@end
