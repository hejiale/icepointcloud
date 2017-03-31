//
//  IPCAppManager.h
//  IcePointCloud
//
//  Created by mac on 9/18/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//


#import "IPCProfileResult.h"

//The App for the first time login
extern NSString *const IPCFirstLanuchKey;
//The current logged in user records
extern NSString* const IPCUserNameKey;
//Store all your login history record Key
extern NSString *const IPCListLoginHistoryKey;
//Keep records of commodity search key
extern NSString *const IPCListSearchHistoryKey;
//Notify the save search key
extern NSString *const IPCSearchKeyWord;
//Empty the search box
extern NSString *const IPClearSearchwordNotification;
//Save search Key users
extern NSString *const IPCSearchCustomerkey;
//Inform the screening homepage search goods
extern NSString *const IPCHomeSearchProductNotification;
extern NSString *const IPCHomeFilterProductNotification;
//Try to search for goods notice screening
extern NSString *const IPCTrySearchProductNotification;
extern NSString *const IPCTryFilterProductNotification;
//Shopping cart change notification
extern NSString *const IPCNotificationShoppingCartChanged;
extern NSString *const IPCShoppingCartCountKey;

@interface IPCAppManager : NSObject

@property (nonatomic, strong)    IPCProfileResult * profile;


+ (IPCAppManager *)sharedManager;

/**
 *  Glasses Property Class Type
 */
- (NSString *)classType:(IPCTopFilterType)type;
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
 *  Access to different location of the model photos
 */
+ (UIImage *)modelPhotoWithType:(IPCModelType)type usage:(IPCModelUsage)usage;

/**
 *  Bulk power range
 */
+ (NSArray<NSString *> *)batchReadingDegrees;

+ (NSArray<NSString *> *)batchSphs;

+ (NSArray<NSString *> *)batchCyls;

+ (NSArray<NSString *> *)batchDegrees;

/**
 *  The order status
 */
+ (NSString *)orderStatus:(NSString *)status;


@end