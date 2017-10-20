//
//  IPCCustomEditOptometryView.h
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCEditOptometryView : UIView

- (instancetype)initWithFrame:(CGRect)frame CustomerID:(NSString *)customerID Complete:(void(^)(NSString *))complete Dismiss:(void(^)())dismiss;

@end