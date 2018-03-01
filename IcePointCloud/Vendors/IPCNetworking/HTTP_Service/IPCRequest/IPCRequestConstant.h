//
//  IPCRequestConstant.h
//  IcePointCloud
//
//  Created by mac on 2016/11/10.
//  Copyright © 2016年 Doray. All rights reserved.
//

#ifndef IPCRequestConstant_h
#define IPCRequestConstant_h

#ifdef DEBUG
//#define   IPC_ProductAPI_URL       @"http://192.168.1.143:8080/pos"
#define   IPC_ProductAPI_URL       @"https://dev.icepointcloud.com"
//#define   IPC_ProductAPI_URL       @"https://icepointcloud.com"
#elif   BETA
#define   IPC_ProductAPI_URL       @"https://icepointcloud.com"
#else
#define   IPC_ProductAPI_URL       @"https://icepointcloud.com"
#endif
#define   IPC_ProductAPI_Port       @"/gateway/api/jsonrpc.jsp"
///未验证会员登录返回错误
#define   IPAD_NOT_ACTIVATE      30196
///假帐号登录验证激活码登录
#define   LOGINACCOUNT             @"wwwwww"
#define   PASSWORD                     @"123456"

/**
 *  Network Request Methods
 */
typedef NS_ENUM(NSUInteger, IPCRequestMethod) {
    IPCRequestTypeGET = 0,
    IPCRequestTypePOST,
};

/**
 *  Request Content CacheAble
 */
typedef NS_ENUM(NSUInteger, IPCRequestCache){
    IPCRequestCacheDisEnable = 0,
    IPCRequestCacheEnable
};

#endif /* IPCRequestConstant_h */
