//
//  PersonBaseView.h
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPersonBaseView : IPCPersonContentView

- (instancetype)initWithFrame:(CGRect)frame
                       Logout:(void(^)())logout
                  UpdateBlock:(void(^)())update
               WareHouseBlock:(void(^)())wareHouse
           PriceStrategyBlock:(void(^)())priceStrategy;

@end
