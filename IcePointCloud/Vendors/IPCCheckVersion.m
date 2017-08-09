//
//  IPCCheckVersion.m
//  IcePointCloud
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCCheckVersion.h"


@implementation IPCCheckVersion


+(IPCCheckVersion *)shardManger
{
    static IPCCheckVersion *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[super alloc] init];
    });
    return instance;
}


- (void)checkVersion{
    if ( ! [NSUserDefaults jk_boolForKey:IPCFirstLanuchKey])return;
    
    [self getAppStoreVersion:^(IPCVersionModel *model) {
        if (model) {
            [IPCCommonUI showAlert:@"有新版本更新" Message:model.releaseNotes Owner:[[UIApplication sharedApplication] keyWindow].rootViewController Done:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.trackViewUrl]];
            }];
        }
    }];
}


-(void)getAppStoreVersion:(void(^)(IPCVersionModel * model))versionInfo
{
    __weak typeof(self) weakSelf = self;
    [self sendVersionRequestSuccess:^(NSDictionary *responseDict){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if([responseDict[@"resultCount"] integerValue]==1){
            NSArray *resultArray = responseDict[@"results"];
            NSDictionary *result = resultArray.firstObject;
            IPCVersionModel  * appInfo = [IPCVersionModel mj_objectWithKeyValues:result];
            
            if([[strongSelf jk_version] compare:appInfo.version options:NSNumericSearch]==NSOrderedAscending){
                if (versionInfo) {
                    versionInfo(appInfo);
                }
            }
        }
    }];
}



#pragma mark //Request Events
-(void)sendVersionRequestSuccess:(void (^)(NSDictionary * responseDict))success
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@",[self jk_identifier]]];
    
    [NSURLConnection jk_sendAsynchronousRequestAcceptingAllCerts:[NSURLRequest requestWithURL:URL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        if(!error){
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if(success) success(responseDict);
        }
    }];
}

@end


@implementation IPCVersionModel


@end


