//
//  EditBatchParameterView.m
//  IcePointCloud
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCEditBatchParameterView.h"
#import "IPCEditParameterCell.h"

static NSString * const parameterIdentifier = @"EditParameterCellIdentifier";

@interface IPCEditBatchParameterView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *editParameterView;
@property (weak, nonatomic) IBOutlet UITableView *parameterTableView;
@property (weak, nonatomic) IBOutlet UIImageView *glassImageView;
@property (weak, nonatomic) IBOutlet UILabel *glassNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *glassPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *editNoneAccessoryView;
@property (weak, nonatomic) IBOutlet UIImageView *noneAccessoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *noneAccessoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *noneAccessoryPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *noneAccessoryCartNumLbl;

@property (strong, nonatomic) IPCGlasses * currentGlass;
@property (strong, nonatomic) IPCBatchParameterList * batchParameterList;
@property (strong, nonatomic) NSMutableArray<IPCContactLenSpecList *> * contactSpecificationArray;
@property (strong, nonatomic) IPCAccessorySpecList * accessorySpecification;
@property (copy, nonatomic) void(^DismissBlock)();

@end

@implementation IPCEditBatchParameterView

- (instancetype)initWithFrame:(CGRect)frame Glasses:(IPCGlasses *)glasses  Dismiss:(void(^)())dismiss
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentGlass  = glasses;
        self.DismissBlock = dismiss;
        
        UIView * parameterBgView = [UIView jk_loadInstanceFromNibWithName:@"IPCEditBatchParameterView" owner:self];
        [parameterBgView setFrame:frame];
        [self addSubview:parameterBgView];
        
        [self.editParameterView addBorder:8 Width:0];
        [self.editNoneAccessoryView addBorder:8 Width:0];
        [self.parameterTableView setTableFooterView:[[UIView alloc]init]];
        [self.glassImageView addBorder:5 Width:0.7];
        [self.noneAccessoryImageView addBorder:5 Width:0.7];
        [self.glassImageView setImageURL:[NSURL URLWithString:glasses.thumbImage.imageURL]];
        [self.noneAccessoryImageView setImageURL:[NSURL URLWithString:glasses.thumbImage.imageURL]];
        [self.glassNameLabel setText:glasses.glassName];
        [self.noneAccessoryNameLabel setText:glasses.glassName];
        [self.glassPriceLabel setText:[NSString stringWithFormat:@"￥%.f",glasses.price]];
        [self.noneAccessoryPriceLabel setText:[NSString stringWithFormat:@"￥%.f",glasses.price]];
        
        [IPCUIKit show];
        if (glasses){
            if ([glasses filterType] ==IPCTopFilterTypeLens) {
                [self queryBatchStockRequest];
            }else if([glasses filterType] ==IPCTopFilterTypeReadingGlass){
                [self queryBatchReadingDegreeRequest];
            }else if([glasses filterType] == IPCTopFilterTypeContactLenses){
                __block NSMutableArray<NSString *> * contactLensIDs = [[NSMutableArray alloc]init];
                if (glasses.stock > 0) {
                    [[[IPCShoppingCart sharedCart] batchParameterList:self.currentGlass] enumerateObjectsUsingBlock:^(IPCShoppingCartItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (!obj.isPreSell) {
                            if (! [contactLensIDs containsObject:obj.contactLensID])
                                [contactLensIDs addObject:obj.contactLensID];
                        }
                    }];
                }
                if (contactLensIDs.count > 0){
                    [self  getContactLensSpecification:contactLensIDs];
                }else{
                    [self.parameterTableView reloadData];
                    [IPCUIKit hiden];
                }
            }else{
                [self queryAccessoryStock];
            }
            
            if (([glasses filterType] == IPCTopFilterTypeAccessory && glasses.solutionType) && glasses.stock <= 0) {
                [self.editNoneAccessoryView setHidden:NO];
                [self.noneAccessoryCartNumLbl setText:[NSString stringWithFormat:@"%d",[self cartItemAccessory].count]];
            }else{
                [self.editParameterView setHidden:NO];
            }
        }
    }
    return self;
}


