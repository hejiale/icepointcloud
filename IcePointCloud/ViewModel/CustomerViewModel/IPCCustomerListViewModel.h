//
//  IPCCustomerListViewModel.h
//  IcePointCloud
//
//  Created by gerry on 2017/9/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompleteBlock)(NSError *error);

@interface IPCCustomerListViewModel : NSObject

@property (nonatomic, copy) CompleteBlock    completeBlock;
//Search Customer Data
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) NSString * searchWord;
//Refresh Status
@property (nonatomic, assign) LSRefreshDataStatus status;

@property (nonatomic, strong) NSMutableArray<IPCCustomerMode *> * customerArray;


/**
  Load Customer List Data
 */
- (void)queryCustomerList:(void(^)(NSError *error))complete;


/**
 Query Customer Detail

 @param complete 
 */
- (void)queryCustomerDetailWithStatus:(BOOL)isChoose CustomerId:(NSString *)customerId Complete:(void(^)(IPCDetailCustomer * customer))complete;


/**
 Validation Member

 @param code
 @param complete 
 */
- (void)validationMemberRequest:(NSString *)code Complete:(void(^)())complete;


/**
  Clear All Data
 */
- (void)resetData;

@end
