//
//  IPCProfileResult.h
//  IcePointCloud
//
//  Created by mac on 7/31/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCUser.h"

@interface IPCProfileResult : NSObject

@property (nonatomic, strong) IPCUser *user;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *QRCodeURL;
@property (nonatomic, copy) NSString *headImageURL;
@property (nonatomic, copy) NSString *deviceToken;

@end
