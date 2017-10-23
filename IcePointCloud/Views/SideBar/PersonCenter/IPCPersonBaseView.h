//
//  PersonBaseView.h
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPersonBaseView : UIView

@property (nonatomic, assign) BOOL  isHiden;

- (void)showWithLogout:(void(^)())logout
           UpdateBlock:(void(^)())update
           QRCodeBlock:(void(^)())qrcode
        WareHouseBlock:(void(^)())wareHouse;

- (void)reload;
- (void)dismiss:(void(^)())complete;


@end
