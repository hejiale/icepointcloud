//
//  ContactLenSpecificationList.m
//  IcePointCloud
//
//  Created by mac on 16/9/29.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCContactLenSpecList.h"

@implementation IPCContactLenSpecList

- (instancetype)initWithResponseObject:(id)responseObject ContactLensID:(NSString *)contactLensID{
    self = [super init];
    if (self) {
        self.contactLensID = contactLensID;
        
        NSDictionary * degreeDic = responseObject[contactLensID];
        
        if ([degreeDic isKindOfClass:[NSDictionary class]])
        {
            if ([degreeDic[@"details"] isKindOfClass:[NSArray class]]) {
                [degreeDic[@"details"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    IPCContactLenSpec * parameter = [IPCContactLenSpec mj_objectWithKeyValues:obj];
                    [self.parameterList addObject:parameter];
                }];
            }
        }
    }
    return self;
}


- (NSMutableArray<IPCContactLenSpec *> *)parameterList{
    if (!_parameterList)
        _parameterList = [[NSMutableArray alloc]init];
    return _parameterList;
}

@end


@implementation IPCContactLenSpec



@end
