//
//  ShareManager.m
//  IcePointCloud
//
//  Created by mac on 16/9/14.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCShareManager.h"

@implementation IPCShareManager


- (void)shareToChat:(UIImage *)pendingImage Scene:(int)scene
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        WXMediaMessage *message = [WXMediaMessage message];
        [message setThumbImage:[pendingImage jk_imageScaledToFitSize:CGSizeMake(100, 100)]];
        
        WXImageObject *ext = [WXImageObject object];
        ext.imageData = UIImageJPEGRepresentation(pendingImage, 1);
        
        message.mediaObject = ext;
        message.mediaTagName = @"mediaTagName";
        message.messageExt = @"messageExt";
        message.messageAction = @"<action>dotalist</action>";
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene;
        
        [WXApi sendReq:req];
    } else {
        [IPCUIKit showError:@"请安装最新版本的微信后重试"];
    }
}


@end
