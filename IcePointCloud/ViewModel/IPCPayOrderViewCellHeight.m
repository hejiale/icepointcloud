//
//  IPCPayOrderViewCellMode.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/21.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderViewCellHeight.h"

@implementation IPCPayOrderViewCellHeight

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
    }else if ((indexPath.section == 1 && indexPath.row > 0 && ![IPCCurrentCustomer sharedManager].currentCustomer) || ([IPCCurrentCustomer sharedManager].currentCustomer && indexPath.section == 5 && indexPath.row > 0))
    {
        return [self buyProductCellHeight:indexPath];
    }else if ((indexPath.section == 2 && ![IPCCurrentCustomer sharedManager].currentCustomer) || ([IPCCurrentCustomer sharedManager].currentCustomer && indexPath.section == 6))
    {
        return 180;
    }else if ((indexPath.section == 3 && indexPath.row > 0 && ![IPCCurrentCustomer sharedManager].currentCustomer) || ([IPCCurrentCustomer sharedManager].currentCustomer && indexPath.section == 7 && indexPath.row > 0)){
        return [IPCPayOrderManager sharedManager].payTypeRecordArray.count * 50 + ([IPCPayOrderManager sharedManager].isInsertRecordStatus ? 50 : 0) + 50;
    }
    return 50;
}


- (CGFloat)buyProductCellHeight:(NSIndexPath *)indexPath
{
    if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens || [IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedContactLens)
    {
        if (indexPath.row == 1) {
            return 120;
        }else if (indexPath.row == 2){
            if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens) {
                if ([IPCCustomsizedItem sharedItem].rightEye.otherArray.count > 1) {
                    return 355 + ([IPCCustomsizedItem sharedItem].rightEye.otherArray.count - 1) * 50;
                }
                return 355;
            }else{
                if ([IPCCustomsizedItem sharedItem].rightEye.otherArray.count > 1) {
                    return 200 + ([IPCCustomsizedItem sharedItem].rightEye.otherArray.count - 1) * 50;
                }
                return 200;
            }
        }else if(indexPath.row == 3 && [IPCCustomsizedItem sharedItem].customsizdType == IPCCustomsizedTypeLeftOrRightEye){
            if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens) {
                if ([IPCCustomsizedItem sharedItem].leftEye.otherArray.count > 1) {
                    return 310 + ([IPCCustomsizedItem sharedItem].leftEye.otherArray.count - 1) * 50;
                }
                return 310;
            }else{
                if ([IPCCustomsizedItem sharedItem].leftEye.otherArray.count > 1) {
                    return 150 + ([IPCCustomsizedItem sharedItem].leftEye.otherArray.count - 1) * 50;
                }
                return 150;
            }
        }
    }
    return 135;
}

@end
