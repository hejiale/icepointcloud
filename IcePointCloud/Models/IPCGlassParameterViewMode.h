//
//  IPCGlassParameterViewMode.h
//  IcePointCloud
//
//  Created by mac on 2016/11/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCGlassParameterViewMode : NSObject

@property (strong, nonatomic) NSMutableArray<BatchParameterObject *> * contactDegreeList;
@property (strong, nonatomic) IPCContactLensMode * contactLensMode;
@property (strong, nonatomic) IPCAccessorySpecList * accessorySpecification;

- (instancetype)initWithGlasses:(IPCGlasses *)glasses IsPreSell:(BOOL)isPreSell;

- (void)queryBatchContactDegreeRequest;
- (void)getContactLensSpecification:(NSString *)degreeID CompleteBlock:(void(^)())complete;
- (void)getAccessorySpecification:(NSString *)glassID CompleteBlock:(void(^)())complete;

///Contact Lens
- (NSArray *)batchNumArray;
- (NSArray *)kindNumArray:(NSString *)batchNum;
- (NSArray *)validityDateArray:(NSString *)batchNum KindNum:(NSString *)kindNum;

///Accessory
- (NSArray *)accessoryBatchNumArray;
- (NSArray *)accessoryKindNumArray:(NSString *)batchNum;
- (NSArray *)accessoryValidityDateArray:(NSString *)batchNum KindNum:(NSString *)kindNum;
- (NSInteger)accessoryStock:(NSString *)batchNum KindNum:(NSString *)kindNum Date:(NSString *)date;

@end
