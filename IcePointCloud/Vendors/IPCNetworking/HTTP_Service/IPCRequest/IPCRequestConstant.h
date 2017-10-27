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
//#define   IPC_ProductAPI_URL       @"http://10.0.0.7:8080/pos"
#define   IPC_ProductAPI_URL       @"https://dev.icepointcloud.com"
//#define   IPC_ProductAPI_URL       @"https://icepointcloud.com"
#elif   BETA
#define   IPC_ProductAPI_URL       @"https://icepointcloud.com"
#else
#define   IPC_ProductAPI_URL       @"https://icepointcloud.com"
#endif
#define   IPC_ProductAPI_Port       @"/gateway/api/jsonrpc.jsp"

/**
 *  Network Request Methods
 */
typedef NS_ENUM(NSUInteger, IPCRequestType) {
    /**
     *  Get Task
     */
    IPCRequestTypeGet = 0,
    /**
     *  Post Task
     */
    IPCRequestTypePost,
    /**
     *  Upload Task
     */
    IPCRequestTypeUpload
};

/**
 *  Request Content CacheAble
 */
typedef NS_ENUM(NSUInteger, IPCRequestCache){
    /**
     *  Disable Store Cache
     */
    IPCRequestCacheDisEnable = 0,
    /**
     *  Able Store Cache
     */
    IPCRequestCacheEnable
};

#endif /* IPCRequestConstant_h */
