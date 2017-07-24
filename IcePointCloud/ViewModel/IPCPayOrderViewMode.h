//
//  IPCPayOrderViewNormalSellCellMode.h
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCPayOrderViewModelDelegate.h"

@interface IPCPayOrderViewMode : NSObject

@property (nonatomic, assign, readwrite) id<IPCPayOrderViewModelDelegate>delegate;

- (void)queryCustomerDetailWithCustomerId:(NSString *)customerId;

- (void)requestTradeOrExchangeStatus:(void(^)())complete;

/**
 * Judge Is Can Pay Order

 */
- (BOOL)isCanPayOrder;
/**
 *   UITableView DataSource \ Delegate
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Submit a new order
 *
 *  @param cash A credit card or cash
 *  @param ebuy WeChat or pay treasure to pay
 */
- (void)offerOrder;
- (void)resetPayInfoData;

@end

