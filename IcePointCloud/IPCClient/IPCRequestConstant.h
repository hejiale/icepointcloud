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
static NSString * const kIPCNetworkErrorMessage = @"ErrorMessage";
static NSString * const kIPCErrorNetworkAlertMessage = @"请检查您的设备->设置->无线局域网选项";

/**
 *  The  client url
 */
#ifdef DEVELOP
#define   IPC_ProductAPI_URL       @"http://dev.icepointcloud.com/gateway/api/jsonrpc.jsp"
#elif UAT
#define   IPC_ProductAPI_URL       @"http://dev.icepointcloud.com/gateway/api/jsonrpc.jsp"
#else
#define   IPC_ProductAPI_URL       @"http://icepointcloud.com/gateway/api/jsonrpc.jsp"
#endif


#import   "IPCRequestManager.h"
#import   "IPCUserRequestManager.h"
#import   "IPCGoodsRequestManager.h"
#import   "IPCCustomerRequestManager.h"
#import   "IPCBatchRequestManager.h"
#import   "IPCPayOrderRequestManager.h"
#import   "IPCClient.h"
#import   "IPCResponse.h"
#import   "IPCNetworkCache.h"
#import   "IPCError.h"
#import   "AFHTTPSessionManager+Extend.h"
#import   "IPCReachability.h"


#endif /* IPCRequestConstant_h */
