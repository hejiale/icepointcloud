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
- (void)signinRequestWithUserName:(NSString *)userName Password:(NSString *)password Failed:(void(^)())failed;


/**
 假登录用户  获取版本更新信息
 */
- (void)testLogin;

@end
