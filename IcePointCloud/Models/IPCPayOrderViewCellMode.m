//
//  IPCPayOrderViewCellMode.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/21.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderViewCellMode.h"

@implementation IPCPayOrderViewCellMode

- (CGFloat)buyProductCellHeight:(NSIndexPath *)indexPath
{
//    if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens || [IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedContactLens){
//        if (indexPath.row == 1) {
//            return 120;
//        }else if (indexPath.row == 2){
//            if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens) {
//                if ([IPCCustomsizedItem sharedItem].rightEye.otherArray.count > 1) {
//                    return 460 + ([IPCCustomsizedItem sharedItem].rightEye.otherArray.count - 1) * 50;
//                }
//                return 460;
//            }else{
//                if ([IPCCustomsizedItem sharedItem].rightEye.otherArray.count > 1) {
//                    return 320 + ([IPCCustomsizedItem sharedItem].rightEye.otherArray.count - 1) * 50;
//                }
//                return 320;
//            }
//        }else{
//            if ([IPCCustomsizedItem sharedItem].payOrderType == IPCPayOrderTypeCustomsizedLens) {
//                if ([IPCCustomsizedItem sharedItem].leftEye.otherArray.count > 1) {
//                    return 400 + ([IPCCustomsizedItem sharedItem].leftEye.otherArray.count - 1) * 50;
//                }
//                return 400;
//            }else{
//                if ([IPCCustomsizedItem sharedItem].leftEye.otherArray.count > 1) {
//                    return 260 + ([IPCCustomsizedItem sharedItem].leftEye.otherArray.count - 1) * 50;
//                }
//                return 260;
//            }
//        }
//    }
    return 135;
}

@end