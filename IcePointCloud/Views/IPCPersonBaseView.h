//
//  PersonBaseView.h
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCPersonBaseView : UIView

- (void)showWithLogout:(void(^)())logout
           UpdateBlock:(void(^)())update
           QRCodeBlock:(void(^)())qrcode
             HelpBlock:(void(^)())help;

- (void)dismiss:(void(^)())complete;

@end
