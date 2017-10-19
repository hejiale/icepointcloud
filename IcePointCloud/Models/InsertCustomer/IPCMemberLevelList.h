//
//  IPCMemberLevelList.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/13.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCMemberLevel;
@interface IPCMemberLevelList : NSObject

@property (nonatomic, strong, readwrite) NSMutableArray<IPCMemberLevel *> * list;

- (instancetype)initWithResponseValue:(id)responseValue;

@end

@interface IPCMemberLevel : NSObject

@property (nonatomic, copy, readonly) NSString * memberLevel;
@property (nonatomic, copy, readonly) NSString * integralRatio;
@property (nonatomic, copy, readonly) NSString * growthstartpoint;
@property (nonatomic, copy, readonly) NSString * discount;
@property (nonatomic, copy, readonly) NSString * memberLevelId;

@end
