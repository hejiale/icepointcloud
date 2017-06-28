//
//  IPCProfileResult.h
//  IcePointCloud
//
//  Created by mac on 7/31/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

@interface IPCProfileResult : NSObject

@property (nonatomic, copy, readonly) NSString *token;
@property (nonatomic, copy, readonly) NSString *company;
@property (nonatomic, copy, readonly) NSString *QRCodeURL;
@property (nonatomic, copy, readonly) NSString *headImageURL;
@property (nonatomic, copy, readonly) NSString *deviceToken;
@property (nonatomic, copy, readonly) NSString *storeName;
@property (nonatomic, copy, readonly) NSString *userID;
@property (nonatomic, copy, readwrite) NSString *contacterName;
@property (nonatomic, copy, readwrite) NSString *contacterPhone;

@end
