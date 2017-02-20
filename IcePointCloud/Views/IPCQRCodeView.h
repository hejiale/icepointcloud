//
//  QRCodeView.h
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCQRCodeView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;
@property (copy, nonatomic) void(^CloseBlock)(void);

- (void)showWithClose:(void(^)())closeBlock;

@end
