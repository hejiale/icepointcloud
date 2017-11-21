//
//  IPCEmployeeListView.h
//  IcePointCloud
//
//  Created by mac on 2016/11/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCEmployeListView : UIView

- (instancetype)initWithFrame:(CGRect)frame DismissBlock:(void(^)(IPCEmployee *))dismiss;

@end
