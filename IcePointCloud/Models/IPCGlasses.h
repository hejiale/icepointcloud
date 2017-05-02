//
//  Glass.h
//  IcePointCloud
//
//  Created by mac on 7/19/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPCGlassesImage.h"

@interface IPCGlasses : NSObject

@property (nonatomic, strong, readwrite) IPCGlassesImage *profileDisplayImage;
@property (nonatomic, strong, readwrite) IPCGlassesImage *frontialDisplayImage;
@property (nonatomic, strong, readwrite) IPCGlassesImage *frontialTryOnImage;
@property (nonatomic, strong, readwrite) IPCGlassesImage *degreeAngleImage;
@property (nonatomic, strong, readwrite) IPCGlassesImage *thumbImage;

@property (nonatomic, copy, readonly) NSString * glassName;//name
@property (nonatomic, copy, readonly) NSString * glassesID;// id
@property (nonatomic, copy, readonly) NSString * glassCode;//Commodity item no
@property (nonatomic, copy, readonly) NSString * detailLinkURl;//Details about the link

@property (nonatomic,assign, readonly) NSInteger stock;//inventory
@property (nonatomic, copy, readonly) NSString * supplierName;//supplier

@property (nonatomic, copy, readonly) NSString * brand;//brand
@property (nonatomic, copy, readonly) NSString * color;//color
@property (nonatomic, copy, readonly) NSString * style;//style
@property (nonatomic, assign, readonly) double   price;//Recommended retail price
@property (nonatomic, assign, readonly) double   prodPrice;//The actual price
@property (nonatomic, assign, readonly) double  afterDiscountPrice;//折后价
@property (nonatomic, assign, readonly) BOOL    integralExchange;//判断是否积分兑换
@property (nonatomic, assign, readonly) double  exchangeIntegral;

@property (nonatomic, copy, readonly) NSString * frameColor;//Frame color
@property (nonatomic, copy, readonly) NSString * lensColor;//Lens color
@property (nonatomic, copy, readonly) NSString * function;//function
@property (nonatomic, copy, readonly) NSString * lensType;//The lens piece type
@property (nonatomic, copy, readonly) NSString * material;//The material
@property (nonatomic, copy, readonly) NSString * pd;//pd
@property (nonatomic, copy, readonly) NSString * border;//A border
@property (nonatomic, copy, readonly) NSString * refractiveIndex;//The refractive index
@property (nonatomic, copy, readonly) NSString * membraneLayer;//Membrane layer
@property (nonatomic, copy, readonly) NSString * sph;//SPH
@property (nonatomic, copy, readonly) NSString * cyl;//CYL
@property (nonatomic, copy, readonly) NSString * cycle;//cycle
@property (nonatomic, copy, readonly) NSString * specification;//specifications
@property (nonatomic, copy, readonly) NSString * degree;//degree
@property (nonatomic, copy, readonly) NSString * batchDegree;//batchdegree
@property (nonatomic, copy, readonly) NSString * baseOfArc;//The base of arc
@property (nonatomic, copy, readonly) NSString * watercontent;//The water content
@property (nonatomic, copy, readonly) NSString * type;//type
@property (nonatomic, copy, readonly) NSString * version;//version
@property (nonatomic, assign, readonly) NSInteger productCount;//The order quantity
@property (nonatomic, copy, readonly) NSString * thumbnailURL;//Thumbnail url
@property (nonatomic, assign, readonly) BOOL  isBatch;//Whether the batch
@property (nonatomic, assign, readonly) BOOL  isTryOn;//If you can try
@property (nonatomic, copy, readonly) NSString * approvalNumber;//A kind
@property (nonatomic, copy, readonly) NSString * batchNumber;//Batch no.
@property (nonatomic, copy, readonly) NSString * expireDate;//The period of validity
@property (nonatomic, assign, readonly) BOOL     solutionType;

- (IPCGlassesImage *)imageWithType:(IPCGlassesImageType)type;
- (IPCTopFilterType)filterType;
- (NSString *)glassId;
- (NSDictionary *)displayFields;

@end
