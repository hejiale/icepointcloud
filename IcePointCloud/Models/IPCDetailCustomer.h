//
//  DetailCustomerObject.h
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCDetailCustomer : NSObject

@property (nonatomic, copy) NSString * customerID;
@property (nonatomic, copy) NSString * birthday;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * customerPhone;
@property (nonatomic, copy) NSString * photo_uuid;
@property (nonatomic, copy) NSString * photo_url;
@property (nonatomic, copy) NSString * currentOptometryId;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * contactorGengerString;
@property (nonatomic, copy) NSString * customerAddress;
@property (nonatomic, copy) NSString * genderString;
@property (nonatomic, copy) NSString * customerName;
@property (nonatomic, copy) NSString * contactorAddress;
@property (nonatomic, copy) NSString * currentAddressId;
@property (nonatomic, copy) NSString * contactorPhone;
@property (nonatomic, copy) NSString * age;

@end
