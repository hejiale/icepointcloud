//
//  GlassParameterView.m
//  IcePointCloud
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCGlassParameterView.h"
#import "IPCGlassParameterViewMode.h"

static NSString * const identifier = @"ChooseBatchParameterCellIdentifier";

typedef NS_ENUM(NSInteger, ContactLenSpecType){
    ContactLenSpecTypeDegree,
    ContactLenSpecTypeBatchNum,
    ContactLenSpecTypeKindNum,
    ContactLenSpecTypeDate
};

@interface IPCGlassParameterView()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL           isLeft;
    //The currently selected contact lenses ID
    NSString   * currentContactDegreeID;
    //The currently selected contact lens inventory
    NSInteger    currentDegreeStock;
    //The location of the currently selected batch number
    NSInteger    batchNumTag;
    //A kind selected location
    NSInteger    kindNumTag;
    //The validity of selected location
    NSInteger    validityDateTag;
    //The currently selected accessory inventory
    NSInteger    currentAccessoryStock;
    BOOL           isOpenBooking;
}

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
//Lens  ReadingLens
@property (strong, nonatomic) IBOutlet UIView *normalLensView;
@property (weak, nonatomic) IBOutlet UIImageView *normalLensImageView;
@property (weak, nonatomic) IBOutlet UILabel *normalLensNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *normalLensPriceLabel;
@property (weak, nonatomic) IBOutlet UIView   *leftParameterView;
@property (weak, nonatomic) IBOutlet UIView   *rightParameterView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel  *leftParameterLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightParameterLabel;
@property (weak, nonatomic) IBOutlet UILabel *lensNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *lensMinusButton;
@property (weak, nonatomic) IBOutlet UIButton *lensPlusButton;
@property (weak, nonatomic) IBOutlet UIButton *lensSureButton;
@property (weak, nonatomic) IBOutlet UIButton *lensCancelButton;
//Parameter TableView
@property (strong, nonatomic) IBOutlet UITableView *parameterTableView;
//ContactLens
@property (strong, nonatomic) IBOutlet UIView *contactLensView;
@property (weak, nonatomic) IBOutlet UIImageView *contactImageView;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *contactDegreeView;
@property (weak, nonatomic) IBOutlet UILabel *contactDegreeLabel;
@property (weak, nonatomic) IBOutlet UIView *contactBatchNumView;
@property (weak, nonatomic) IBOutlet UILabel *contactBatchNumLabel;
@property (weak, nonatomic) IBOutlet UIView *contactKindNumView;
@property (weak, nonatomic) IBOutlet UILabel *contactKindNumLabel;
@property (weak, nonatomic) IBOutlet UIView *contactDateView;
@property (weak, nonatomic) IBOutlet UILabel *contactDateLabel;
@property (weak, nonatomic) IBOutlet UILabel  *contactCartNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *contactMinusButton;
@property (weak, nonatomic) IBOutlet UIButton *contactPlusButton;
@property (weak, nonatomic) IBOutlet UIButton *contactSureButton;
@property (weak, nonatomic) IBOutlet UIButton *contactCancelButton;
//Accessory
@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UIImageView *accessoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *accessoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accessoryPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *accessoryBatchNumView;
@property (weak, nonatomic) IBOutlet UILabel *accessoryBatchNumLabel;
@property (weak, nonatomic) IBOutlet UIView *accessoryKindNumView;
@property (weak, nonatomic) IBOutlet UILabel *accessoryKindNumLabel;
@property (weak, nonatomic) IBOutlet UIView *accessoryDateView;
@property (weak, nonatomic) IBOutlet UILabel *accessoryDateLabel;
@property (weak, nonatomic) IBOutlet UILabel  *accessoryCartNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *accessoryMinusButton;
@property (weak, nonatomic) IBOutlet UIButton *accessoryplusButton;
@property (weak, nonatomic) IBOutlet UIButton *accessorySureButton;
@property (weak, nonatomic) IBOutlet UIButton *accessoryCancelButton;
//Contact Batch None Stock
@property (strong, nonatomic) IBOutlet UIView *batchNoneStockView;
@property (weak, nonatomic) IBOutlet UIImageView *preContactImageView;
@property (weak, nonatomic) IBOutlet UILabel *preContactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *preContactPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *batchNoneStockSureBtn;
@property (weak, nonatomic) IBOutlet UIButton *batchNoneStockCancelBtn;
@property (weak, nonatomic) IBOutlet UIView *batchNoneDegreeView;
@property (weak, nonatomic) IBOutlet UILabel *batchNoneDegreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *batchNoneNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *batchNonePlusButton;
@property (weak, nonatomic) IBOutlet UIButton *batchNoneMinusButton;
//Accessory Batch None Stock
@property (strong, nonatomic) IBOutlet UIView *accessoryNoneStockView;
@property (weak, nonatomic) IBOutlet UIImageView *preAccessoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *preAccessoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *preAccessoryPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *preAccessoryNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *preAccessorySureButton;
@property (weak, nonatomic) IBOutlet UIButton *preAccessoryCancelButton;

