//
//  IPCCustomerListViewModel.h
//  IcePointCloud
//
//  Created by gerry on 2017/9/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompleteBlock)();

@interface IPCCustomerListViewModel : NSObject

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) NSString * searchWord;
@property (nonatomic, assign) LSRefreshDataStatus status;
@property (nonatomic, copy) CompleteBlock    completeBlock;
@property (nonatomic, strong) NSMutableArray<IPCCustomerMode *> * customerArray;

- (void)queryCustomerList:(void(^)())complete;
- (void)resetData;

@end