- (NSMutableArray<IPCContactLenSpecList *> *)contactSpecificationArray{
    if (!_contactSpecificationArray)
        _contactSpecificationArray = [[NSMutableArray alloc]init];
    return _contactSpecificationArray;
}

- (IPCShoppingCartItem *)cartItemAccessory{
    IPCShoppingCartItem * item = [[IPCShoppingCart sharedCart] batchItemForGlasses:self.currentGlass Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:nil BatchNum:nil KindNum:nil ValidityDate:nil IsOpenBooking:YES];
    return item;
}


#pragma mark //Network Request
- (void)queryBatchStockRequest{
    [IPCBatchRequestManager queryBatchLensProductsStockWithLensID:self.currentGlass.glassesID
                                                     SuccessBlock:^(id responseValue)
     {
         _batchParameterList = [[IPCBatchParameterList alloc]initWithResponseObject:responseValue];
         [self.parameterTableView reloadData];
         [IPCUIKit hiden];
     } FailureBlock:^(NSError *error) {
         [IPCUIKit showError:error.userInfo[kIPCNetworkErrorMessage]];
     }];
}

- (void)queryBatchReadingDegreeRequest{
    [IPCBatchRequestManager queryBatchReadingProductsStockWithLensID:self.currentGlass.glassesID
                                                        SuccessBlock:^(id responseValue)
     {
         _batchParameterList = [[IPCBatchParameterList alloc]initWithResponseObject:responseValue];
         [self.parameterTableView reloadData];
         [IPCUIKit hiden];
     } FailureBlock:^(NSError *error) {
         [IPCUIKit showError:error.userInfo[kIPCNetworkErrorMessage]];
     }];
}


- (void)getContactLensSpecification:(NSArray<NSString *> *)contactLensIDArray{
    [IPCBatchRequestManager queryContactGlassBatchSpecification:contactLensIDArray SuccessBlock:^(id responseValue) {
        [contactLensIDArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            IPCContactLenSpecList * _contactSpecificationArray = [[IPCContactLenSpecList alloc]initWithResponseObject:responseValue ContactLensID:obj];
            [self.contactSpecificationArray addObject:_contactSpecificationArray];
        }];
        [self.parameterTableView reloadData];
        [IPCUIKit hiden];
    } FailureBlock:^(NSError *error) {
        [IPCUIKit showError:error.userInfo[kIPCNetworkErrorMessage]];
    }];
}

- (void)queryAccessoryStock{
    [IPCBatchRequestManager queryAccessoryBatchSpecification:self.currentGlass.glassesID
                                                SuccessBlock:^(id responseValue)
     {
         _accessorySpecification = [[IPCAccessorySpecList alloc]initWithResponseObject:responseValue];
         [self.parameterTableView reloadData];
         [IPCUIKit hiden];
     } FailureBlock:^(NSError *error) {
         [IPCUIKit showError:error.userInfo[kIPCNetworkErrorMessage]];
     }];
}

#pragma mark //Clicked Events
- (IBAction)closeAction:(id)sender {
    if (self.DismissBlock)
        self.DismissBlock();
}

- (IBAction)reduceNoneAccessoryCartAction:(id)sender {
    [[IPCShoppingCart sharedCart] removeGlasses:self.currentGlass];
    [self.noneAccessoryCartNumLbl setText:[NSString stringWithFormat:@"%d",[self cartItemAccessory].count]];
    if ([self cartItemAccessory].count == 0) {
        if (self.DismissBlock)
            self.DismissBlock();
    }
}

