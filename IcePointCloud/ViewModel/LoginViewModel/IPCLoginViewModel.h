//
//  IPCLoginViewModel.h
//  IcePointCloud
//
//  Created by gerry on 2017/11/7.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCLoginViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<NSString *> * loginHistory;


/**
 记录上一次登录账户

 @return 
 */
- (NSString *)userName;


/**
 Login

 @param userName
 @param password
 @param failed 
 */
- (void)signinRequestWithUserName:(NSString *)userName
                         Password:(NSString *)password
                       NeedVality:(void(^)())need
                           Failed:(void(^)())failed;


/**
 获取公司相关信息
 */
- (void)loadConfigData;


/**
  激活设备登录

 @param code
 @param complete 
 */
- (void)valityActiveCode:(NSString *)code;
@end
