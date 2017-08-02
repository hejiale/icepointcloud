//
//  IPCCustomerViewMode.h
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCCustomerDetailViewMode : NSObject

@property (strong, nonatomic, readwrite) NSMutableArray<IPCOptometryMode *> * optometryList;
@property (strong, nonatomic, readwrite) NSMutableArray<IPCCustomerOrderMode *> * orderList;
@property (strong, nonatomic, readwrite) NSMutableArray<IPCCustomerAddressMode *> * addressList;
@property (strong, nonatomic, readwrite) IPCDetailCustomer * detailCustomer;
@property (strong, nonatomic, readwrite)  IPCCustomerMode * currentCustomer;
@property (assign, nonatomic, readwrite) NSInteger  orderCurrentPage;//Orders for the current page
@property (assign, nonatomic, readwrite) BOOL         isLoadMoreOrder;//If there are more orders to load


- (void)resetData;
- (void)queryCustomerDetailInfo:(void(^)())completeBlock;
- (void)queryHistoryOptometryList:(void(^)())completeBlock;
- (void)queryHistotyOrderList:(void(^)())completeBlock;
- (void)queryCustomerAddressList:(void(^)())completeBlock;

@end
