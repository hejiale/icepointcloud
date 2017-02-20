//
//  IPCBatchRequestManager.h
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCRequestManager.h"

@interface IPCBatchRequestManager : IPCRequestManager

/**
 *  QUERY BATCH LENS STOCK
 *
 *  @param lenID
 *  @param success
 *  @param failure
 */
+ (void)queryBatchLensProductsStockWithLensID:(NSString *)lenID
                                 SuccessBlock:(void (^)(id responseValue))success
                                 FailureBlock:(void (^)(NSError * error))failure;

/**
 *  QUERY BATCH READING LENS STOCK
 *
 *  @param lenID
 *  @param success
 *  @param failure
 */
+ (void)queryBatchReadingProductsStockWithLensID:(NSString *)lenID
                                    SuccessBlock:(void (^)(id responseValue))success
                                    FailureBlock:(void (^)(NSError * error))failure;

/**
 *  QUERY CONTACT LENS STOCK
 *
 *  @param lenID
 *  @param success
 *  @param failure
 */
+ (void)queryBatchContactProductsStockWithLensID:(NSString *)lenID
                                    SuccessBlock:(void (^)(id responseValue))success
                                    FailureBlock:(void (^)(NSError * error))failure;

/**
 *  QUERY CONTACT LENS SPECIFICATION
 *
 *  @param contactLensID
 *  @param success
 *  @param failure
 */
+ (void)queryContactGlassBatchSpecification:(NSArray *)contactLensID
                               SuccessBlock:(void (^)(id responseValue))success
                               FailureBlock:(void (^)(NSError *error))failure;

/**
 *  QUERY  ACCESSORY  SPECIFICATION
 *
 *  @param productID
 *  @param success
 *  @param failure
 */
+ (void)queryAccessoryBatchSpecification:(NSString *)lenID
                            SuccessBlock:(void (^)(id responseValue))success
                            FailureBlock:(void (^)(NSError *error))failure;



@end
