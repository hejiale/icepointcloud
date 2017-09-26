//
//  IPCGoodsRequestManager.h
//  IcePointCloud
//
//  Created by mac on 2016/12/30.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCRequest.h"

@interface IPCGoodsRequestManager : IPCRequest

/**
 *  QUERY PRODUCT SPECIFICATION
 *
 *  @param type
 *  @param key
 *  @param success
 *  @param failure
 */
+ (void)getAllCateTypeWithType:(NSString *)type
                     FilterKey:(NSDictionary *)key
                  SuccessBlock:(void (^)(id responseValue))success
                  FailureBlock:(void (^)(NSError * error))failure;

/**
 *  QUERY GLASSLIST
 *
 *  @param page
 *  @param searchWord
 *  @param classType
 *  @param searchType
 *  @param startPrice
 *  @param endPrice
 *  @param isHot
 *  @param success
 *  @param failure
 */
+ (void)queryFilterGlassesListWithPage:(NSInteger)page
                            SearchWord:(NSString *)searchWord
                             ClassType:(NSString *)classType
                            SearchType:(NSDictionary *)searchType
                            StartPrice:(double)startPrice
                              EndPrice:(double)endPrice
                              IsTrying:(BOOL)isTrying
                               StoreId:(NSString *)storeId
                          SuccessBlock:(void (^)(id responseValue))success
                          FailureBlock:(void (^)(NSError * error))failure;


/**
  QUERY RECOMMD GLASSES

 @param classType
 @param style
 @param success
 @param failure 
 */
+ (void)queryRecommdGlassesWithClassType:(NSString *)classType
                                   Style:(NSString *)style
                            SuccessBlock:(void (^)(id responseValue))success
                            FailureBlock:(void (^)(NSError * error))failure;


/**
 QUERY Repository

 @param success
 @param failure 
 */
+ (void)queryRepositoryWithSuccessBlock:(void (^)(id responseValue))success
                           FailureBlock:(void (^)(NSError * error))failure;

@end
