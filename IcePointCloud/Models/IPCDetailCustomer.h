//
//  DetailCustomerObject.h
//  IcePointCloud
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCDetailCustomer : NSObject

@property (nonatomic, copy, readwrite) NSString * customerID;
@property (nonatomic, copy, readwrite) NSString * birthday;
@property (nonatomic, copy, readwrite) NSString * remark;
@property (nonatomic, copy, readwrite) NSString * customerPhone;
@property (nonatomic, copy, readwrite) NSString * photo_uuid;
@property (nonatomic, copy, readwrite) NSString * photo_url;
@property (nonatomic, copy, readwrite) NSString * currentOptometryId;
@property (nonatomic, copy, readwrite) NSString * email;
@property (nonatomic, copy, readwrite) NSString * contactorGengerString;
@property (nonatomic, copy, readwrite) NSString * customerAddress;
@property (nonatomic, copy, readwrite) NSString * genderString;
@property (nonatomic, copy, readwrite) NSString * customerName;
@property (nonatomic, copy, readwrite) NSString * contactorAddress;
@property (nonatomic, copy, readwrite) NSString * currentAddressId;
@property (nonatomic, copy, readwrite) NSString * contactorPhone;
@property (nonatomic, copy, readwrite) NSString * lastPhoneReturn;
@property (nonatomic, copy, readwrite) NSString * memberLevel;
@property (nonatomic, copy, readwrite) NSString * membergrowth;
@property (nonatomic, copy, readwrite) NSString * consumptionAmount;
@property (nonatomic, copy, readwrite) NSString * balance;
@property (nonatomic, copy, readwrite) NSString * createDate;
@property (nonatomic, copy, readwrite) NSString * customerType;
@property (nonatomic, copy, readwrite) NSString * empName;
@property (nonatomic, copy, readonly) NSString * memberId;
@property (nonatomic, copy, readonly) NSString * integral;
@property (nonatomic, copy, readwrite) NSString * occupation;

@end
