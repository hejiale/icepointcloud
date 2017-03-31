//
//  IPCAccessorySpecList.h
//  IcePointCloud
//
//  Created by mac on 2017/1/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPCAccessoryBatchNum;
@class IPCAccessoryKindNum;
@class IPCAccessoryExpireDate;
@interface IPCAccessorySpecList : NSObject

@property (nonatomic, strong, readwrite) NSMutableArray<IPCAccessoryBatchNum *> * parameterList;

- (instancetype)initWithResponseObject:(id)responseObject;

@end

@interface IPCAccessoryBatchNum : NSObject

@property (nonatomic, copy, readwrite) NSString *   batchNumber;
@property (nonatomic, strong, readwrite) NSMutableArray<IPCAccessoryKindNum *> * kindNumArray;


@end

@interface IPCAccessoryKindNum : NSObject

@property (nonatomic, copy, readwrite) NSString *  kindNum;
@property (nonatomic, strong, readwrite) NSMutableArray<IPCAccessoryExpireDate *> * expireDateArray;

@end

@interface IPCAccessoryExpireDate: NSObject

@property (nonatomic, copy, readonly) NSString * expireDate;
@property (nonatomic, assign, readonly) NSInteger  stock;

@end


