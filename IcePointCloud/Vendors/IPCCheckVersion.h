//
//  IPCCheckVersion.h
//  IcePointCloud
//
//  Created by mac on 2016/12/14.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCVersionModel;
@interface IPCCheckVersion : NSObject

+(IPCCheckVersion *)shardManger;

- (void)checkVersion;

@end

@interface IPCVersionModel : NSObject
/**
 *  Version
 */
@property(nonatomic,copy) NSString * version;

/**
 *  Release Notes
 */
@property(nonatomic,copy)NSString *releaseNotes;

/**
 *  APPId
 */
@property(nonatomic,copy)NSString *trackId;

/**
 *  AppStore address
 */
@property(nonatomic,copy)NSString *trackViewUrl;


@end
