//
//  IPCProfileResult.h
//  IcePointCloud
//
//  Created by mac on 7/31/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCUser.h"

@interface IPCProfileResult : NSObject

@property (nonatomic, strong, readwrite) IPCUser *user;
@property (nonatomic, copy, readonly) NSString *token;
@property (nonatomic, copy, readonly) NSString *company;
@property (nonatomic, copy, readonly) NSString *QRCodeURL;
@property (nonatomic, copy, readonly) NSString *headImageURL;
@property (nonatomic, copy, readonly) NSString *deviceToken;

@end
