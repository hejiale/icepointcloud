//
//  IPCAppManager.h
//  IcePointCloud
//
//  Created by mac on 9/18/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//


#import "IPCStoreResult.h"
#import "IPCWareHouseResult.h"

//The App for the first time login
extern NSString *const IPCFirstLanuchKey;
//The current logged in user records
extern NSString* const IPCUserNameKey;
//Store all your login history record Key
extern NSString *const IPCListLoginHistoryKey;
//Keep records of commodity search key
extern NSString *const IPCListSearchHistoryKey;
//Save search Key users
extern NSString *const IPCSearchCustomerkey;
//Inform the screening homepage search goods
//Shopping cart change notification
extern NSString *const IPCNotificationShoppingCartChanged;
extern NSString *const IPCShoppingCartCountKey;
//Choose Customer notification
extern NSString *const  IPCChooseCustomerNotification;
//Choose WareHouse notification
extern NSString *const  IPCChooseWareHouseNotification;
//Error Networking Status Message
extern NSString * const kIPCErrorNetworkAlertMessage;

@interface IPCAppManager : NSObject

@property (nonatomic, copy, readwrite)  NSString * companyName;
@property (nonatomic, copy, readwrite) NSString * deviceToken;
@property (nonatomic, strong)    IPCStoreResult * storeResult;
@property (nonatomic, strong)    IPCWareHouseResult * wareHouse;
@property (nonatomic, strong)    IPCWareHouse * currentWareHouse;

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
 *  PayTypeInfo Image Name
 */
- (UIImage *)payTypeImage:(NSString *)payTypeInfo;


/**
 * Load WareHouse

 @param complete 
 */
- (void)loadWareHouse:(void(^)(NSError * error))complete;


@end
