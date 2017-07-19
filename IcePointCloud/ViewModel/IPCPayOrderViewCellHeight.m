//
//  IPCPayOrderViewCellMode.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/21.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderViewCellHeight.h"

@implementation IPCPayOrderViewCellHeight

- (BOOL)tableViewCell:(NSInteger)section
{
    if ((![IPCCurrentCustomer sharedManager].currentCustomer && section == 1) || ([IPCCurrentCustomer sharedManager].currentCustomer && section == 5))
        return YES;
    else if (((![IPCCurrentCustomer sharedManager].currentCustomer && section == 0) || ([IPCCurrentCustomer sharedManager].currentCustomer && section == 4)) && [IPCPayOrderManager sharedManager].employeeResultArray.count == 0 )
        return YES;
    else if (![IPCCurrentCustomer sharedManager].currentAddress && section == 2 && [IPCCurrentCustomer sharedManager].currentCustomer)
        return YES;
    else if (![IPCCurrentCustomer sharedManager].currentOpometry && section == 3 && [IPCCurrentCustomer sharedManager].currentCustomer)
        return YES;
    return NO;
}

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath
{
    if ([IPCCurrentCustomer sharedManager].currentCustomer) {
        if (indexPath.section == 0 && indexPath.row > 0){
            return 345;
        }else if ((indexPath.section == 1 || indexPath.section == 2) && indexPath.row > 0){
            return 70;
        }else if (indexPath.section == 3 && indexPath.row > 0 ){
            return 160;
        }
    }
    if ((indexPath.section == 0 && indexPath.row > 0 && ![IPCCurrentCustomer sharedManager].currentCustomer) || ([IPCCurrentCustomer sharedManager].currentCustomer && indexPath.section == 4 && indexPath.row > 0))
    {
        return 130;
    }else if ((indexPath.section == 1 && ![IPCCurrentCustomer sharedManager].currentCustomer) || ([IPCCurrentCustomer sharedManager].currentCustomer && indexPath.section == 5))
    {
        return 180;
    }else if ((indexPath.section == 2 && indexPath.row > 0 && ![IPCCurrentCustomer sharedManager].currentCustomer) || ([IPCCurrentCustomer sharedManager].currentCustomer && indexPath.section == 6 && indexPath.row > 0)){
        return [IPCPayOrderManager sharedManager].payTypeRecordArray.count * 50 + ([IPCPayOrderManager sharedManager].isInsertRecordStatus ? 50 : 0) + 50;
    }
    return 50;
}


- (CGFloat)buyProductCellHeight:(NSIndexPath *)indexPath
{
    return 135;
}

@end
