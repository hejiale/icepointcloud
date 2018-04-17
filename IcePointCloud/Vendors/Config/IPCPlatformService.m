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
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


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
    /*[self sendExpection];*/
    [self avoidCrash];
    [self setUpBugly];
    [self setUpCrashlytics];
}

/**
 *  Check Version
 */
- (void)checkVersion{
    //    [[IPCCheckVersion shardManger] checkVersion];
    
    ///延时获取更新版本内容
    [self performSelector:@selector(testLogin) withObject:nil afterDelay:1.f];
}

- (void)testLogin{
    __weak typeof(self) weakSelf = self;
    [IPCUserRequestManager userLoginWithUserName:LOGINACCOUNT Password:PASSWORD SuccessBlock:^(id responseValue) {
        [weakSelf queryAppMessage];
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)queryAppMessage
{
    __weak typeof(self) weakSelf = self;
    [IPCUserRequestManager getAppMessageWithSuccessBlock:^(id responseValue)
     {
         if ([responseValue isKindOfClass:[NSArray class]]) {
             NSString * title = responseValue[0][@"content"];
             NSString * newVersion = responseValue[1][@"content"];
             NSString * updateContent = responseValue[2][@"content"];
             
             if([[weakSelf jk_version] compare:newVersion options:NSNumericSearch]==NSOrderedAscending){
                 
                 [IPCCustomAlertView showWithTitle:title Message:updateContent CancelTitle:@"返回" SureTitle:@"更新" Done:^{
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://fir.im/icepointCloud"]];
                 } Cancel:nil];
             }
         }
     } FailureBlock:^(NSError *error) {
         
     }];
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


- (void)setUpBugly
{
    BuglyConfig * config = [[BuglyConfig alloc]init];
    config.blockMonitorEnable = YES;
    config.unexpectedTerminatingDetectionEnable = YES;
    config.reportLogLevel = BuglyLogLevelWarn;
    
    [Bugly startWithAppId:@"026c927c44" config:config];
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

/*- (void)sendExpection
{
    InstallUncaughtExceptionHandler().showAlert(NO).logFileHandle(^(NSString *path) {
        //处理完成后调用（如果不调用则程序不会退出）主要是为了处理耗时操作
        ExceptionHandlerFinishNotify();
    }).showExceptionInfor(NO).didClick(^(NSString *ExceptionMessage){
        //将崩溃信息上传到服务器，该字符串为：异常信息
        [Bugtags sendException:[NSException exceptionWithName:@"程序闪退" reason:ExceptionMessage userInfo:nil]];
        [Bugly reportError:[NSError errorWithDomain:@"程序闪退" code:9998 userInfo:@{NSLocalizedDescriptionKey: ExceptionMessage}]];
    }).message(nil).title(nil);
}*/

- (void)avoidCrash
{
    [AvoidCrash makeAllEffective];
    
    NSArray *noneSelClassStrings = @[
                                     @"NSString"
                                     ];
    [AvoidCrash setupNoneSelClassStringsArr:noneSelClassStrings];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
}

- (void)dealwithCrashMessage:(NSNotification *)note
{
    NSString * user =  [NSString stringWithFormat:@"%@#%@", [IPCAppManager sharedManager].userName, [IPCAppManager sharedManager].password];
    NSString * exception = [NSString stringWithFormat:@"%@#%@", user, note.userInfo];
    
    [Bugly reportError:[NSError errorWithDomain:@"程序闪退" code:9998 userInfo:@{NSLocalizedDescriptionKey: exception}]];
}


/**
 测试用
 */
- (void)setUpCrashlytics
{
    [Fabric with:@[[Crashlytics class]]];
//    [Crashlytics sharedInstance].debugMode = YES;
}


@end
