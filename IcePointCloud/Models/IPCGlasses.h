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

@property (nonatomic, strong) IPCGlassesImage *profileDisplayImage;
@property (nonatomic, strong) IPCGlassesImage *frontialDisplayImage;
@property (nonatomic, strong) IPCGlassesImage *frontialTryOnImage;
@property (nonatomic, strong) IPCGlassesImage *degreeAngleImage;
@property (nonatomic, strong) IPCGlassesImage *thumbImage;

@property (nonatomic, copy) NSString * glassName;//name
@property (nonatomic, copy) NSString * glassesID;// id
@property (nonatomic, copy) NSString * glassCode;//Commodity item no
@property (nonatomic, copy) NSString * detailLinkURl;//Details about the link

@property (nonatomic, copy) NSString * lensTypeName;//The lens type
@property (nonatomic, copy) NSString * glassTypeName;//Frame type

@property (nonatomic,assign) NSInteger stock;//inventory
@property (nonatomic, copy) NSString * supplierName;//supplier

@property (nonatomic, copy) NSString * brand;//brand
@property (nonatomic, copy) NSString * color;//color
@property (nonatomic, copy) NSString * style;//style
@property (nonatomic, assign) double   price;//Recommended retail price
@property (nonatomic, assign) double   prodPrice;//The actual price
@property (nonatomic, copy) NSString * frameColor;//Frame color
@property (nonatomic, copy) NSString * lensColor;//Lens color
@property (nonatomic, copy) NSString * function;//function
@property (nonatomic, copy) NSString * lensType;//The lens piece type
@property (nonatomic, copy) NSString * material;//The material
@property (nonatomic, copy) NSString * pd;//pd
@property (nonatomic, copy) NSString * border;//A border
@property (nonatomic, copy) NSString * refractiveIndex;//The refractive index
@property (nonatomic, copy) NSString * membraneLayer;//Membrane layer
@property (nonatomic, copy) NSString * sph;//SPH
@property (nonatomic, copy) NSString * cyl;//CYL
@property (nonatomic, copy) NSString * cycle;//cycle
@property (nonatomic, copy) NSString * specification;//specifications
@property (nonatomic, copy) NSString * degree;//degree
@property (nonatomic, copy) NSString * batchDegree;//batchdegree
@property (nonatomic, copy) NSString * baseOfArc;//The base of arc
@property (nonatomic, copy) NSString * watercontent;//The water content
@property (nonatomic, copy) NSString * type;//type
@property (nonatomic, copy) NSString * version;//version
@property (nonatomic, assign) NSInteger productCount;//The order quantity
@property (nonatomic, copy) NSString * thumbnailURL;//Thumbnail url
@property (nonatomic, assign) BOOL  isBatch;//Whether the batch
@property (nonatomic, assign) BOOL  isTryOn;//If you can try
@property (nonatomic, copy) NSString * approvalNumber;//A kind
@property (nonatomic, copy) NSString * batchNumber;//Batch no.
@property (nonatomic, copy) NSString * expireDate;//The period of validity
@property (nonatomic, assign) BOOL     solutionType;

- (IPCGlassesImage *)imageWithType:(IPCGlassesImageType)type;
- (NSURL *)imageURL;
- (IPCTopFilterType)filterType;
- (NSString *)glassPropertyName;
- (NSDictionary *)displayFields;

@end
