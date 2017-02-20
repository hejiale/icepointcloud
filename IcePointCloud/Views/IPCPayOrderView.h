//
//  IPCPayOrderView.h
//  IcePointCloud
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPayOrderView : UIView

- (instancetype)initWithFrame:(CGRect)frame SelectEmploye:(void(^)())selectEmploye UpdateOrder:(void(^)())updateOrder;
- (void)reloadData;

@end
