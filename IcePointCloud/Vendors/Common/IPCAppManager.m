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
NSString *const IPClearSearchwordNotification            = @"IPClearSearchwordNotification";
NSString *const IPCListSearchHistoryKey                      = @"IPCListSearchHistoryKey";
NSString *const IPCSearchKeyWord                              = @"IPCSearchKeyWord";
NSString *const IPCNotificationShoppingCartChanged  = @"IPCNotificationShoppingCartChanged";
NSString *const IPCShoppingCartCountKey                   = @"IPCShoppingCartCountKey";
NSString *const IPCSearchCustomerkey                        = @"IPSearchCustomerkey";
NSString *const IPCHomeSearchProductNotification     = @"IPHomeSearchProductNotification";
NSString *const IPCHomeFilterProductNotification       = @"IPHomeFilterProductNotification";
NSString *const IPCTrySearchProductNotification         = @"IPTrySearchProductNotification";
NSString *const IPCTryFilterProductNotification           = @"IPTryFilterProductNotification";

@implementation IPCAppManager

+ (IPCAppManager *)sharedManager
{
    static IPCAppManager *mgr = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        mgr = [[IPCAppManager alloc] init];
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
        default:
            break;
    }
    return nil;
}

- (void)logout
{
    [IPCAppManager sharedManager].profile = nil;
    [[IPCCurrentCustomerOpometry sharedManager]clearData];
    [[IPCShoppingCart sharedCart] clear];
    [[IPCClient sharedClient] cancelAllRequest];
    
    [[[UIApplication sharedApplication].keyWindow subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[UIApplication sharedApplication].keyWindow setRootViewController:[[IPCLoginViewController alloc]initWithNibName:@"IPCLoginViewController" bundle:nil]];
}


- (NSArray *)localCustomerHistory
{
    __block NSMutableArray * keywordHistory = [[NSMutableArray alloc]init];
    
    NSData *historyData = [NSUserDefaults jk_dataForKey:IPCSearchCustomerkey];
    
    if ([historyData isKindOfClass:[NSData class]]) {
        keywordHistory = [NSKeyedUnarchiver unarchiveObjectWithData:historyData];
    } else {
        keywordHistory = [[NSMutableArray alloc]init];
    }
    return keywordHistory;
}


- (NSArray *)localProductsHistory
{
    __block NSMutableArray * keywordHistory = [[NSMutableArray alloc]init];
    
    NSData *historyData = [NSUserDefaults jk_dataForKey:IPCListSearchHistoryKey];
    
    if ([historyData isKindOfClass:[NSData class]]) {
        keywordHistory = [NSKeyedUnarchiver unarchiveObjectWithData:historyData];
    } else {
        keywordHistory = [[NSMutableArray alloc]init];
    }
    return keywordHistory;
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


+ (NSArray<NSString *> *)batchReadingDegrees{
    NSMutableArray * degreeArray = [[NSMutableArray alloc]init];
    float startDegree =0;
    
    while (startDegree < 6) {
        startDegree += 0.25;
        if (startDegree != 0) {
            [degreeArray addObject:[NSString stringWithFormat:@"+%.2f",startDegree]];
        }
    }
    return degreeArray;
}

+ (NSArray<NSString *> *)batchSphs{
    NSMutableArray * sphArray = [[NSMutableArray alloc]init];
    float startSph = 15.25;
    
    while (startSph > -15) {
        startSph -= 0.25;
        if (startSph > 0) {
            [sphArray addObject:[NSString stringWithFormat:@"+%.2f",startSph]];
        }else{
            [sphArray addObject:[NSString stringWithFormat:@"%.2f",startSph]];
        }
    }
    return sphArray;
}

+ (NSArray<NSString *> *)batchCyls{
    NSMutableArray * cylArray = [[NSMutableArray alloc]init];
    float startCyl = 6.25;
    
    while (startCyl > -6) {
        startCyl -= 0.25;
        if (startCyl > 0) {
            [cylArray addObject:[NSString stringWithFormat:@"+%.2f",startCyl]];
        }else{
            [cylArray addObject:[NSString stringWithFormat:@"%.2f",startCyl]];
        }
    }
    return cylArray;
}

+ (NSArray<NSString *> *)batchDegrees{
    NSMutableArray * degreeArray = [[NSMutableArray alloc]init];
    float startDegree = 0.25;
    
    while (startDegree > -20) {
        startDegree -= 0.25;
        [degreeArray addObject:[NSString stringWithFormat:@"%.2f",startDegree]];
    }
    return degreeArray;
}


+ (NSString *)orderStatus:(NSString *)status{
    if ([status isEqualToString:@"CONFIRMED"]) {
        return  @"已确认";
    }else if ([status isEqualToString:@"DELIVER"]){
        return  @"已发货";
    }else if ([status isEqualToString:@"FINISH"]){
        return  @"已完成";
    }else if ([status isEqualToString:@"RETURN"]){
        return  @"退货中";
    }else if ([status isEqualToString:@"RETURN_FINISH"]){
        return  @"退货完成";
    }else if ([status isEqualToString:@"WAITING_FOR_AUTH"]){
        return  @"待审核";
    }else if ([status isEqualToString:@"WAITING_FOR_PAY_RETAINAGE"]){
        return  @"等待支付尾款";
    }else if ([status isEqualToString:@"WAITING_FOR_STORE_OUT"]){
        return @"等待出库";
    }else if ([status isEqualToString:@"RETURN_GOODS"]){
        return @"已退款";
    }else if ([status isEqualToString:@"FINISH"]){
        return @"已完成";
    }else if ([status isEqualToString:@"WAITING_FOR_PREPARE"]){
        return @"待配货";
    }else if ([status isEqualToString:@"WAITING_FOR_LINKED_STORE_OUT"]){
        return @"待出货";
    }else if ([status isEqualToString:@"LINKED_STORE_HAS_CONFIRMED"]){
        return @"等待发货";
    }else if ([status isEqualToString:@"WAITING_FOR_LINKED_STORE_CONFIRMED"]){
        return @"待商家确认";
    }
    return nil;
}



@end
