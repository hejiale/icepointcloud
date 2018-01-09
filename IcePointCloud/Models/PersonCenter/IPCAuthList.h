//
//  IPCAuthList.h
//  IcePointCloud
//
//  Created by gerry on 2018/1/9.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCForceVerifyMember;
@interface IPCAuthList : NSObject

@property (nonatomic, copy) IPCForceVerifyMember * forceVerifyMember;

@end

@interface IPCForceVerifyMember : NSObject

@property (nonatomic, copy) NSString * authorityName;
@property (nonatomic, assign) BOOL   adminAuth;
@property (nonatomic, assign) BOOL   check;
@property (nonatomic, copy) NSString * authorityCode;
@property (nonatomic, copy) NSString * orderNum;
@property (nonatomic, copy) NSString * parentOrderNum;

@end