@property (strong, nonatomic) IPCGlassParameterViewMode * parameterViewMode;
@property (assign, nonatomic) ContactLenSpecType contactSpecType;
@property (copy, nonatomic) void(^CompleteBlock)();


@end

@implementation IPCGlassParameterView


- (instancetype)initWithFrame:(CGRect)frame Complete:(void (^)())complete
{
    self = [super initWithFrame:frame];
    if (self) {
        self.CompleteBlock = complete;
        currentDegreeStock = 1;
        self.contactSpecType = ContactLenSpecTypeDegree;
        isOpenBooking = NO;
        
        UIView *mainView = [UIView jk_loadInstanceFromNibWithName:@"IPCGlassParameterView" owner:self];
        [mainView setFrame:frame];
        [self addSubview:mainView];
        
        [self.normalLensView addBorder:10 Width:0];
        [self.contactLensView addBorder:10 Width:0];
        [self.accessoryView addBorder:10 Width:0];
        [self.batchNoneStockView addBorder:10 Width:0];
        [self.accessoryNoneStockView addBorder:10 Width:0];
        
        [self.leftParameterView addBorder:5 Width:0.7];
        [self.rightParameterView addBorder:5 Width:0.7];
        
        [self.contactDegreeView addBorder:5 Width:0.7];
        [self.batchNoneDegreeView addBorder:5 Width:0.7];
        [self.contactBatchNumView addBorder:5 Width:0.7];
        [self.accessoryBatchNumView addBorder:5 Width:0.7];
        
        [self.contactKindNumView addBorder:5 Width:0.7];
        [self.accessoryKindNumView addBorder:5 Width:0.7];
        
        [self.contactDateView addBorder:5 Width:0.7];
        [self.accessoryDateView addBorder:5 Width:0.7];
        [self.contactImageView addBorder:5 Width:0.7];
        [self.preContactImageView addBorder:5 Width:0.7];
        [self.accessoryImageView addBorder:5 Width:0.7];
        [self.normalLensImageView addBorder:5 Width:0.7];
        [self.preAccessoryImageView addBorder:5 Width:0.7];
        
        [self.contactSureButton setBackgroundColor:COLOR_RGB_BLUE];
        [self.lensSureButton setBackgroundColor:COLOR_RGB_BLUE];
        [self.accessorySureButton setBackgroundColor:COLOR_RGB_BLUE];
        [self.batchNoneStockSureBtn setBackgroundColor:COLOR_RGB_BLUE];
        [self.preAccessorySureButton setBackgroundColor:COLOR_RGB_BLUE];
        
        [self.contactSureButton addSignleCorner:UIRectCornerBottomLeft Size:10];
        [self.lensSureButton addSignleCorner:UIRectCornerBottomLeft Size:10];
        [self.accessorySureButton addSignleCorner:UIRectCornerBottomLeft Size:10];
        [self.batchNoneStockSureBtn addSignleCorner:UIRectCornerBottomLeft Size:10];
        [self.preAccessorySureButton addSignleCorner:UIRectCornerBottomLeft Size:10];
        
        [self.lensCancelButton addSignleCorner:UIRectCornerBottomRight Size:10];
        [self.contactCancelButton addSignleCorner:UIRectCornerBottomRight Size:10];
        [self.accessoryCancelButton addSignleCorner:UIRectCornerBottomRight Size:10];
        [self.batchNoneStockCancelBtn addSignleCorner:UIRectCornerBottomRight Size:10];
        [self.preAccessoryCancelButton addSignleCorner:UIRectCornerBottomRight Size:10];;
    }
    return self;
}


- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        if (_glasses.stock <= 0)isOpenBooking = YES;
        
        if ([_glasses filterType] == IPCTopFilterTypeReadingGlass) {
            [self.leftTitleLabel setText:@"度数"];
            [self.rightParameterView setHidden:YES];
        }else if([_glasses filterType] == IPCTopFilterTypeLens){
            [self.leftTitleLabel setText:@"球镜/SPH"];
            [self.rightParameterView setHidden:NO];
        }else{
            self.parameterViewMode = [[IPCGlassParameterViewMode alloc]initWithGlasses:_glasses];
        }
        [self show];
        [self refreshSureButtonStatus];
        [self refreshContactLensSureStatus];
    }
}

#pragma mark //Parse ContactLens Specification
//Refresh the batch choose contact lenses specification parameters
- (void)queryContactLensSpecification{
    __weak typeof (self) weakSelf = self;
    [self.parameterViewMode getContactLensSpecification:currentContactDegreeID CompleteBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf updateContactParamater];
    }];
}

- (void)queryAccessorySpecification{
    __weak typeof (self) weakSelf = self;
    [self.parameterViewMode getAccessorySpecification:self.glasses.glassesID CompleteBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf updateAccessoryParamater];
    }];
}

