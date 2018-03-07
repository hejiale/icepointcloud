//
//  IPCPayOrderPayTypeList.h
//  IcePointCloud
//
//  Created by gerry on 2017/12/7.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCPayOrderPayType : NSObject

@property (nonatomic, copy) NSString *  companyId;
@property (nonatomic, copy) NSString *  payType;
@property (nonatomic, copy) NSString *  payTypeId;
@property (nonatomic, assign) BOOL      configStatus;//是否禁用

@end

