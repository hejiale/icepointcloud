//
//  IPCAppManager.m
//  IcePointCloud
//
//  Created by mac on 9/18/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCAppManager.h"
#import "IPCLoginViewController.h"

NSString *const IPCFirstLanuchKey                               = @"IPFirstLanucKey";
NSString* const IPCUserNameKey                                 = @"UserNameKey";
NSString *const IPCListLoginHistoryKey                        = @"IPCListLoginHistoryKey";
NSString *const IPCSearchHistoryListKey                      = @"IPCSearchGlassesHistoryListKey";
NSString *const IPCNotificationShoppingCartChanged  = @"IPCNotificationShoppingCartChanged";
NSString *const IPCShoppingCartCountKey                   = @"IPCShoppingCartCountKey";
NSString *const IPCSearchCustomerkey                        = @"IPSearchCustomerHistoryListkey";
NSString *const  IPCChooseWareHouseNotification       = @"IPCChooseWareHouseNotification";
NSString * const IPCChoosePriceStrategyNotification   = @"IPCChoosePriceStrategyNotification";
NSString * const kIPCDeviceLoginUUID                          = @"IPCDeviceLoginUUID";
NSString * const kIPCErrorNetworkAlertMessage           = @"请检查您的设备->设置->无线局域网选项，并重新登录!";
NSString * const kIPCNotConnectInternetMessage         = @"连接服务出错了，请检查当前网络环境，并重新登录!";

@implementation IPCAppManager

+ (IPCAppManager *)sharedManager
{
    static IPCAppManager *mgr = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        mgr = [[self alloc] init];
    });
    return mgr;
}

- (NSString *)classType:(IPCTopFilterType)type{
    switch (type)
    {
        case IPCTopFIlterTypeFrames:
            return @"FRAMES";
        case IPCTopFilterTypeLens:
            return @"LENS";
        case IPCTopFilterTypeSunGlasses:
            return @"SUNGLASSES";
        case IPCTopFilterTypeCustomized:
            return @"CUSTOMIZED";
        case IPCTopFilterTypeReadingGlass:
            return @"READING_GLASSES";
        case IPCTopFilterTypeContactLenses:
            return @"CONTACT_LENSES";
        case IPCTopFilterTypeAccessory:
            return @"ACCESSORY";
        case IPCTopFilterTypeOthers:
            return @"OTHERS";
        default:
            break;
    }
    return nil;
}


- (NSString *)classTypeName:(IPCTopFilterType)type
{
    switch (type)
    {
        case IPCTopFIlterTypeFrames:
            return @"镜架";
        case IPCTopFilterTypeLens:
            return @"镜片";
        case IPCTopFilterTypeSunGlasses:
            return @"太阳眼镜";
        case IPCTopFilterTypeCustomized:
            return @"定制类眼镜";
        case IPCTopFilterTypeReadingGlass:
            return @"老花眼镜";
        case IPCTopFilterTypeContactLenses:
            return @"隐形眼镜";
        case IPCTopFilterTypeAccessory:
            return @"配件";
        case IPCTopFilterTypeOthers:
            return @"其它";
        default:
            break;
    }
    return nil;
}


- (void)logout
{
    ///Clear All Data & Clear HTTP Request
    [[IPCAppManager sharedManager] clearData];
    [[IPCTryMatch instance] clearData];
    [[IPCPayOrderManager sharedManager] resetData];
    [[IPCHttpRequest sharedClient] cancelAllRequest];
    
    IPCLoginViewController * loginVc = [[IPCLoginViewController alloc]initWithNibName:@"IPCLoginViewController" bundle:nil];
    [[[UIApplication sharedApplication] delegate].window setRootViewController:loginVc];
}

///Load Search Customer Keywords In LocalDatabase
- (NSArray *)localCustomerHistory
{
    __block NSArray * keywordHistory = [[NSMutableArray alloc]init];
    
    NSData *historyData = [NSUserDefaults jk_dataForKey:IPCSearchCustomerkey];
    
    if ([historyData isKindOfClass:[NSData class]]) {
        keywordHistory = [NSKeyedUnarchiver unarchiveObjectWithData:historyData];
    } else {
        keywordHistory = [[NSArray alloc]init];
    }
    return keywordHistory;
}

///Load Search Product Keywords In LocalDatabase
- (NSArray *)localProductsHistory
{
    __block NSArray * keywordHistory = [[NSMutableArray alloc]init];
    
    NSData *historyData = [NSUserDefaults jk_dataForKey:IPCSearchHistoryListKey];
    
    if ([historyData isKindOfClass:[NSData class]]) {
        keywordHistory = [NSKeyedUnarchiver unarchiveObjectWithData:historyData];
    } else {
        keywordHistory = [[NSArray alloc]init];
    }
    return keywordHistory;
}

