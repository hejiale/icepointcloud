//
//  IPCInsertCustomerViewModel.h
//  IcePointCloud
//
//  Created by gerry on 2017/6/29.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCInsertCustomerViewModel : NSObject

- (void)saveNewCustomer:(void(^)(NSString *customerId))complete;

- (void)judgeCustomerPhone:(NSString *)phone;

- (void)judgeCustomerName:(NSString *)name;

@end
