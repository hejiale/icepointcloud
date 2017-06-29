//
//  IPCGlassParameterViewMode.h
//  IcePointCloud
//
//  Created by mac on 2016/11/22.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPCBatchParameterViewMode : NSObject

@property (strong, nonatomic, readwrite) NSMutableArray<BatchParameterObject *> * contactDegreeList;
@property (strong, nonatomic, readwrite) IPCContactLensMode * contactLensMode;
@property (strong, nonatomic, readwrite) IPCAccessorySpecList * accessorySpecification;

- (instancetype)initWithGlasses:(IPCGlasses *)glasses;

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