///Load Login Account History In LocalDatabase
- (NSArray *)loginAccountHistory
{
    __block NSArray * accountHistory = [[NSMutableArray alloc]init];
    
    NSData *historyData = [NSUserDefaults jk_dataForKey:IPCListLoginHistoryKey];
    
    if ([historyData isKindOfClass:[NSData class]]) {
        accountHistory = [NSKeyedUnarchiver unarchiveObjectWithData:historyData];
    } else {
        accountHistory = [[NSArray alloc]init];
    }
    return accountHistory;
}


+ (UIImage *)modelPhotoWithType:(IPCModelType)type usage:(IPCModelUsage)usage
{
    int index = type;
    NSString *suffix = nil;
    
    switch (usage) {
        case IPCModelUsageCompareMode:
            suffix = @"mid";
            break;
        case IPCModelUsageSingleMode:
            suffix = @"large";
            break;
        default:
            break;
    }
    
    if (suffix) {
        NSString *imgName = [NSString stringWithFormat:@"model%i_%@", index, suffix];
        return [UIImage imageNamed:imgName];
    }
    return nil;
}

- (void)queryEmployeeAccount:(void(^)(NSError *))complete
{
    [IPCUserRequestManager queryEmployeeAccountWithSuccessBlock:^(id responseValue){
        //Query Responsity WareHouse
        [IPCAppManager sharedManager].storeResult = [IPCStoreResult mj_objectWithKeyValues:responseValue];
        [IPCAppManager sharedManager].storeResult.employee = [IPCEmployee mj_objectWithKeyValues:responseValue];
        [[IPCPayOrderManager sharedManager] resetEmployee];
        
        if (complete) {
            complete(nil);
        }
    } FailureBlock:^(NSError *error) {
        if (complete) {
            complete(error);
        }
    }];
}

- (void)loadWareHouse:(void (^)(NSError *))complete
{
    [IPCUserRequestManager queryRepositoryWithSuccessBlock:^(id responseValue)
     {
         [IPCAppManager sharedManager].wareHouse = [[IPCWareHouseResult alloc]initWithResponseValue:responseValue];
 
         if (complete) {
             complete(nil);
         }
     } FailureBlock:^(NSError *error) {
         if (complete) {
             complete(error);
         }
     }];
}

- (void)queryPriceStrategy:(void (^)(NSError *))complete
{
    [IPCGoodsRequestManager queryPriceStrategyWithSuccessBlock:^(id responseValue) {
        [IPCAppManager sharedManager].priceStrategy = [[IPCPriceStrategyResult alloc]initWithResponseValue:responseValue];
        [IPCAppManager sharedManager].currentStrategy = self.priceStrategy.strategyArray[0];
        
        if (complete) {
            complete(nil);
        }
    } FailureBlock:^(NSError *error) {
        if (complete) {
            complete(error);
        }
    }];
}

- (void)getCompanyConfig:(void (^)(NSError *))complete
{
    [IPCPayOrderRequestManager getCompanyConfigWithSuccessBlock:^(id responseValue)
     {
         [IPCAppManager sharedManager].companyCofig = [IPCCompanyConfig mj_objectWithKeyValues:responseValue];
         
         if (complete) {
             complete(nil);
         }
     } FailureBlock:^(NSError *error) {
         if (complete) {
             complete(error);
         }
     }];
}

- (void)loadCurrentWareHouse
{
    if ([IPCAppManager sharedManager].storeResult) {
        IPCWareHouse *  wareHouse = [[IPCWareHouse alloc]init];
        wareHouse.wareHouseId       = [IPCAppManager sharedManager].storeResult.wareHouseId;
        wareHouse.wareHouseName = [IPCAppManager sharedManager].storeResult.wareHouseName;
        [IPCAppManager sharedManager].currentWareHouse = wareHouse;
    }else{
        [IPCAppManager sharedManager].currentWareHouse = [IPCAppManager sharedManager].wareHouse.wareHouseArray[0];
    }
}


- (void)clearData
{
    [IPCAppManager sharedManager].storeResult = nil;
    [IPCAppManager sharedManager].wareHouse = nil;
    [IPCAppManager sharedManager].currentWareHouse = nil;
    [IPCAppManager sharedManager].deviceToken = nil;
    [IPCAppManager sharedManager].priceStrategy = nil;
    [IPCAppManager sharedManager].currentStrategy = nil;
    [IPCAppManager sharedManager].companyCofig = nil;
}


@end
