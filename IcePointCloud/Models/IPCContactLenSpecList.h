//
//  ContactLenSpecificationList.h
//  IcePointCloud
//
//  Created by mac on 16/9/29.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCContactLenSpec;
@interface IPCContactLenSpecList : NSObject

@property (nonatomic, copy, readwrite) NSString * contactLensID;

@property (nonatomic, strong) NSMutableArray<IPCContactLenSpec *> * parameterList;

- (instancetype)initWithResponseObject:(id)responseObject ContactLensID:(NSString *)contactLensID;

@end

@interface IPCContactLenSpec : NSObject

@property (nonatomic, copy, readonly) NSString *   approvalNumber;
@property (nonatomic, copy, readonly) NSString *   batchNumber;
@property (nonatomic, copy, readonly) NSString *   expireDate;
@property (nonatomic, assign, readonly) NSInteger bizStock;

@end
