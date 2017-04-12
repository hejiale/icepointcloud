//
//  IPCCommon.h
//  IcePointCloud
//
//  Created by mac on 2016/11/29.
//  Copyright © 2016年 Doray. All rights reserved.
//

#ifndef IPCCore_h
#define IPCCore_h


/**
 *  FACE TYPE
 */
typedef NS_ENUM(NSInteger, IPCPhotoType) {
    /**
     *  MODEL
     */
    IPCPhotoTypeModel,
    /**
     *  FRONT
     */
    IPCPhotoTypeFrontial
};

/**
 *  MODEL TYPE
 */
typedef NS_ENUM(NSInteger, IPCModelType) {
    /**
     *  LOGN
     */
    IPCModelTypeGirlWithLongHair = 1,
    /**
     *  SHORT
     */
    IPCModelTypeGirlWithShortHair,
    /**
     *  MAN
     */
    IPCModelTypeMan,
};

/**
 *  PERSON MATCH
 */
typedef NS_ENUM(NSInteger, IPCModelUsage) {
    /**
     *  SINGLE MATCH
     */
    IPCModelUsageSingleMode,
    /**
     *  COMPARE MATCH
     */
    IPCModelUsageCompareMode,
};

/**
 *  GLASS CLASS
 */
typedef NS_ENUM(NSInteger, IPCTopFilterType) {
    /**
     *  FRAME
     */
    IPCTopFIlterTypeFrames,
    /**
     *  SUN GLASS
     */
    IPCTopFilterTypeSunGlasses,
    /**
     *  CUSTOM
     */
    IPCTopFilterTypeCustomized,
    /**
     *  READING GLASS
     */
    IPCTopFilterTypeReadingGlass,
    /**
     *  LENS
     */
    IPCTopFilterTypeLens,
    /**
     *  CONTACT LENS
     */
    IPCTopFilterTypeContactLenses,
    /**
     *  ACCESSORY
     */
    IPCTopFilterTypeAccessory,
    /**
     *  CARD
     */
    IPCTopFilterTypeCard,
    /**
     *  OTHERS
     */
    IPCTopFilterTypeOthers
};

/**
 *  GLASS SHOW POSITION
 */
typedef NS_ENUM(NSInteger, IPCGlassesImageType) {
    /**
     *  FRONT NORMAL
     */
    IPCGlassesImageTypeFrontialNormal,
    /**
     *  FRONT MATCH
     */
    IPCGlassesImageTypeFrontialMatch,
    /**
     *  PROFILE NORMAL
     */
    IPCGlassesImageTypeProfileNormal,
    /**
     *  DEGREE ANGLE
     */
    IPCGlassesImageTypeDegreeAngle,
    /**
     *   THUMB
     */
    IPCGlassesImageTypeThumb
};

/**
 *  PAY TYPE
 */
typedef NS_ENUM(NSInteger, IPCOrderPayType){
    /**
     *  NONE
     */
    IPCOrderPayTypeNone,
    /**
     *  PAY AMOUNT
     */
    IPCOrderPayTypePayAmount,
    /**
     *  INSTALLMENT
     */
    IPCOrderPayTypeInstallment,
};

/**
 *  PreSell PAY TYPE
 */
typedef NS_ENUM(NSInteger, IPCOrderPreSellPayType){
    /**
     *  NONE
     */
    IPCOrderPreSellPayTypeNone,
    /**
     *  PRESELL PAY AMOUNT
     */
    IPCOrderPreSellPayTypeAmount,
    /**
     *  PRESELL INSTALLMENT
     */
    IPCOrderPreSellPayTypellInstallment
};



/**
 *  PAY STYLE
 */
typedef NS_ENUM(NSInteger, IPCPayStyleType){
    /**
     *  NONE
     */
    IPCPayStyleTypeNone,
    /**
     *  WECHAT
     */
    IPCPayStyleTypeWechat,
    /**
     *  ALIPAY
     */
    IPCPayStyleTypeAlipay,
    /**
     *  CASH
     */
    IPCPayStyleTypeCash,
    /**
     *  CARD
     */
    IPCPayStyleTypeCard
};


//Frame
#define SCREEN_WIDTH                  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                 [UIScreen mainScreen].bounds.size.height
//Color
#define COLOR_RGB_BLUE              [UIColor jk_colorWithHexString:@"#63a0d4"]
#define COLOR_RGB_RED                [UIColor jk_colorWithHexString:@"#fd6800"]
//Account Key
#define IPCWeixinAppID                 @"wx94ce99b4ee7c5356"
#define IPCWeixinAppSecret           @"12a16d241dfcc9133783f4e3e8a47c59"
#define IPCTuSdkKey                      @"2107c2f9f27e3f7b-00-yzbvp1"
#define IPCIflyFaceDetectorKey       @"5774da82"


#ifdef DEBUG
#define DLog(fmt, ...)                     NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DeBugLog(fmt, ...)             NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NSLog(...)                          NSLog(__VA_ARGS__);
#define MyNSLog(FORMAT, ...)      fprintf(stderr,"[%s]:[line %d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DLog(...)
#define DeBugLog(...)
#define MyNSLog(FORMAT, ...)
#endif


#endif /* IPCCore_h */
