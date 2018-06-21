//
//  IPCPayCashMemberCardView.h
//  IcePointCloud
//
//  Created by gerry on 2018/6/19.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayCashMemberCardView : UIView

- (instancetype)initWithFrame:(CGRect)frame Coupon:(IPCPayCashAllCoupon *)coupon  Complete:(void(^)())complete;

@end
