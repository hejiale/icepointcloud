//
//  Glass.m
//  IcePointCloud
//
//  Created by mac on 7/19/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCGlasses.h"


@implementation IPCGlasses

/**
 *  Glasses pictures in various directions
 *
 *  @param type
 *
 *  @return
 */
- (IPCGlassesImage *)imageWithType:(IPCGlassesImageType)type
{
    switch (type) {
        case IPCGlassesImageTypeFrontialMatch:
            return self.frontialTryOnImage;
        case IPCGlassesImageTypeFrontialNormal:
            return self.frontialDisplayImage;
        case IPCGlassesImageTypeProfileNormal:
            return self.profileDisplayImage;
        case IPCGlassesImageTypeDegreeAngle:
            return self.degreeAngleImage;
        case IPCGlassesImageTypeThumb:
            return self.thumbImage;
        default:
            return nil;
    }
}


/**
 *  Glasses type
 *
 */
- (IPCTopFilterType)filterType{
    if ([self.glassTypeName isEqualToString:@"FRAMES"]) {
        return IPCTopFIlterTypeFrames;
    }else if ([self.glassTypeName isEqualToString:@"SUNGLASSES"]){
        return IPCTopFilterTypeSunGlasses;
    }else if ([self.glassTypeName isEqualToString:@"CUSTOMIZED"]){
        return IPCTopFilterTypeCustomized;
    }else if ([self.glassTypeName isEqualToString:@"READING_GLASSES"]){
        return IPCTopFilterTypeReadingGlass;
    }else if ([self.lensTypeName isEqualToString:@"LENS"]){
        return IPCTopFilterTypeLens;
    }else if ([self.lensTypeName isEqualToString:@"CONTACT_LENSES"]){
        return IPCTopFilterTypeContactLenses;
    }else if ([self.lensTypeName isEqualToString:@"ACCESSORY"]){
        return IPCTopFilterTypeAccessory;
    }else if ([self.lensTypeName isEqualToString:@"VALUECARD"]){
        return IPCTopFilterTypeCard;
    }
    return IPCTopFilterTypeOthers;
}


+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"glassName"           : @"name",
             @"glassesID"                  : @"id",
             @"glassCode"                : @"stockNumber",
             @"price"                        : @"suggestPrice",
             @"border"                     : @"frame",
             @"glassTypeName"       : @"glassesType",
             @"lensTypeName"        : @"lensType",
             @"detailLinkURl"           : @"desc",
             @"stock"                       : @"inventoryStock",
             @"profileDisplayImage" : @"photos.侧面展示",
             @"profileTryOnImage"   : @"photos.侧面",
             @"frontialDisplayImage": @"photos.正面展示",
             @"frontialTryOnImage"  : @"photos.正面",
             @"thumbImage"          : @"photos.缩略图",
             @"membraneLayer"       : @"layer",
             @"cycle"                   : @"period",
             @"specification"       : @"packingSpec",
             @"baseOfArc"           : @"baseCurve",
             @"watercontent"        : @"waterContent",
             @"lensType"            : @"glassLensType",
             @"refractiveIndex"     : @"refraction",
             @"isTryOn"              : @"proTry",
             @"productCount"        : @"count",
             @"isBatch"               : @"batch",
             @"valueCardPhotoURL": @"photoUrl",
             };
}

/**
 *  Product parameters
 *
 */
- (NSDictionary *)displayFields{
    NSMutableDictionary * fields = [[NSMutableDictionary alloc]init];
    
    if ([self filterType] == IPCTopFIlterTypeFrames) {//frame
        [fields setObject:self.supplierName forKey:@"供应商"];
        [fields setObject:self.color forKey:@"颜色"];
        [fields setObject:self.border forKey:@"边框"];
        [fields setObject:self.material forKey:@"材质"];
        [fields setObject:self.glassCode forKey:@"商品货号"];
        [fields setObject:self.brand forKey:@"品牌"];
        [fields setObject:self.style forKey:@"款式"];
    }else if ([self filterType] == IPCTopFilterTypeLens){//The lens
        [fields setObject:self.supplierName forKey:@"供应商"];
        [fields setObject:[NSString stringWithFormat:@"%@",self.sph] forKey:@"球镜(SPH)"];
        [fields setObject:[NSString stringWithFormat:@"%@",self.cyl] forKey:@"柱镜(CYL)"];
        [fields setObject:self.membraneLayer forKey:@"膜层"];
        [fields setObject:self.color forKey:@"颜色"];
        [fields setObject:self.glassCode forKey:@"商品货号"];
        [fields setObject:[NSString stringWithFormat:@"%@",self.refractiveIndex] forKey:@"折射率"];
        [fields setObject:self.function forKey:@"功能"];
        [fields setObject:self.brand forKey:@"品牌"];
    }else if ([self filterType] == IPCTopFilterTypeSunGlasses){//The sun glasses
        [fields setObject:self.glassCode forKey:@"商品货号"];
        [fields setObject:self.function forKey:@"功能"];
        [fields setObject:self.supplierName forKey:@"供应商"];
        [fields setObject:self.material forKey:@"材质"];
        [fields setObject:self.lensColor forKey:@"镜片颜色"];
        [fields setObject:self.brand forKey:@"品牌"];
        [fields setObject:self.style forKey:@"款式"];
        [fields setObject:self.frameColor forKey:@"镜架颜色"];
    }else if ([self filterType] == IPCTopFilterTypeCustomized){//Custom classes glasses
        [fields setObject:self.glassCode forKey:@"商品货号"];
        [fields setObject:self.supplierName forKey:@"供应商"];
        [fields setObject:self.lensType forKey:@"镜片片型"];
        [fields setObject:self.lensColor forKey:@"镜片颜色"];
        [fields setObject:self.brand forKey:@"品牌"];
        [fields setObject:self.material forKey:@"镜架材质"];
        [fields setObject:self.frameColor forKey:@"镜架颜色"];
    }else if ([self filterType] == IPCTopFilterTypeReadingGlass){//Reading glasses
        [fields setObject:self.glassCode forKey:@"商品货号"];
        [fields setObject:self.color forKey:@"颜色"];
        [fields setObject:self.border forKey:@"边框"];
        [fields setObject:self.material forKey:@"材质"];
        [fields setObject:self.supplierName forKey:@"供应商"];
        [fields setObject:self.pd forKey:@"瞳距"];
        [fields setObject:self.brand forKey:@"品牌"];
        [fields setObject:self.style forKey:@"款式"];
        [fields setObject:self.degree forKey:@"度数"];
    }else if ([self filterType] == IPCTopFilterTypeContactLenses){//Contact lenses
        [fields setObject:self.glassCode forKey:@"商品货号"];
        [fields setObject:self.cycle forKey:@"周期"];
        [fields setObject:self.baseOfArc forKey:@"基弧"];
        [fields setObject:self.watercontent forKey:@"含水量"];
        [fields setObject:self.color forKey:@"颜色"];
        [fields setObject:self.supplierName forKey:@"供应商"];
        [fields setObject:self.brand forKey:@"品牌"];
        [fields setObject:self.specification forKey:@"包装规格"];
        [fields setObject:self.degree forKey:@"度数"];
    }else if ([self filterType] == IPCTopFilterTypeAccessory){//accessories
        [fields setObject:self.brand forKey:@"品牌"];
        [fields setObject:self.supplierName forKey:@"供应商"];
        [fields setObject:self.type forKey:@"类型"];
        [fields setObject:self.glassName forKey:@"商品名称"];
        [fields setObject:self.glassCode forKey:@"商品货号"];
    }
    return fields;
}


@end