- (IBAction)addNoneAccessoryCartAction:(id)sender {
    [[IPCShoppingCart sharedCart] plusGlass:self.currentGlass];
    [self.noneAccessoryCartNumLbl setText:[NSString stringWithFormat:@"%d",[self cartItemAccessory].count]];
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[IPCShoppingCart sharedCart] batchParameterList:self.currentGlass].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCEditParameterCell * cell = [tableView dequeueReusableCellWithIdentifier:parameterIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCEditParameterCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    __weak typeof (self) weakSelf = self;
    IPCShoppingCartItem * cartItem = [[IPCShoppingCart sharedCart] batchParameterList:self.currentGlass][indexPath.row];
    [cell setCartItem:cartItem Reload:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.parameterTableView reloadData];
    }];
    
    __block BOOL isHasStock = NO;
    if ([self.currentGlass filterType] ==IPCTopFilterTypeLens) {
        if ([self queryLensStock:cartItem] > 0)
            isHasStock = YES;
    }else if ([self.currentGlass filterType]== IPCTopFilterTypeReadingGlass){
        if ([self queryReadingLensStock:cartItem] > 0)
            isHasStock = YES;
    }else if([self.currentGlass filterType] == IPCTopFilterTypeContactLenses){
        if ([self queryContactLensStock:cartItem] > 0 && cartItem.count < [self queryContactLensStock:cartItem])
            isHasStock = YES;
    }else{
        if ([self queryAccessoryStock:cartItem] > 0 && cartItem.count < [self queryAccessoryStock:cartItem])
            isHasStock = YES;
    }
    [cell reloadAddButtonStatus:isHasStock];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (([self.currentGlass filterType] == IPCTopFilterTypeContactLenses && self.currentGlass.stock > 0) || [self.currentGlass filterType] == IPCTopFilterTypeAccessory)
        return 60;
    return 45;
}


#pragma mark //To obtain the corresponding  lens specifications of the inventory
- (NSInteger)queryLensStock:(IPCShoppingCartItem *)cartItem{
    __block NSInteger lensStock = 0;
    
    [self.batchParameterList.parameterList enumerateObjectsUsingBlock:^(BatchParameterObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.sph isEqualToString:cartItem.batchSph] && [obj.cyl isEqualToString:cartItem.bacthCyl]) {
            lensStock = obj.bizStock;
            *stop = YES;
        }
    }];
    return lensStock;
}


- (NSInteger)queryReadingLensStock:(IPCShoppingCartItem *)cartItem{
    __block NSInteger lensStock = 0;
    
    [self.batchParameterList.parameterList enumerateObjectsUsingBlock:^(BatchParameterObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.degree isEqualToString:cartItem.batchReadingDegree]) {
            lensStock = obj.bizStock;
            *stop = YES;
        }
    }];
    return lensStock;
}


- (NSInteger)queryContactLensStock:(IPCShoppingCartItem *)cartItem{
    __block NSInteger lensStock = 0;
    
    [self.contactSpecificationArray enumerateObjectsUsingBlock:^(IPCContactLenSpecList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([cartItem.contactLensID isEqualToString:obj.contactLensID] && [cartItem.contactDegree isEqualToString:obj.degree]) {
            [obj.parameterList enumerateObjectsUsingBlock:^(IPCContactLenSpec * _Nonnull specification, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([specification.batchNumber  isEqualToString:cartItem.batchNum] && [specification.approvalNumber isEqualToString:cartItem.kindNum] && [specification.expireDate isEqualToString:cartItem.validityDate]) {
                    lensStock = specification.bizStock;
                    *stop = YES;
                }
            }];
        }
    }];
    return lensStock;
}

- (NSInteger)queryAccessoryStock:(IPCShoppingCartItem *)cartItem{
    __block NSInteger lensStock = 0;
    [self.accessorySpecification.parameterList enumerateObjectsUsingBlock:^(IPCAccessoryBatchNum * _Nonnull batchNumMode, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([batchNumMode.batchNumber isEqualToString:cartItem.batchNum]) {
            [batchNumMode.kindNumArray enumerateObjectsUsingBlock:^(IPCAccessoryKindNum * _Nonnull kindNumMode, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([kindNumMode.kindNum isEqualToString:cartItem.kindNum]) {
                    [kindNumMode.expireDateArray enumerateObjectsUsingBlock:^(IPCAccessoryExpireDate * _Nonnull dateMode, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([dateMode.expireDate isEqualToString:cartItem.validityDate]) {
                            lensStock = dateMode.stock;
                            *stop = YES;
                        }
                    }];
                }
            }];
        }
    }];
    return lensStock;
}

@end
