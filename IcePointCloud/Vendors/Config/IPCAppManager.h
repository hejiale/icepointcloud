//
//  IPCAppManager.h
//  IcePointCloud
//
//  Created by mac on 9/18/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//


#import "IPCStoreResult.h"
#import "IPCWareHouseResult.h"
#import "IPCPriceStrategyResult.h"
#import "IPCCustomTextField.h"
#import "IPCCompanyConfig.h"

//The App for the first time login
extern NSString *const IPCFirstLanuchKey;
//The current logged in user records
extern NSString* const IPCUserNameKey;
//Store all your login history record Key
extern NSString *const IPCListLoginHistoryKey;
//Keep records of commodity search key
extern NSString *const IPCSearchHistoryListKey;
//Save search Key users
extern NSString *const IPCSearchCustomerkey;
//Inform the screening homepage search goods
//Shopping cart change notification
extern NSString *const IPCNotificationShoppingCartChanged;
extern NSString *const IPCShoppingCartCountKey;
//Choose WareHouse notification
extern NSString *const  IPCChooseWareHouseNotification;
//Error Networking Status Message
extern NSString * const kIPCErrorNetworkAlertMessage;
extern NSString * const kIPCNotConnectInternetMessage;
//Choose Price Strategy
extern NSString * const IPCChoosePriceStrategyNotification;
//Device UUID
extern NSString * const kIPCDeviceLoginUUID;

@interface IPCAppManager : NSObject

@property (nonatomic, copy, readwrite)       NSString                   * deviceToken;
@property (nonatomic, strong, readwrite)    IPCStoreResult          * storeResult;
@property (nonatomic, strong, readwrite)    IPCWareHouseResult * wareHouse;
@property (nonatomic, strong, readwrite)    IPCWareHouse           * currentWareHouse;
@property (nonatomic, strong, readwrite)    IPCPriceStrategyResult * priceStrategy;
@property (nonatomic, strong, readwrite)    IPCPriceStrategy        * currentStrategy;
@property (nonatomic, strong, readwrite)    IPCCompanyConfig   * companyCofig;

+ (IPCAppManager *)sharedManager;

/**
 *  Glasses Property Class Type
 */
- (NSString *)classType:(IPCTopFilterType)type;

- (NSString *)classTypeName:(IPCTopFilterType)type;

/**
 *  Log out
 */
- (void)logout;

/**
 * To keep their clients' search for local records
 */
- (NSArray *)localCustomerHistory;

/**
 *  For local search records
 */
- (NSArray *)localProductsHistory;


/**
 * Login Account Name
 */
- (NSArray *)loginAccountHistory;

/**
 *  Access to different location of the model photos
 */
+ (UIImage *)modelPhotoWithType:(IPCModelType)type usage:(IPCModelUsage)usage;


/**
 Query Employee Account

 @param complete 
 */
- (void)queryEmployeeAccount:(void(^)(NSError *))complete;

/**
 * Load WareHouse

 @param complete 
 */
- (void)loadWareHouse:(void(^)(NSError * error))complete;


/**
 * Load PriceStrategy

 @param complete 
 */
- (void)queryPriceStrategy:(void (^)(NSError *error))complete;


/**
   Load Company Config
 */
- (void)getCompanyConfig:(void (^)(NSError *error))complete;


/**
 Get Auth

 @param complete 
 */
- (void)getAuths:(void(^)(NSError *))complete;


@end
