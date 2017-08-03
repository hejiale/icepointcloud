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
        self.currentPage = 1;
    }
    return self;
}

- (NSMutableArray<IPCOptometryMode *> *)optometryList{
    if (!_optometryList) {
        _optometryList = [[NSMutableArray alloc]init];
    }
    return _optometryList;
}

- (void)queryCustomerOptometryList:(void(^)(BOOL canLoadMore))completeBlock
{
    if (self.currentPage == 1) {
        [self.optometryList removeAllObjects];
    }
    [IPCCustomUI show];
    __weak typeof (self) weakSelf = self;
    [IPCCustomerRequestManager queryUserOptometryListWithCustomID:self.customerId
                                                             Page:self.currentPage
                                                     SuccessBlock:^(id responseValue){
                                                         __strong typeof (weakSelf) strongSelf = weakSelf;
                                                         IPCOptometryList * optometryObject = [[IPCOptometryList alloc]initWithResponseValue:responseValue];
                                                         [strongSelf.optometryList addObjectsFromArray:optometryObject.listArray];
                                                         
                                                         if (strongSelf.optometryList.count == 0) {
                                                             [IPCCustomUI showError:@"暂无验光单，请前去添加!"];
                                                         }else{
                                                             [IPCCustomUI hiden];
                                                         }
                                                         if ([optometryObject.listArray count] > 0 && strongSelf.optometryList.count < optometryObject.totalCount) {
                                                             if (completeBlock)
                                                                 completeBlock(YES);
                                                         }else{
                                                             if (completeBlock)
                                                                 completeBlock(NO);
                                                         }
                                                     } FailureBlock:^(NSError *error) {
                                                         if (completeBlock)
                                                             completeBlock(NO);
                                                         [IPCCustomUI showError:error.domain];
                                                     }];
}


- (void)setCurrentOptometry:(NSString *)optometryID Complete:(void (^)())completeBlock
{
    [IPCCustomerRequestManager setDefaultOptometryWithCustomID:self.customerId
                                            DefaultOptometryID:optometryID
                                                  SuccessBlock:^(id responseValue) {
                                                      if (completeBlock) {
                                                          completeBlock();
                                                      }
                                                  } FailureBlock:^(NSError *error) {
                                                      [IPCCustomUI showError:error.domain];
                                                  }];
}


@end
