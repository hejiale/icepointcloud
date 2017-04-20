//
//  IPCPayOrderViewNormalSellCellMode.h
//  IcePointCloud
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCPayOrderViewCellDelegate.h"
#import "IPCOrder.h"

@interface IPCPayOrderViewMode : NSObject

@property (nonatomic, assign, readwrite) id<IPCPayOrderViewCellDelegate>delegate;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView PayType:(IPCPayOrderType)payType;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section PayType:(IPCPayOrderType)payType;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  PayType:(IPCPayOrderType)payType;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  PayType:(IPCPayOrderType)payType;

/**
 *  Submit a new order
 *
 *  @param cash A credit card or cash
 *  @param ebuy WeChat or pay treasure to pay
 */
- (void)offerOrder;

@end

