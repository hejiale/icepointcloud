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

- (NSString *)userName;
- (void)signinRequestWithUserName:(NSString *)userName Password:(NSString *)password Failed:(void(^)())failed;

@end
