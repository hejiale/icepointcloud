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
NSString *const IPCListSearchHistoryKey                      = @"IPCListSearchHistoryKey";
NSString *const IPCNotificationShoppingCartChanged  = @"IPCNotificationShoppingCartChanged";
NSString *const IPCShoppingCartCountKey                   = @"IPCShoppingCartCountKey";
NSString *const IPCSearchCustomerkey                        = @"IPSearchCustomerkey";
NSString *const  IPCChooseWareHouseNotification       = @"IPCChooseWareHouseNotification";
NSString * const kIPCErrorNetworkAlertMessage           = @"请检查您的设备->设置->无线局域网选项";
NSString * const kIPCNotConnectInternetMessage         = @"连接服务出错了，请检查当前网络环境!";

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
    
    NSData *historyData = [NSUserDefaults jk_dataForKey:IPCListSearchHistoryKey];
    
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

- (UIImage *)payTypeImage:(NSString *)payTypeInfo
{
    NSString * imageName = nil;
    
    if ([payTypeInfo isEqualToString:@"现金"]){
        imageName = @"cash";
    }else if ([payTypeInfo isEqualToString:@"储值卡"]){
        imageName = @"storeValue";
    }else if ([payTypeInfo isEqualToString:@"支付宝"]){
        imageName = @"zhifubao";
    }else if ([payTypeInfo isEqualToString:@"微信"]){
        imageName = @"wexin";
    }else if ([payTypeInfo isEqualToString:@"积分"]){
        imageName = @"point";
    }
    return [UIImage imageNamed:imageName];
}

- (NSString *)payType:(NSInteger)index
{
    switch (index) {
        case 0:
            return @"现金";
            break;
        case 1:
            return @"支付宝";
            break;
        case 2:
            return @"微信";
            break;
        case 3:
            return @"刷卡";
            break;
        case 4:
            return @"储值卡";
            break;
        case 5:
            return @"积分";
            break;
        case 6:
            return @"其他";
            break;
        default:
            break;
    }
    return nil;
}

- (void)loadWareHouse:(void (^)(NSError *))complete
{
    __weak typeof(self) weakSelf = self;
    [IPCUserRequestManager queryRepositoryWithSuccessBlock:^(id responseValue)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         strongSelf.wareHouse = [[IPCWareHouseResult alloc]initWithResponseValue:responseValue];
         [strongSelf loadCurrentWareHouse];
         
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
    if (self.storeResult.wareHouseId) {
        IPCWareHouse *  wareHouse = [[IPCWareHouse alloc]init];
        wareHouse.wareHouseId       = self.storeResult.wareHouseId;
        wareHouse.wareHouseName = self.storeResult.wareHouseName;
        self.currentWareHouse = wareHouse;
    }else{
        self.currentWareHouse = self.wareHouse.wareHouseArray[0];
    }
}

- (void)clearData
{
    self.storeResult = nil;
    self.wareHouse = nil;
    self.currentWareHouse = nil;
    self.companyName = nil;
    self.deviceToken = nil;
}


@end
