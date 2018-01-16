//
//  IPCPlatformService.m
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPlatformService.h"
#import "IPCCheckVersion.h"
#import "UncaughtExceptionHandler.h"

@implementation IPCPlatformService

+ (IPCPlatformService *)instance
{
    static IPCPlatformService * service = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        service = [[self alloc] init];
    });
    return service;
}

- (void)setUp
{
    [self checkNetwork];
    [self checkVersion];
    [self enableFace];
    [self enableSkin];
    [self enableKeyboard];
    [self bindWechat];
    [self setUpBugtags];
    [self sendExpection];
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

- (void)setUpBugtags
{
    [Bugtags startWithAppKey:IPCBugtagsKey invocationEvent:BTGInvocationEventNone];
    [Bugtags setTrackingNetwork:YES];
    [Bugtags sync:YES];
    
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
            [IPCCommonUI showError:kIPCErrorNetworkAlertMessage];
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
            [IPCCommonUI showSuccess:@"发送图片成功!"];
        }else if(resp.errCode == WXErrCodeSentFail){
            [IPCCommonUI showError:@"发送图片失败!"];
        }else if (resp.errCode == WXErrCodeUserCancel){
            [IPCCommonUI showError:@"取消分享!"];
        }
    }
}

- (void)sendExpection
{
    InstallUncaughtExceptionHandler().showAlert(NO).logFileHandle(^(NSString *path) {
        //处理完成后调用（如果不调用则程序不会退出）主要是为了处理耗时操作
        ExceptionHandlerFinishNotify();
    }).showExceptionInfor(NO).didClick(^(NSString *ExceptionMessage){
        //将崩溃信息上传到服务器，该字符串为：异常信息
        [Bugtags sendException:[NSException exceptionWithName:@"程序闪退" reason:ExceptionMessage userInfo:nil]];
    }).message(nil).title(nil);
}

@end
