//
//  IPCCustomerViewMode.h
//  IcePointCloud
//
//  Created by mac on 2016/12/16.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCCustomerDetailViewMode : NSObject

@property (strong, nonatomic) NSString  * currentOptometryID;//The default number them
@property (strong, nonatomic) NSString  * currentAddressID;//The default address
@property (strong, nonatomic) NSMutableArray<IPCOptometryMode *> * optometryList;
@property (strong, nonatomic) NSMutableArray<IPCCustomerOrderMode *> * orderList;
@property (strong, nonatomic) NSMutableArray<IPCCustomerAddressMode *> * addressList;
@property (strong, nonatomic) IPCDetailCustomer * detailCustomer;
@property (copy,   nonatomic)  NSString  * customerID;
@property (copy,   nonatomic)  NSString  * customerPhone;
@property (nonatomic) NSInteger  optometryCurrentPage;//It's the current page
@property (nonatomic) NSInteger  orderCurrentPage;//Orders for the current page
@property (nonatomic) BOOL         isLoadMoreOptometry;//If there are more them all loaded
@property (nonatomic) BOOL         isLoadMoreOrder;//If there are more orders to load
@property (nonatomic) BOOL         isCanEdit;//Could you edit user information

- (void)isCanChoose:(void(^)(BOOL isCan))isCan;
- (void)queryCustomerDetailInfo:(void(^)())completeBlock;
- (void)queryHistoryOptometryList:(void(^)())completeBlock;
- (void)queryHistotyOrderList:(void(^)())completeBlock;
- (void)queryCustomerAddressList:(void(^)())completeBlock;
- (void)updateUserInfo:(void(^)())completeBlock Failure:(void(^)())failure;


@end
