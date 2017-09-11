//
//  IPCPlatformService.m
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPlatformService.h"
#import "IPCCheckVersion.h"


@implementation IPCPlatformService

- (instancetype)init{
    self = [super init];
    if (self) {
        [self checkNetwork];
        [self checkVersion];
        [self enableFace];
        [self enableSkin];
        [self enableKeyboard];
        [self bindWechat];
    }
    return self;
}

/**
 *  Check Version
 */
- (void)checkVersion{
    [[IPCCheckVersion shardManger] checkVersion];
}

/**
 *  Add the keyboard to track
 */
- (void)enableKeyboard{
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

/**
 * Binding WeChat
 */
- (void)bindWechat{
    [WXApi registerApp:IPCWeixinAppID withDescription:@"冰点云"];
}

/**
 * Skin care
 */
- (void)enableSkin{
    [TuSDK initSdkWithAppKey:IPCTuSdkKey];
}


/**
 *  Face Detector
 */
- (void)enableFace{
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",IPCIflyFaceDetectorKey];
    [IFlySpeechUtility createUtility:initString];
}

/**
 *  Check Network
 */
- (void)checkNetwork
{
    [[IPCReachability manager] monitoringNetwork:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
            [IPCCommonUI showInfo:kIPCErrorNetworkAlertMessage];
        }
    }];
}


#pragma mark //WXApiDelegate
- (void)onReq:(BaseReq *)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]]){
        GetMessageFromWXReq *temp = (GetMessageFromWXReq *)req;
        /**
         *  WeChat request App content, need to App to provide content after use sendRsp returns
         */
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@", temp.openID];
        [IPCCommonUI showAlert:strTitle Message:strMsg];
    }else if([req isKindOfClass:[ShowMessageFromWXReq class]]){
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        /**
         *  Displays the contents of a WeChat over there
         */
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%zu bytes\n附加消息:%@\n", temp.openID, msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length, msg.messageExt];
        [IPCCommonUI showAlert:strTitle Message:strMsg];
    }else if([req isKindOfClass:[LaunchFromWXReq class]]){
        LaunchFromWXReq *temp = (LaunchFromWXReq *)req;
        WXMediaMessage *msg = temp.message;
        /**
         *  From WeChat start the App
         */
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", temp.openID, msg.messageExt];
        [IPCCommonUI showAlert:strTitle Message:strMsg];
    }
}

- (void)onResp:(BaseResp *)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]]){
        if (resp.errCode == WXSuccess) {
            [IPCCommonUI showInfo:@"发送图片成功!"];
        }else if(resp.errCode == WXErrCodeSentFail){
            [IPCCommonUI showInfo:@"发送图片失败!"];
        }else if (resp.errCode == WXErrCodeUserCancel){
            [IPCCommonUI showInfo:@"取消分享!"];
        }
    }
}

@end
