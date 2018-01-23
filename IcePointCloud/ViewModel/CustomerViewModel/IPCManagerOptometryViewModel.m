//
//  IPCManagerOptometryViewModel.m
//  IcePointCloud
//
//  Created by gerry on 2017/7/4.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCManagerOptometryViewModel.h"

@implementation IPCManagerOptometryViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSMutableArray<IPCOptometryMode *> *)optometryList{
    if (!_optometryList) {
        _optometryList = [[NSMutableArray alloc]init];
    }
    return _optometryList;
}

- (void)queryCustomerOptometryList:(void(^)())completeBlock
{
    __weak typeof (self) weakSelf = self;
    [IPCCustomerRequestManager queryUserOptometryListWithCustomID:self.customerId
                                                     SuccessBlock:^(id responseValue){
                                                         __strong typeof (weakSelf) strongSelf = weakSelf;
                                                         IPCOptometryList * optometryObject = [[IPCOptometryList alloc]initWithResponseValue:responseValue];
                                                         [strongSelf.optometryList addObjectsFromArray:optometryObject.listArray];
                                                         [IPCCommonUI hiden];
                                                         
                                                         if (completeBlock)
                                                             completeBlock();
                                                     } FailureBlock:^(NSError *error) {
                                                         if (completeBlock)
                                                             completeBlock();
                                                         if ([error code] != NSURLErrorCancelled) {
                                                             [IPCCommonUI showError:error.domain];
                                                         }
                                                         
                                                     }];
}


- (void)setCurrentOptometry:(NSString *)optometryID Complete:(void (^)())completeBlock
{
    [IPCCommonUI showInfo:@"正在设置默认验光单..."];
    
    [IPCCustomerRequestManager setDefaultOptometryWithCustomID:self.customerId
                                            DefaultOptometryID:optometryID
                                                  SuccessBlock:^(id responseValue) {
                                                      [IPCCommonUI hiden];
                                                      if (completeBlock) {
                                                          completeBlock();
                                                      }
                                                  } FailureBlock:^(NSError *error) {
                                                      if ([error code] !=NSURLErrorCancelled) {
                                                          [IPCCommonUI showError:error.domain];
                                                      }else{
                                                          [IPCCommonUI hiden];
                                                      }
                                                      
                                                  }];
}


@end
