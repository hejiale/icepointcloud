//
//  IPCInsertCustomer.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/12.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCInsertCustomer : NSObject

+ (IPCInsertCustomer *)instance;

- (void)resetData;

- (BOOL)isEmpty;

@property (nonatomic, copy, readwrite) NSString * photo_udid;//头像
@property (nonatomic, copy, readwrite) NSString * customerName;
@property (nonatomic, copy, readwrite) NSString * genderString;
@property (nonatomic, copy, readwrite) NSString * gender;//MALE   FEMALE
@property (nonatomic, copy, readwrite) NSString * customerPhone;
@property (nonatomic, copy, readwrite) NSString * memberNum;//会员号
@property (nonatomic, copy, readwrite) NSString * memberLevel;//会员级别
@property (nonatomic, copy, readwrite) NSString * memberLevelId;//会员级别ID
@property (nonatomic, copy, readwrite) NSString * customerType;//顾客类别
@property (nonatomic, copy, readwrite) NSString * customerTypeId;//顾客类别ID
@property (nonatomic, copy, readwrite) NSString * introducerId;//介绍客户ID
@property (nonatomic, copy, readwrite) NSString * introducerName;//介绍客户
@property (nonatomic, copy, readwrite) NSString * introducerInteger;//介绍客户赠送积分
@property (nonatomic, copy, readwrite) NSString * job;//职业
@property (nonatomic, copy, readwrite) NSString * birthday;
@property (nonatomic, copy, readwrite) NSString * email;
@property (nonatomic, copy, readwrite) NSString * remark;
@property (nonatomic, copy, readwrite) NSString * contactorName;//联系人
@property (nonatomic, copy, readwrite) NSString * contactorAddress;//联系地址
@property (nonatomic, copy, readwrite) NSString * contactorPhone;//联系电话
@property (nonatomic, copy, readwrite) NSString * contactorGengerString;
@property (nonatomic, copy, readwrite) NSString * contactorGenger;
@property (nonatomic, assign, readwrite) BOOL     isInsertStatus;
@property (nonatomic, assign, readwrite) BOOL     isPackUp;
@property (nonatomic, copy, readwrite) NSMutableArray<IPCOptometryMode *> * optometryArray;

@end
