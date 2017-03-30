//
//  IPCGlassParameterViewMode.m
//  IcePointCloud
//
//  Created by mac on 2016/11/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCBatchParameterViewMode.h"

@interface IPCBatchParameterViewMode()

@property (nonatomic, strong) IPCGlasses * glasses;

@end

@implementation IPCBatchParameterViewMode

- (instancetype)initWithGlasses:(IPCGlasses *)glasses IsPreSell:(BOOL)isPreSell
{
    self = [super init];
    if (self) {
        self.glasses = glasses;
        if ([self.glasses filterType] == IPCTopFilterTypeContactLenses && !isPreSell)
            [self queryBatchContactDegreeRequest];
    }
    return self;
}

- (NSMutableArray<BatchParameterObject *> *)contactDegreeList{
    if (!_contactDegreeList)
        _contactDegreeList = [[NSMutableArray alloc]init];
    return _contactDegreeList;
}

#pragma mark //Network Request
- (void)queryBatchContactDegreeRequest
{
    [self.contactDegreeList removeAllObjects];
    if (self.glasses.stock <= 0)return;
    
    [IPCBatchRequestManager queryBatchContactProductsStockWithLensID:self.glasses.glassesID
                                                        SuccessBlock:^(id responseValue)
     {
         IPCBatchParameterList * batchParameterList = [[IPCBatchParameterList alloc]initWithResponseObject:responseValue];
         [batchParameterList.parameterList enumerateObjectsUsingBlock:^(BatchParameterObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [self.contactDegreeList addObject:obj];
         }];
     } FailureBlock:^(NSError *error) {
         [IPCUIKit showError:error.userInfo[kIPCNetworkErrorMessage]];
     }];
}

- (void)getContactLensSpecification:(NSString *)contactLensID CompleteBlock:(void(^)())complete
{
    if (contactLensID) {
        [IPCBatchRequestManager queryContactGlassBatchSpecification:@[contactLensID]
                                                       SuccessBlock:^(id responseValue)
         {
             IPCContactLenSpecList * contactSpecification = [[IPCContactLenSpecList alloc]initWithResponseObject:responseValue ContactLensID:contactLensID];
             _contactLensMode = [[IPCContactLensMode alloc]initWithResponseObject:contactSpecification.parameterList];
             if (complete) {
                 complete();
             }
         } FailureBlock:^(NSError *error) {
             [IPCUIKit showError:error.userInfo[kIPCNetworkErrorMessage]];
         }];
    }
}

- (void)getAccessorySpecification:(NSString *)glassID CompleteBlock:(void(^)())complete
{
    [IPCBatchRequestManager queryAccessoryBatchSpecification:glassID
                                                SuccessBlock:^(id responseValue)
     {
         _accessorySpecification = [[IPCAccessorySpecList alloc]initWithResponseObject:responseValue];
         if (complete) {
             complete();
         }
     } FailureBlock:^(NSError *error) {
         [IPCUIKit showError:error.userInfo[kIPCNetworkErrorMessage]];
     }];
}


#pragma mark //To obtain the corresponding batch number specifications for contact lenses
- (NSArray *)batchNumArray{
    __block NSMutableArray * nameArray = [[NSMutableArray alloc]init];
    [self.contactLensMode.batchArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [nameArray addObject:obj[@"batchNum"]];
    }];
    return nameArray;
}

- (NSArray *)kindNumArray:(NSString *)batchNum{
    __block NSMutableArray * nameArray = [[NSMutableArray alloc]init];
    [self.contactLensMode.batchArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"batchNum"] isEqualToString:batchNum]) {
            [obj[@"kindList"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull kindDic, NSUInteger idx, BOOL * _Nonnull stop) {
                [nameArray addObject:kindDic[@"kind"]];
            }];
        }
    }];
    return nameArray;
}

- (NSArray *)validityDateArray:(NSString *)batchNum KindNum:(NSString *)kindNum
{
    __block NSMutableArray * nameArray = [[NSMutableArray alloc]init];
    [self.contactLensMode.batchArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"batchNum"] isEqualToString:batchNum]) {
            [obj[@"kindList"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull kindDic, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([kindDic[@"kind"] isEqualToString:kindNum]) {
                    [kindDic[@"dateList"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dateDic, NSUInteger idx, BOOL * _Nonnull stop) {
                        [nameArray addObject:dateDic];
                    }];
                }
            }];
        }
    }];
    return nameArray;
}

- (NSArray *)accessoryBatchNumArray{
    __block NSMutableArray * batchNumArray = [[NSMutableArray alloc]init];
    [self.accessorySpecification.parameterList enumerateObjectsUsingBlock:^(IPCAccessoryBatchNum * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [batchNumArray addObject:obj.batchNumber];
    }];
    return batchNumArray;
}


- (NSArray *)accessoryKindNumArray:(NSString *)batchNum{
    __block NSMutableArray * kindNumArray = [[NSMutableArray alloc]init];
    [self.accessorySpecification.parameterList enumerateObjectsUsingBlock:^(IPCAccessoryBatchNum * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.batchNumber isEqualToString:batchNum]) {
            [obj.kindNumArray enumerateObjectsUsingBlock:^(IPCAccessoryKindNum * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [kindNumArray addObject:obj.kindNum];
            }];
        }
    }];
    return kindNumArray;
}


- (NSArray *)accessoryValidityDateArray:(NSString *)batchNum KindNum:(NSString *)kindNum{
    __block NSMutableArray * dateArray = [[NSMutableArray alloc]init];
    [self.accessorySpecification.parameterList enumerateObjectsUsingBlock:^(IPCAccessoryBatchNum * _Nonnull batchMode, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([batchMode.batchNumber isEqualToString:batchNum]) {
            [batchMode.kindNumArray enumerateObjectsUsingBlock:^(IPCAccessoryKindNum * _Nonnull kindMode, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([kindMode.kindNum isEqualToString:kindNum]) {
                    [kindMode.expireDateArray enumerateObjectsUsingBlock:^(IPCAccessoryExpireDate * _Nonnull dateMode, NSUInteger idx, BOOL * _Nonnull stop) {
                        [dateArray addObject:dateMode.expireDate];
                    }];
                }
            }];
        }
    }];
    return dateArray;
}

- (NSInteger)accessoryStock:(NSString *)batchNum KindNum:(NSString *)kindNum Date:(NSString *)date
{
    __block NSInteger stock = 0;
    [self.accessorySpecification.parameterList enumerateObjectsUsingBlock:^(IPCAccessoryBatchNum * _Nonnull batchMode, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([batchMode.batchNumber isEqualToString:batchNum]) {
            [batchMode.kindNumArray enumerateObjectsUsingBlock:^(IPCAccessoryKindNum * _Nonnull kindMode, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([kindMode.kindNum isEqualToString:kindNum]) {
                    [kindMode.expireDateArray enumerateObjectsUsingBlock:^(IPCAccessoryExpireDate * _Nonnull dateMode, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([dateMode.expireDate isEqualToString:date]) {
                            stock = dateMode.stock;
                            *stop = YES;
                        }
                    }];
                }
            }];
        }
    }];
    return stock;
}

@end
