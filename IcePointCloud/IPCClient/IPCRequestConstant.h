//
//  IPCRequestConstant.h
//  IcePointCloud
//
//  Created by mac on 2016/11/10.
//  Copyright © 2016年 Doray. All rights reserved.
//

#ifndef IPCRequestConstant_h
#define IPCRequestConstant_h

/**
 *  Network request type
 */
typedef NS_ENUM(NSUInteger, IPCRequestType) {
    /**
     *  Get
     */
    IPCRequestTypeGet = 0,
    /**
     *  Post
     */
    IPCRequestTypePost,
    /**
     *  upload
     */
    IPCRequestTypeUpload
};

/**
 *  The request content is cached
 */
typedef NS_ENUM(NSUInteger, IPCRequestCache){
    IPCRequestCacheDisEnable = 0,
    IPCRequestCacheEnable
};

static NSInteger const  kIPCServiceErrorCode   =  490;
static NSString * const kIPCNetworkResult       =  @"result";
static NSString * const kIPCNetworkError         =  @"error";
static NSString * const kIPCErrorNetworkAlertMessage = @"请检查您的设备->设置->无线局域网选项";

static NSError *HTTPError(NSString *domain, int code) {
    return [NSError errorWithDomain:domain code:code userInfo:nil];
}

/**
 *  The  client url
 */
#ifdef DEBUG
//#define   IPC_ProductAPI_URL       @"http://10.0.0.6:8080/pos"
#define   IPC_ProductAPI_URL       @"http://10.0.0.31:8080/pos"
//#define   IPC_ProductAPI_URL       @"http://dev.icepointcloud.com"
#elif BETA
#define   IPC_ProductAPI_URL       @"http://dev.icepointcloud.com"
#else
#define   IPC_ProductAPI_URL       @"http://icepointcloud.com"
#endif
#define   IPC_ProductAPI_Port       @"/gateway/api/jsonrpc.jsp"


#import   "IPCRequest.h"
#import   "IPCUserRequestManager.h"
#import   "IPCGoodsRequestManager.h"
#import   "IPCCustomerRequestManager.h"
#import   "IPCBatchRequestManager.h"
#import   "IPCPayOrderRequestManager.h"
#import   "IPCHttpRequest.h"
#import   "IPCResponse.h"
#import   "IPCNetworkCache.h"
#import   "IPCError.h"
#import   "AFHTTPSessionManager+Extend.h"
#import   "IPCReachability.h"


#endif /* IPCRequestConstant_h */
