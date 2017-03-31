//
//  IPCUser.h
//  IcePointCloud
//
//  Created by mac on 7/31/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

@interface IPCUser : NSObject

@property (nonatomic, copy, readonly) NSString *userID;
@property (nonatomic, copy, readwrite) NSString *contactName;
@property (nonatomic, copy, readwrite) NSString *contactMobilePhone;


@end
