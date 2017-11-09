//
//  IPCNetworkingAPI.h
//  IcePointCloud
//
//  Created by gerry on 2017/10/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#ifndef IPCNetworkingAPI_h
#define IPCNetworkingAPI_h

#import   "IPCUserRequestManager.h"
#import   "IPCGoodsRequestManager.h"
#import   "IPCCustomerRequestManager.h"
#import   "IPCBatchRequestManager.h"
#import   "IPCPayOrderRequestManager.h"

#define BatchRequest_LensStock                          @"batchAdmin.getBatchLenInventory"
#define BatchRequest_ReadingGlassesStock         @"batchAdmin.getBatchReadingGlassesInventory"
#define BatchRequest_ContactLensGlassesStock   @"batchAdmin.getBatchContactLensInventory"
#define BatchRequest_ContactLensSpecification   @"batchAdmin.getBatchContactLensInventoryDetailsByContactLensIds"
#define BatchRequest_AccessorySpecification       @"batchAdmin.getContactSolutionDetailsWithProdIdForPos"
#define BatchRequest_LensConfig                         @"sphCylCfgAdmin.getAllConfig"

#define CustomerRequest_OptometryList              @"customerAdmin.listOptometry"
#define CustomerRequest_SaveNewOptometry      @"customerAdmin.saveOptometry"
#define CustomerRequest_SaveNewCustomer       @"customerAdmin.saveCustomerInfo"
#define CustomerRequest_CustomerDetail            @"customerAdmin.getCusomerInfo"
#define CustomerRequest_CustomerList               @"customerAdmin.listCustomer"
#define CustomerRequest_CustomerOrderList      @"customerAdmin.listHistoryOrdersByCustomerId"
#define CustomerRequest_SaveNewAddress          @"customerAdmin.saveAddress"
#define CustomerRequest_AddressList                  @"customerAdmin.getAllAddress"
#define CustomerRequest_OrderDetail                  @"bizadmin.getSalesOrderByOrderNumberForPos"
#define CustomerRequest_UpdateCustomer          @"customerAdmin.updateCustomerInfo"
#define CustomerRequest_SetCurrentOptometry   @"customerAdmin.setCurrentOptometry"
#define CustomerRequest_SetCurrentAddress       @"customerAdmin.setCurrentAddress"
#define CustomerRequest_ListMemberLevel          @"customerConfigAdmin.listMemberLevel"
#define CustomerRequest_ListCustomerType        @"customerConfigAdmin.listCustomerType"
#define CustomerRequest_JudgeNameOrPhone     @"customerAdmin.getCusomerByPhoneOrName"

#define GoodsRequest_FilterCategory                    @"bizadmin.getCategoryType"
#define GoodsRequest_GoodsList                          @"bizadmin.filterTryGlasses"
#define GoodsRequest_RecommdList                     @"productAdmin.searchTryGlasses"

#define PayOrderRequest_SaveNewOrder               @"orderObjectAdmin.savePrototypeOrders"
#define PayOrderRequest_EmployeeList                 @"employeeadmin.listEmployee"
#define PayOrderRequest_Integral                          @"integralTradeAdmin.getSaleOrderDetailIntegralList"

#define UserRequest_Login                                    @"bizadmin.login"
#define UserRequest_LoginOut                              @"bizadmin.logout"
#define UserRequest_UpdatePassword                   @"bizadmin.updateUserPassword"
#define UserRequest_WareHouseList                      @"bizadmin.listStoreOrRepositoryByCompanyId"
#define UserRequest_EmployeeAccount                  @"employeeadmin.getEmployeeObjectFromAccount"


#endif /* IPCNetworkingAPI_h */
