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
#elif   BETA
#define   IPC_ProductAPI_URL       @"https://dev.icepointcloud.com"
//#define   IPC_ProductAPI_URL       @"https://icepointcloud.com"
#else
#define   IPC_ProductAPI_URL       @"https://icepointcloud.com"
#endif
#define   IPC_ProductAPI_Port       @"/gateway/api/jsonrpc.jsp"

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
