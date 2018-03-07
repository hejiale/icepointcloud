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
- (void)queryCustomerListWithIsChooseStatus:(BOOL)isChooseStatus Complete:(void(^)(NSError *error))complete;


/**
 Query Bind Member CustomerList

 @param complete 
 */
- (void)queryBindMemberCustomer:(void(^)(NSArray * customerList, NSError *error))complete;


/**
 Validation Member

 @param code
 @param complete 
 */
- (void)validationMemberRequest:(NSString *)code Complete:(void(^)(IPCCustomerMode * customer))complete;


/**
  Clear All Data
 */
- (void)resetData;


/**
 Query Member List

 @param complete
 */
- (void)queryMemberList:(void(^)(NSError *error))complete;


/**
 Query Visitor Customer

 @param complete 
 */
- (void)queryVisitorCustomer:(void(^)())complete;


/**
 查询选中客户验光单
 */
- (void)queryCustomerOptometry;

@end
