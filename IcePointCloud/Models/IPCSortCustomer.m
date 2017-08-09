//
//  IPCSortCustomer.m
//  IcePointCloud
//
//  Created by gerry on 2017/8/8.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCSortCustomer.h"

@implementation IPCSortCustomer

+ (NSMutableArray *)PinYingData:(NSMutableArray<IPCCustomerMode *> *)array
{
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    NSArray *serializeArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSString *strA = [self transform:((IPCCustomerMode *)obj1).customerName];
        NSString *strB = [self transform:((IPCCustomerMode *)obj2).customerName];
        if (NSOrderedDescending==[strA compare:strB])
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (NSOrderedAscending==[strA compare:strB])
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
        
    }];
    
    char lastC = '1';
    NSMutableArray *data;
    NSMutableArray *oth = [[NSMutableArray alloc] init];
    for (IPCCustomerMode *PinYing in serializeArray) {
        char c = [[self transform:PinYing.customerName]  characterAtIndex:0];
        
        if (!isalpha(c)) {
            [oth addObject:PinYing];
        }
        else if (c != lastC){
            lastC = c;
            if (data && data.count > 0) {
                [ans addObject:data];
            }
            
            data = [[NSMutableArray alloc] init];
            [data addObject:PinYing];
        }
        else {
            [data addObject:PinYing];
        }
    }
    if (data && data.count > 0) {
        [ans addObject:data];
    }
    if (oth.count > 0) {
        [ans addObject:oth];
    }
    
    return ans;
    
}

+ (NSMutableArray *)PinYingSection:(NSMutableArray<IPCCustomerMode *> *)array
{
    NSMutableArray *section = [[NSMutableArray alloc] init];
    
    for (NSArray *item in array) {
        IPCCustomerMode *PinYing = [item objectAtIndex:0];
        char c = [[self transform:PinYing.customerName] characterAtIndex:0];
        
        if (!isalpha(c)) {
            c = '#';
        }
        [section addObject:[NSString stringWithFormat:@"%c", toupper(c)]];
    }
    return section;
}
+ (NSString *)transform:(NSString *)chinese
{
    if (chinese.length) {
        NSMutableString *pinyin = [chinese mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
        return [pinyin uppercaseString];
    }
    return @"#";
}


@end
