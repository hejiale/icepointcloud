//
//  IPCCustomerViewMode.h
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCCustomerDetailViewMode : NSObject

@property (strong, nonatomic, readwrite) NSString  * currentOptometryID;//The default number them
@property (strong, nonatomic, readwrite) NSString  * currentAddressID;//The default address
@property (strong, nonatomic, readwrite) NSMutableArray<IPCOptometryMode *> * optometryList;
@property (strong, nonatomic, readwrite) NSMutableArray<IPCCustomerOrderMode *> * orderList;
@property (strong, nonatomic, readwrite) NSMutableArray<IPCCustomerAddressMode *> * addressList;
@property (strong, nonatomic, readwrite) IPCDetailCustomer * detailCustomer;
@property (copy,   nonatomic,  readwrite) NSString  * customerID;
@property (copy,   nonatomic,  readwrite) NSString  * customerPhone;
@property (assign, nonatomic, readwrite) NSInteger  optometryCurrentPage;//It's the current page
@property (assign, nonatomic, readwrite) NSInteger  orderCurrentPage;//Orders for the current page
@property (assign, nonatomic, readwrite) BOOL         isLoadMoreOptometry;//If there are more them all loaded
@property (assign, nonatomic, readwrite) BOOL         isLoadMoreOrder;//If there are more orders to load
@property (assign, nonatomic, readwrite) BOOL         isCanEdit;//Could you edit user information

- (void)isCanChoose:(void(^)(BOOL isCan))isCan;
- (void)queryCustomerDetailInfo:(void(^)())completeBlock;
- (void)queryHistoryOptometryList:(void(^)())completeBlock;
- (void)queryHistotyOrderList:(void(^)())completeBlock;
- (void)queryCustomerAddressList:(void(^)())completeBlock;
- (void)updateUserInfo:(void(^)())completeBlock Failure:(void(^)())failure;


@end
