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
#define BatchRequest_LensPrice                            @"productConfigAdmin.listOptics"

#define CustomerRequest_OptometryList              @"customerAdmin.listOptometry"
#define CustomerRequest_SaveNewOptometry      @"customerAdmin.saveOptometry"
#define CustomerRequest_SaveNewCustomer       @"customerAdmin.saveCustomerInfo"
#define CustomerRequest_CustomerDetail            @"customerAdmin.getCustomerInfo"
#define CustomerRequest_CustomerList               @"customerAdmin.listCustomer"
#define CustomerRequest_CustomerOrderList      @"customerAdmin.listHistoryOrdersByCustomerId"
#define CustomerRequest_OrderDetail                  @"bizadmin.getSalesOrderByOrderNumberForPos"
#define CustomerRequest_UpdateCustomer          @"customerAdmin.updateCustomerInfo"
#define CustomerRequest_SetCurrentOptometry   @"customerAdmin.setCurrentOptometry"
#define CustomerRequest_ListMemberLevel          @"customerConfigAdmin.listMemberLevel"
#define CustomerRequest_ListCustomerType        @"customerConfigAdmin.listCustomerType"
#define CustomerRequest_UpgradeMember          @"customerAdmin.customerUpdateToMember"
#define CustomerRequest_ValidateCustomer        @"customerAdmin.validateCustomerQRcode"
#define CustomerRequest_UpdateMemberPhone   @"customerAdmin.updateCustomerMemberPhone"

#define GoodsRequest_FilterCategory                    @"bizadmin.getCategoryType"
#define GoodsRequest_GoodsList                          @"bizadmin.filterTryGlasses"
#define GoodsRequest_RecommdList                     @"productAdmin.searchTryGlasses"
#define GoodsRequest_PriceStrategy                     @"productAdmin.listPriceStrategyForListProduct"

#define PayOrderRequest_CompanyConfig            @"companyAdmin.getCompanyConfig"
#define PayOrderRequest_GetAuths                      @"bizadmin.getAuths" 
//#define PayOrderRequest_Outbound                     @"orderObjectAdmin.inventoryOutForSalesOrder"
#define PayOrderRequest_ListPayType                  @"payTypeConfigAdmin.listPayType"
//#define PayOrderRequest_SavePrototyOrder          @"orderObjectAdmin.savePrototypeOrders"
//#define PayOrderRequest_OfferOrder                    @"orderObjectAdmin.commitAuthOrders"
//#define PayOrderRequest_AuthOrder                    @"orderObjectAdmin.confirmOrder"
//#define PayOrderRequest_PayCashOrder               @"bizadmin.saveOrderPayInfo"
#define PayOrderRequest_EmployeeList                 @"employeeadmin.listEmployee"
#define PayOrderRequest_Integral                          @"integralTradeAdmin.getSaleOrderDetailIntegralList"
#define PayOrderRequest_IntegralRule                   @"integralTradeAdmin.getIntegralTradeObjectForCompany"
#define PayOrderRequest_PayOrderWithStatus        @"orderObjectAdmin.updateOrderForStatus"

#define UserRequest_Login                                    @"bizadmin.login"
#define UserRequest_LoginOut                              @"bizadmin.logout"
#define UserRequest_UpdatePassword                   @"bizadmin.updateUserPassword"
#define UserRequest_WareHouseList                      @"bizadmin.listStoreOrRepositoryByCompanyId"
#define UserRequest_EmployeeAccount                  @"employeeadmin.getEmployeeObjectFromAccount"


#endif /* IPCNetworkingAPI_h */