#pragma mark //Set UI
- (void)show{
    if ([_glasses filterType] == IPCTopFilterTypeReadingGlass || [_glasses filterType] == IPCTopFilterTypeLens) {
        [self loadBatchNormalLensView];
    }else if([_glasses filterType] == IPCTopFilterTypeContactLenses){
        if(isOpenBooking){
            [self loadBatchNoneStockView];
        }else{
            [self loadBatchContactLensView];
        }
    }else{
        if(isOpenBooking){
            [self loadAccessoryNoneStockView];
        }else{
            [self loadBatchAccessoryView];
        }
    }
}


- (void)loadBatchNormalLensView{
    [self addSubview:self.normalLensView];
    [self.normalLensView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    [self.normalLensImageView setImageURL:self.glasses.thumbImage.imageURL];
    [self.normalLensNameLabel setText:self.glasses.glassName];
    [self.normalLensPriceLabel setText:[NSString stringWithFormat:@"￥%.f",self.glasses.price]];
}

- (void)loadBatchContactLensView{
    [self addSubview:self.contactLensView];
    [self.contactLensView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    [self.contactImageView setImageURL:self.glasses.thumbImage.imageURL];
    [self.contactNameLabel setText:self.glasses.glassName];
    [self.contactPriceLabel setText:[NSString stringWithFormat:@"￥%.f",self.glasses.price]];
}

- (void)loadBatchAccessoryView{
    [self addSubview:self.accessoryView];
    [self.accessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    [self.accessoryImageView setImageURL:self.glasses.thumbImage.imageURL];
    [self.accessoryNameLabel setText:self.glasses.glassName];
    [self.accessoryPriceLabel setText:[NSString stringWithFormat:@"￥%.f",self.glasses.price]];
    [self queryAccessorySpecification];
}


- (void)loadBatchNoneStockView{
    [self addSubview:self.batchNoneStockView];
    [self.batchNoneStockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    [self.preContactImageView setImageURL:self.glasses.thumbImage.imageURL];
    [self.preContactNameLabel setText:self.glasses.glassName];
    [self.preContactPriceLabel setText:[NSString stringWithFormat:@"￥%.f",self.glasses.price]];
}

- (void)loadAccessoryNoneStockView{
    [self addSubview:self.accessoryNoneStockView];
    [self.accessoryNoneStockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    [self. preAccessoryImageView  setImageURL:self.glasses.thumbImage.imageURL];
    [self.preAccessoryNameLabel setText:self.glasses.glassName];
    [self.preAccessoryPriceLabel setText:[NSString stringWithFormat:@"￥%.f",self.glasses.price]];
    [self.preAccessoryNumLabel setText:[NSString stringWithFormat:@"%ld",[self cartItemAccessory].count]];
}

- (void)showParameterTableView:(UITapGestureRecognizer *)sender InView:(UIView *)contentView
{
    [self.parameterTableView addBorder:3 Width:1];
    [self.parameterTableView setFrame:CGRectMake(sender.view.jk_left + contentView.jk_left, sender.view.jk_bottom + contentView.jk_top, sender.view.jk_width, 300)];
    [self.parameterTableView setTableFooterView:[[UIView alloc]init]];
    [self addSubview:self.parameterTableView];
    [self.parameterTableView reloadData];
    
    __block NSInteger startIndex = 0;
    if ([self.glasses filterType] == IPCTopFilterTypeLens && isLeft){
        startIndex = [[IPCAppManager batchSphs] indexOfObject:@"0.00"];
        [self.parameterTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:startIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

//Refresh Sure Button Status
- (void)refreshSureButtonStatus{
    __weak typeof (self) weakSelf = self;
    if ([_glasses filterType] == IPCTopFilterTypeAccessory){
        [[[RACSignal combineLatest:@[RACObserve(self, self.accessoryBatchNumLabel.text), RACObserve(self, self.accessoryKindNumLabel.text), RACObserve(self, self.accessoryDateLabel.text),RACObserve(self, self.accessoryCartNumLabel.text)] reduce:^id(NSString *batchNum,NSString * kind,NSString *date,NSString *cartNum){
            return @(batchNum.length && kind.length && date.length && [cartNum integerValue] > 0);
        }] distinctUntilChanged] subscribeNext:^(NSNumber *valid) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (valid.boolValue) {
                [strongSelf.accessorySureButton setEnabled:YES];
                strongSelf.accessorySureButton.alpha = 1;
            }else{
                [strongSelf.accessorySureButton setEnabled:NO];
                strongSelf.accessorySureButton.alpha = 0.5;
            }
        }];
    }else{
        [[[RACSignal combineLatest:@[RACObserve(self, self.leftParameterLabel.text),RACObserve(self, self.rightParameterLabel.text),RACObserve(self, self.lensNumLabel.text)] reduce:^id(NSString *leftParametr,NSString *rightParameter,NSString *cartNum){
            return  @((leftParametr.length || rightParameter.length) && [cartNum integerValue] > 0);
        }]distinctUntilChanged] subscribeNext:^(NSNumber *valid) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if (valid.boolValue) {
                [strongSelf.lensSureButton setEnabled:YES];
                strongSelf.lensSureButton.alpha = 1;
            }else{
                [strongSelf.lensSureButton setEnabled:NO];
                strongSelf.lensSureButton.alpha = 0.5;
            }
        }];
    }
}

- (void)refreshContactLensSureStatus{
    if ([self.batchNoneStockView superview]) {
        if (self.batchNoneDegreeLabel.text.length && [self.batchNoneNumLabel.text integerValue] > 0) {
            [self.batchNoneStockSureBtn setEnabled:YES];
            self.batchNoneStockSureBtn.alpha = 1;
        }else{
            [self.batchNoneStockSureBtn setEnabled:NO];
            self.batchNoneStockSureBtn.alpha = 0.5;
        }
    }else{
        if (self.contactDegreeLabel.text.length && self.contactBatchNumLabel.text.length && self.contactKindNumLabel.text.length && self.contactDateLabel.text.length && [self.contactCartNumLabel.text integerValue] > 0) {
            [self.contactSureButton setEnabled:YES];
            self.contactSureButton.alpha = 1;
        }else{
            [self.contactSureButton setEnabled:NO];
            self.contactSureButton.alpha = 0.5;
        }
    }
}

#pragma mark //Clicked Events
- (IBAction)completeAction:(id)sender {
    [self removeCover];
}

- (IBAction)cancelAddAction:(id)sender {
    [self removeCover];
}

- (IBAction)tapBgAction:(id)sender {
    if ([self.parameterTableView superview]) {
        [self.parameterTableView removeFromSuperview];
    }else{
        [self removeCover];
    }
}

/**
 *  Lenses or glasses for batch option
 */
- (IBAction)leftChooseParameterAction:(UITapGestureRecognizer *)sender {
    if (isLeft && [self.parameterTableView superview]){
        [self.parameterTableView removeFromSuperview];
    }else{
        isLeft = YES;
        [self showParameterTableView:sender InView:self.normalLensView];
    }
}

- (IBAction)rightChooseParameterAction:(id)sender {
    if (!isLeft && [self.parameterTableView superview]){
        [self.parameterTableView removeFromSuperview];
    }else{
        isLeft = NO;
        [self showParameterTableView:sender InView:self.normalLensView];
    }
}

/**
 *  Contact lenses mass selection specifications
 */
- (IBAction)contactLensParameterAction:(UITapGestureRecognizer *)sender {
    if ( [self.parameterTableView superview]){
        [self.parameterTableView removeFromSuperview];
    }else{
        switch ([sender.view tag]) {
            case 1:
                self.contactSpecType = ContactLenSpecTypeDegree;
                break;
            case 2:
                self.contactSpecType = ContactLenSpecTypeBatchNum;
                break;
            case 3:
                self.contactSpecType = ContactLenSpecTypeKindNum;
                break;
            case 4:
                self.contactSpecType = ContactLenSpecTypeDate;
                break;
            default:
                break;
        }
        if (self.contactSpecType != ContactLenSpecTypeDegree &&  !self.contactDegreeLabel.text.length) {
            [IPCUIKit showError:@"请先选择度数!"];
            return;
        }
        if (!self.parameterViewMode.contactDegreeList.count && !isOpenBooking)return;
        
        [self showParameterTableView:sender InView: [self.batchNoneStockView superview] ? self.batchNoneStockView : self.contactLensView];
    }
}

/**
 *  Accessory  mass selection specifications
 */

- (IBAction)accessoryBatchParameterAction:(UITapGestureRecognizer *)sender {
    if ( [self.parameterTableView superview]){
        [self.parameterTableView removeFromSuperview];
    }else{
        switch ([sender.view tag]) {
            case 1:
                self.contactSpecType = ContactLenSpecTypeBatchNum;
                break;
            case 2:
                self.contactSpecType = ContactLenSpecTypeKindNum;
                break;
            case 3:
                self.contactSpecType = ContactLenSpecTypeDate;
                break;
            default:
                break;
        }
        [self showParameterTableView:sender InView:self.accessoryView];
    }
}


//Increase or decrease in the shopping cart
- (IBAction)minusTapAction:(id)sender {
    if ([self.glasses filterType] == IPCTopFilterTypeContactLenses) {
        [[IPCShoppingCart sharedCart] reduceItem:[self cartItemContactLens]];
        if ([self.batchNoneStockView superview]) {
            [self.batchNoneNumLabel setText:[NSString stringWithFormat:@"%d",[self cartItemContactLens].count]];
        }else{
            [self.contactCartNumLabel setText:[NSString stringWithFormat:@"%d",[self cartItemContactLens].count]];
        }
        [self reloadContactLensStatus];
        [self refreshContactLensSureStatus];
    }else if([self.glasses filterType] == IPCTopFilterTypeLens){
        [[IPCShoppingCart sharedCart] reduceItem:[self cartItemLens]];
        [self.lensNumLabel setText:[NSString stringWithFormat:@"%d",[self cartItemLens].count]];
    }else if([self.glasses filterType] == IPCTopFilterTypeReadingGlass){
        [[IPCShoppingCart sharedCart] reduceItem:[self cartItemReadingLens]];
        [self.lensNumLabel setText:[NSString stringWithFormat:@"%d",[self cartItemReadingLens].count]];
    }else{
        [[IPCShoppingCart sharedCart] reduceItem:[self cartItemAccessory]];
        if ([self.accessoryNoneStockView superview]) {
            [self.preAccessoryNumLabel setText:[NSString stringWithFormat:@"%d",[self cartItemAccessory].count]];
        }else{
            [self.accessoryCartNumLabel setText:[NSString stringWithFormat:@"%d",[self cartItemAccessory].count]];
        }
        [self reloadAccessoryStatus];
    }
}

- (IBAction)plusTapAction:(id)sender {
    if ([self.glasses filterType] == IPCTopFilterTypeContactLenses) {
        [self addLensToCart];
        if ([self.batchNoneStockView superview]) {
            [self.batchNoneNumLabel setText:[NSString stringWithFormat:@"%ld",(long)[self cartItemContactLens].count]];
        }else{
            [self.contactCartNumLabel setText:[NSString stringWithFormat:@"%ld",(long)[self cartItemContactLens].count]];
        }
        [self reloadContactLensStatus];
        [self refreshContactLensSureStatus];
    }else if([self.glasses filterType] == IPCTopFilterTypeLens){
        [self addLensToCart];
        [self.lensNumLabel setText:[NSString stringWithFormat:@"%ld",(long)[self cartItemLens].count]];
    }else if([self.glasses filterType] == IPCTopFilterTypeReadingGlass){
        [self addLensToCart];
        [self.lensNumLabel setText:[NSString stringWithFormat:@"%ld",(long)[self cartItemReadingLens].count]];
    }else{
        [self addLensToCart];
        if ([self.accessoryNoneStockView superview]) {
            [self.preAccessoryNumLabel setText:[NSString stringWithFormat:@"%ld",(long)[self cartItemAccessory].count]];
        }else{
            [self.accessoryCartNumLabel setText:[NSString stringWithFormat:@"%ld",(long)[self cartItemAccessory].count]];
        }
        [self reloadAccessoryStatus];
    }
}

- (void)addLensToCart{
    if ([_glasses filterType] == IPCTopFilterTypeLens) {
        [[IPCShoppingCart sharedCart] addGlasses:self.glasses
                                             Sph:self.leftParameterLabel.text.length ? self.leftParameterLabel.text : @"0.00"
                                             Cyl:self.rightParameterLabel.text.length ? self.rightParameterLabel.text : @"0.00"
                                   ReadingDegree:self.leftParameterLabel.text
                                   ContactDegree:self.leftParameterLabel.text
                                        BatchNum:nil
                                         KindNum:nil
                                    ValidityDate:nil
                                       ContactID:nil
                                   IsOpenBooking:NO];
    }else if([_glasses filterType] == IPCTopFilterTypeReadingGlass){
        [[IPCShoppingCart sharedCart] addGlasses:self.glasses
                                             Sph:nil
                                             Cyl:nil
                                   ReadingDegree:self.leftParameterLabel.text
                                   ContactDegree:nil
                                        BatchNum:nil
                                         KindNum:nil
                                    ValidityDate:nil
                                       ContactID:nil
                                   IsOpenBooking:NO];
    }else if([_glasses filterType] == IPCTopFilterTypeContactLenses){
        if ([self.batchNoneStockView superview]) {
            [[IPCShoppingCart sharedCart] addGlasses:self.glasses
                                                 Sph:nil
                                                 Cyl:nil
                                       ReadingDegree:nil
                                       ContactDegree:self.batchNoneDegreeLabel.text
                                            BatchNum:nil
                                             KindNum:nil
                                        ValidityDate:nil
                                           ContactID:nil
                                       IsOpenBooking:YES];
        }else{
            [[IPCShoppingCart sharedCart] addGlasses:self.glasses
                                                 Sph:nil
                                                 Cyl:nil
                                       ReadingDegree:nil
                                       ContactDegree:self.contactDegreeLabel.text
                                            BatchNum:self.contactBatchNumLabel.text
                                             KindNum:self.contactKindNumLabel.text
                                        ValidityDate:self.contactDateLabel.text
                                           ContactID:currentContactDegreeID
                                       IsOpenBooking:NO];
        }
    }else{
        if ([self.accessoryNoneStockView superview]) {
            [[IPCShoppingCart sharedCart] addGlasses:self.glasses
                                                 Sph:nil
                                                 Cyl:nil
                                       ReadingDegree:nil
                                       ContactDegree:nil
                                            BatchNum:nil
                                             KindNum:nil
                                        ValidityDate:nil
                                           ContactID:nil
                                       IsOpenBooking:YES];
        }else{
            [[IPCShoppingCart sharedCart] addGlasses:self.glasses
                                                 Sph:nil
                                                 Cyl:nil
                                       ReadingDegree:nil
                                       ContactDegree:nil
                                            BatchNum:self.accessoryBatchNumLabel.text
                                             KindNum:self.accessoryKindNumLabel.text
                                        ValidityDate:self.accessoryDateLabel.text
                                           ContactID:nil
                                       IsOpenBooking:NO];
        }
    }
}

//According to specification data list
- (IBAction)removerParameterTableViewAction:(id)sender {
    if ([self.parameterTableView superview]) {
        [self.parameterTableView removeFromSuperview];
    }
}

//Remove page
- (void)removeCover{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
    
    if (self.CompleteBlock)
        self.CompleteBlock();
}

//Select PreSell Method
- (IBAction)onPreSellAction:(id)sender {
    if (!isOpenBooking) {
        if ([self.glasses filterType] == IPCTopFilterTypeContactLenses) {
            [self.contactLensView removeFromSuperview];
            [self loadBatchNoneStockView];
            [self refreshContactLensSureStatus];
        }
        else{
            [self.accessoryView removeFromSuperview];
            [self loadAccessoryNoneStockView];
        }
    }
}

- (IBAction)onNormalSellAction:(id)sender {
    if (!isOpenBooking) {
        if ([self.glasses filterType] == IPCTopFilterTypeContactLenses) {
            [self.batchNoneStockView removeFromSuperview];
            [self loadBatchContactLensView];
            [self queryContactLensSpecification];
            [self refreshContactLensSureStatus];
        }else{
            [self.accessoryNoneStockView removeFromSuperview];
            [self loadBatchAccessoryView];
        }
    }
}

#pragma mark //Query Shopping Cart Item
- (IPCShoppingCartItem *)cartItemLens{
    IPCShoppingCartItem * item = [[IPCShoppingCart sharedCart] batchItemForGlasses:self.glasses Sph:self.leftParameterLabel.text.length ? self.leftParameterLabel.text : @"0.00" Cyl:self.rightParameterLabel.text.length ?  self.rightParameterLabel.text : @"0.00" ReadingDegree:nil ContactDegree:nil BatchNum:nil KindNum:nil ValidityDate:nil IsOpenBooking:NO];
    return item;
}

- (IPCShoppingCartItem *)cartItemReadingLens{
    IPCShoppingCartItem * item = [[IPCShoppingCart sharedCart] batchItemForGlasses:self.glasses Sph:nil Cyl:nil ReadingDegree:self.leftParameterLabel.text ContactDegree:nil BatchNum:nil KindNum:nil ValidityDate:nil IsOpenBooking:NO];
    return item;
}

- (IPCShoppingCartItem *)cartItemContactLens{
    if ([self.batchNoneStockView superview]) {
        IPCShoppingCartItem * item = [[IPCShoppingCart sharedCart] batchItemForGlasses:self.glasses Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:self.batchNoneDegreeLabel.text BatchNum:nil KindNum:nil ValidityDate:nil IsOpenBooking:YES];
        return item;
    }
    IPCShoppingCartItem * item = [[IPCShoppingCart sharedCart] batchItemForGlasses:self.glasses Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:self.contactDegreeLabel.text BatchNum:self.contactBatchNumLabel.text KindNum:self.contactKindNumLabel.text ValidityDate:self.contactDateLabel.text IsOpenBooking:NO];
    return item;
}


- (IPCShoppingCartItem *)cartItemAccessory{
    if ([self.accessoryNoneStockView superview]) {
        IPCShoppingCartItem * item = [[IPCShoppingCart sharedCart] batchItemForGlasses:self.glasses Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:nil BatchNum:nil KindNum:nil ValidityDate:nil IsOpenBooking:YES];
        return item;
    }
    IPCShoppingCartItem * item = [[IPCShoppingCart sharedCart] batchItemForGlasses:self.glasses Sph:nil Cyl:nil ReadingDegree:nil ContactDegree:nil BatchNum:self.accessoryBatchNumLabel.text KindNum:self.accessoryKindNumLabel.text ValidityDate:self.accessoryDateLabel.text IsOpenBooking:NO];
    return item;
}


#pragma mark //Update Lens Parameter
- (void)updateContactParamater
{
    if ([[self.parameterViewMode batchNumArray] count])
        [self.contactBatchNumLabel setText:[self.parameterViewMode batchNumArray][batchNumTag]];
    
    if ([[self.parameterViewMode kindNumArray:self.contactBatchNumLabel.text] count])
        [self.contactKindNumLabel setText:[self.parameterViewMode kindNumArray:self.contactBatchNumLabel.text][kindNumTag]];
    
    if ([[self.parameterViewMode validityDateArray:self.contactBatchNumLabel.text KindNum:self.contactKindNumLabel.text] count]) {
        NSDictionary * dateDic = [self.parameterViewMode validityDateArray:self.contactBatchNumLabel.text KindNum:self.contactKindNumLabel.text][validityDateTag];
        [self.contactDateLabel setText:dateDic[@"expireDate"]];
        currentDegreeStock = [dateDic[@"bizStock"]integerValue];
    }
    [self.contactCartNumLabel setText:[NSString stringWithFormat:@"%d",[self cartItemContactLens].count]];
    [self reloadContactLensStatus];
    [self refreshContactLensSureStatus];
}


- (void)updateAccessoryParamater{
    if ([self.parameterViewMode accessoryBatchNumArray].count) {
        [self.accessoryBatchNumLabel setText:[self.parameterViewMode accessoryBatchNumArray][batchNumTag]];
    }
    
    if ([self.parameterViewMode accessoryKindNumArray:self.accessoryBatchNumLabel.text].count) {
        [self.accessoryKindNumLabel setText:[self.parameterViewMode accessoryKindNumArray:self.accessoryBatchNumLabel.text][kindNumTag]];
    }
    
    if ([self.parameterViewMode accessoryValidityDateArray:self.accessoryBatchNumLabel.text KindNum:self.accessoryKindNumLabel.text].count) {
        [self.accessoryDateLabel setText:[self.parameterViewMode accessoryValidityDateArray:self.accessoryBatchNumLabel.text KindNum:self.accessoryKindNumLabel.text][validityDateTag]];
        currentAccessoryStock = [self.parameterViewMode accessoryStock:self.accessoryBatchNumLabel.text KindNum:self.accessoryKindNumLabel.text Date:self.accessoryDateLabel.text];
    }
    [self.accessoryCartNumLabel setText:[NSString stringWithFormat:@"%ld",[self cartItemAccessory].count]];
    [self reloadAccessoryStatus];
}

#pragma mark //Reload Lens Parameter View Status
//Refresh the lens or relaxing increase or decrease in a shopping cart button state
- (void)reloadLensStatus{
    self.lensMinusButton.enabled = YES;
    if (self.leftParameterLabel.text.length || self.rightParameterLabel.text.length)
        self.lensPlusButton.enabled = YES;
}

//Refresh the contact lenses to increase quantity button state
- (void)reloadContactLensStatus{
    //The user to select the number of the specifications of the contact lenses before they can start editing
    self.contactMinusButton.enabled = YES;
    if ([self.batchNoneStockView superview]) {
        if (self.batchNoneDegreeLabel.text.length <= 0) {
            self.batchNonePlusButton.enabled = NO;
        }else{
            self.batchNonePlusButton.enabled = YES;
        }
    }else{
        if ([self cartItemContactLens]) {
            if ([self cartItemContactLens].count >= currentDegreeStock || !self.contactDegreeLabel.text.length) {
                self.contactPlusButton.enabled = NO;
            }else{
                self.contactPlusButton.enabled = YES;
            }
        }else{
            self.contactPlusButton.enabled = currentDegreeStock > 0 ? YES: NO;
        }
    }
}

//Refresh the Accessory  to increase quantity button state
- (void)reloadAccessoryStatus{
    //The user to select the number of the specifications of the accessory before they can start editing
    self.accessoryMinusButton.enabled = YES;
    if ([self cartItemAccessory]) {
        if ([self cartItemAccessory].count >= currentAccessoryStock) {
            self.accessoryplusButton.enabled = NO;
        }else{
            self.accessoryplusButton.enabled = YES;
        }
    }else{
        self.accessoryplusButton.enabled = currentAccessoryStock > 0 ? YES : NO;
    }
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_glasses filterType] == IPCTopFilterTypeLens){
        return isLeft ? [[IPCAppManager batchSphs]count] : [[IPCAppManager batchCyls]count];
    }else if ([_glasses filterType] == IPCTopFilterTypeReadingGlass){
        return [[IPCAppManager batchReadingDegrees]count];
    }else if([_glasses filterType] == IPCTopFilterTypeContactLenses){
        if (self.contactSpecType == ContactLenSpecTypeDegree) {
            if ([self.batchNoneStockView superview])
                return [[IPCAppManager batchDegrees] count];
            return [self.parameterViewMode.contactDegreeList count];
        }else if (self.contactSpecType == ContactLenSpecTypeBatchNum){
            return [self.parameterViewMode batchNumArray].count;
        }else if (self.contactSpecType == ContactLenSpecTypeKindNum){
            return [self.parameterViewMode kindNumArray:self.contactBatchNumLabel.text].count;
        }else{
            return [self.parameterViewMode validityDateArray:self.contactBatchNumLabel.text KindNum:self.contactKindNumLabel.text].count;
        }
    }else{
        if (self.contactSpecType == ContactLenSpecTypeBatchNum){
            return [self.parameterViewMode accessoryBatchNumArray].count;
        }else if (self.contactSpecType == ContactLenSpecTypeKindNum){
            return [self.parameterViewMode accessoryKindNumArray:self.accessoryBatchNumLabel.text].count;
        }else{
            return [self.parameterViewMode accessoryValidityDateArray:self.accessoryBatchNumLabel.text KindNum:self.accessoryKindNumLabel.text].count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightThin]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([_glasses filterType] == IPCTopFilterTypeLens){
        [cell.textLabel setText:isLeft ? [IPCAppManager batchSphs][indexPath.row] : [IPCAppManager batchCyls][indexPath.row]];
    }else if([_glasses filterType] == IPCTopFilterTypeReadingGlass){
        [cell.textLabel setText:[IPCAppManager batchReadingDegrees][indexPath.row]];
    }else if([_glasses filterType] == IPCTopFilterTypeContactLenses){
        if (self.contactSpecType == ContactLenSpecTypeDegree) {
            if ([self.batchNoneStockView superview]) {
                [cell.textLabel setText:[IPCAppManager batchDegrees][indexPath.row]];
            }else{
                BatchParameterObject * parameter = self.parameterViewMode.contactDegreeList[indexPath.row];
                if (parameter) {
                    [cell.textLabel setText:parameter.degree];
                }
            }
        }else if (self.contactSpecType == ContactLenSpecTypeBatchNum){
            [cell.textLabel setText:[self.parameterViewMode batchNumArray][indexPath.row]];
        }else if (self.contactSpecType == ContactLenSpecTypeKindNum){
            [cell.textLabel setText:[self.parameterViewMode kindNumArray:self.contactBatchNumLabel.text][indexPath.row]];
        }else{
            NSDictionary * dateDic = [self.parameterViewMode validityDateArray:self.contactBatchNumLabel.text KindNum:self.contactKindNumLabel.text][indexPath.row];
            [cell.textLabel setText:dateDic[@"expireDate"]];
        }
    }else{
        if (self.contactSpecType == ContactLenSpecTypeBatchNum){
            [cell.textLabel setText:[self.parameterViewMode accessoryBatchNumArray][indexPath.row]];
        }else if (self.contactSpecType == ContactLenSpecTypeKindNum){
            [cell.textLabel setText:[self.parameterViewMode accessoryKindNumArray:self.accessoryBatchNumLabel.text][indexPath.row]];
        }else{
            [cell.textLabel setText:[self.parameterViewMode accessoryValidityDateArray:self.accessoryBatchNumLabel.text KindNum:self.accessoryKindNumLabel.text][indexPath.row]];
        }
    }
    return cell;
}

#pragma mark //UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_glasses filterType] == IPCTopFilterTypeLens) {
        if (isLeft) {
            [self.leftParameterLabel setText:[IPCAppManager batchSphs][indexPath.row]];
        }else{
            [self.rightParameterLabel setText:[IPCAppManager batchCyls][indexPath.row]];
        }
        [self.lensNumLabel setText:[NSString stringWithFormat:@"%d",[self cartItemLens].count]];
        [self reloadLensStatus];
    }else if([_glasses filterType] == IPCTopFilterTypeReadingGlass){
        [self.leftParameterLabel setText:[IPCAppManager batchReadingDegrees][indexPath.row]];
        [self.lensNumLabel setText:[NSString stringWithFormat:@"%d",[self cartItemReadingLens].count]];
        [self reloadLensStatus];
    }else{
        if (self.contactSpecType == ContactLenSpecTypeDegree) {
            if ([self.batchNoneStockView superview]) {
                [self.batchNoneDegreeLabel setText:[IPCAppManager batchDegrees][indexPath.row]];
                [self.batchNoneNumLabel setText:[NSString stringWithFormat:@"%d",[self cartItemContactLens].count]];
                [self reloadContactLensStatus];
                [self refreshContactLensSureStatus];
            }else{
                BatchParameterObject * parameter = self.parameterViewMode.contactDegreeList[indexPath.row];
                if (parameter) {
                    currentContactDegreeID = parameter.batchID;
                    [self.contactDegreeLabel setText:parameter.degree];
                    [self queryContactLensSpecification];
                    batchNumTag   = 0;
                    kindNumTag     = 0;
                    validityDateTag = 0;
                }
            }
        }else if (self.contactSpecType == ContactLenSpecTypeBatchNum){
            batchNumTag    = indexPath.row;
            kindNumTag     = 0;
            validityDateTag = 0;
            [_glasses filterType] == IPCTopFilterTypeContactLenses ?  [self updateContactParamater] : [self updateAccessoryParamater];
        }else if (self.contactSpecType == ContactLenSpecTypeKindNum){
            kindNumTag     = indexPath.row;
            validityDateTag = 0;
            [_glasses filterType] == IPCTopFilterTypeContactLenses ?  [self updateContactParamater] : [self updateAccessoryParamater];
        }else{
            validityDateTag = indexPath.row;
            [_glasses filterType] == IPCTopFilterTypeContactLenses ?  [self updateContactParamater] : [self updateAccessoryParamater];
        }
    }
    [tableView removeFromSuperview];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
