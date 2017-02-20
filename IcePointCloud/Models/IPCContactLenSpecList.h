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

@property (nonatomic, copy) NSString * contactLensID;
@property (nonatomic, copy) NSString * degree;
@property (nonatomic, strong) NSMutableArray<IPCContactLenSpec *> * parameterList;

- (instancetype)initWithResponseObject:(id)responseObject ContactLensID:(NSString *)contactLensID;

@end

@interface IPCContactLenSpec : NSObject

@property (nonatomic, copy) NSString *   approvalNumber;
@property (nonatomic, copy) NSString *   batchNumber;
@property (nonatomic, copy) NSString *   expireDate;
@property (nonatomic, assign) NSInteger bizStock;

@end
