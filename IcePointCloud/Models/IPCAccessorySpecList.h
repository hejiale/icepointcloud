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

@property (nonatomic, strong) NSMutableArray<IPCAccessoryBatchNum *> * parameterList;

- (instancetype)initWithResponseObject:(id)responseObject;

@end

@interface IPCAccessoryBatchNum : NSObject

@property (nonatomic, copy) NSString *   batchNumber;
@property (nonatomic, strong) NSMutableArray<IPCAccessoryKindNum *> * kindNumArray;


@end

@interface IPCAccessoryKindNum : NSObject

@property (nonatomic, copy) NSString *  kindNum;
@property (nonatomic, strong) NSMutableArray<IPCAccessoryExpireDate *> * expireDateArray;

@end

@interface IPCAccessoryExpireDate: NSObject

@property (nonatomic, copy) NSString * expireDate;
@property (nonatomic, assign) NSInteger  stock;

@end


