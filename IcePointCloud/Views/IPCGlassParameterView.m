//
//  GlassParameterView.m
//  IcePointCloud
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCGlassParameterView.h"
#import "IPCGlassParameterViewMode.h"
#import "IPCBatchParameterCell.h"

static NSString * const identifier = @"ChooseBatchParameterCellIdentifier";

typedef NS_ENUM(NSInteger, ContactLenSpecType){
    ContactLenSpecTypeDegree,
    ContactLenSpecTypeBatchNum,
    ContactLenSpecTypeKindNum,
    ContactLenSpecTypeDate
};

@interface IPCGlassParameterView()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
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
    //Is Presell
    BOOL           isOpenBooking;
    //Customsized Parameter
    NSArray   *   customsizedArray;
    //CustomsizedLens Funcation
    NSMutableArray<NSString *> * customsizedLensFunArray;
}

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
//Lens  ReadingLens
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *normalLensHeight;
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
@property (weak, nonatomic) IBOutlet UIView *normalLensStepperView;
//Parameter TableView
@property (strong, nonatomic) IBOutlet UITableView *parameterTableView;
//ContactLens
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactLensHeight;
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
@property (weak, nonatomic) IBOutlet UIView *contactLensStepperView;
//Accessory
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accessoryLensHeight;
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
@property (weak, nonatomic) IBOutlet UIView *accessoryStepperView;
//Contact Batch None Stock
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactNoneStockHeight;
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
@property (weak, nonatomic) IBOutlet UIView *contactNoneStepperView;
//Accessory Batch None Stock
@property (strong, nonatomic) IBOutlet UIView *accessoryNoneStockView;
@property (weak, nonatomic) IBOutlet UIImageView *preAccessoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *preAccessoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *preAccessoryPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *preAccessoryNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *preAccessorySureButton;
@property (weak, nonatomic) IBOutlet UIButton *preAccessoryCancelButton;
//Customsized Lens
@property (strong, nonatomic) IBOutlet UIView *customsizedParameterView;
@property (weak, nonatomic) IBOutlet UIImageView *customsizedImageView;
@property (weak, nonatomic) IBOutlet UILabel *customsizedNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *customsizedPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *refractionView;
@property (weak, nonatomic) IBOutlet UIView *lensFunctionView;
@property (weak, nonatomic) IBOutlet UIView *lensStyleView;
@property (weak, nonatomic) IBOutlet UIView *thinView;
@property (weak, nonatomic) IBOutlet UIView *upsetView;
@property (weak, nonatomic) IBOutlet UIView *moveHeartView;
@property (weak, nonatomic) IBOutlet IQTextView *customsizedMemoView;
@property (weak, nonatomic) IBOutlet UIButton *customsizedSureButton;
@property (weak, nonatomic) IBOutlet UIButton *customsizedCancleButton;
@property (weak, nonatomic) IBOutlet UILabel *refractionLabel;
@property (weak, nonatomic) IBOutlet UILabel *lensFunctionLabel;
@property (weak, nonatomic) IBOutlet UILabel *lensStyleLabel;
@property (weak, nonatomic) IBOutlet UILabel *thinLabel;
@property (weak, nonatomic) IBOutlet UILabel *upsetLabel;
@property (weak, nonatomic) IBOutlet UILabel *moveHeartLabel;
@property (strong, nonatomic) IPCGlassParameterViewMode * parameterViewMode;
@property (assign, nonatomic) ContactLenSpecType contactSpecType;
@property (assign, nonatomic) NSInteger   customsizedType;
@property (copy, nonatomic) void(^CompleteBlock)();

@end

@implementation IPCGlassParameterView

- (instancetype)initWithFrame:(CGRect)frame Complete:(void (^)())complete
{
    self = [super initWithFrame:frame];
    if (self) {
        self.CompleteBlock = complete;
        customsizedArray = @[@[@"1.601", @"1.670", @"1.740"],
                             @[@"无", @"双光", @"内渐进", @"外渐进", @"防蓝光", @"抗疲劳", @"染色", @"变色", @"偏光"],
                             @[@"单焦点", @"多焦点"],
                             @[@"是", @"否"],
                             @[@"0", @"+1", @"+2", @"+3", @"+4"],
                             @[@"0", @"5", @"6", @"7", @"8", @"9"]];
        customsizedLensFunArray  = [[NSMutableArray alloc]init];
        
        UIView *mainView = [UIView jk_loadInstanceFromNibWithName:@"IPCGlassParameterView" owner:self];
        [mainView setFrame:frame];
        [self addSubview:mainView];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.normalLensView addBorder:10 Width:0];
    [self.contactLensView addBorder:10 Width:0];
    [self.accessoryView addBorder:10 Width:0];
    [self.batchNoneStockView addBorder:10 Width:0];
    [self.accessoryNoneStockView addBorder:10 Width:0];
    [self.customsizedParameterView addBorder:10 Width:0];
    
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
    [self.customsizedImageView addBorder:5 Width:0.7];
    [self.refractionView addBorder:5 Width:0.7];
    [self.lensStyleView addBorder:5 Width:0.7];
    [self.lensFunctionView addBorder:5 Width:0.7];
    [self.thinView addBorder:5 Width:0.7];
    [self.upsetView addBorder:5 Width:0.7];
    [self.moveHeartView addBorder:5 Width:0.7];
    [self.customsizedMemoView addBorder:5 Width:0.7];
    
    [self.contactSureButton setBackgroundColor:COLOR_RGB_BLUE];
    [self.lensSureButton setBackgroundColor:COLOR_RGB_BLUE];
    [self.accessorySureButton setBackgroundColor:COLOR_RGB_BLUE];
    [self.batchNoneStockSureBtn setBackgroundColor:COLOR_RGB_BLUE];
    [self.preAccessorySureButton setBackgroundColor:COLOR_RGB_BLUE];
    [self.customsizedSureButton setBackgroundColor:COLOR_RGB_BLUE];
    
    [self.contactSureButton addSignleCorner:UIRectCornerBottomLeft Size:10];
    [self.lensSureButton addSignleCorner:UIRectCornerBottomLeft Size:10];
    [self.accessorySureButton addSignleCorner:UIRectCornerBottomLeft Size:10];
    [self.batchNoneStockSureBtn addSignleCorner:UIRectCornerBottomLeft Size:10];
    [self.preAccessorySureButton addSignleCorner:UIRectCornerBottomLeft Size:10];
    [self.customsizedSureButton addSignleCorner:UIRectCornerBottomLeft Size:10];
    [self.customsizedMemoView addSignleCorner:UIRectCornerAllCorners Size:4];
    [self.customsizedMemoView setPlaceholder:@"请输入商品备注信息..."];
    
    [self.lensCancelButton addSignleCorner:UIRectCornerBottomRight Size:10];
    [self.contactCancelButton addSignleCorner:UIRectCornerBottomRight Size:10];
    [self.accessoryCancelButton addSignleCorner:UIRectCornerBottomRight Size:10];
    [self.batchNoneStockCancelBtn addSignleCorner:UIRectCornerBottomRight Size:10];
    [self.preAccessoryCancelButton addSignleCorner:UIRectCornerBottomRight Size:10];
    [self.customsizedCancleButton addSignleCorner:UIRectCornerBottomRight Size:10];
}

- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        [self.backgroundImageView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.2]];
        if (_glasses.stock <= 0)isOpenBooking = YES;
        [self show];
    }
}

- (void)setCartItem:(IPCShoppingCartItem *)cartItem{
    _cartItem = cartItem;
    
    if (_cartItem) {
        _glasses = _cartItem.glasses;
        isOpenBooking = _cartItem.isPreSell;
        [self show];
        [self showCartItemParameter];
    }
}

#pragma mark //Parse ContactLens Specification
//Refresh the batch choose contact lenses specification parameters
- (void)queryContactLensSpecification:(BOOL)isUpdateForm
{
    batchNumTag  = 0;kindNumTag  = 0;validityDateTag = 0;[self.contactCartNumLabel setText:@"0"];
    
    __weak typeof (self) weakSelf = self;
    [self.parameterViewMode getContactLensSpecification:currentContactDegreeID CompleteBlock:^{
        if (isUpdateForm) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf updateContactParamater];
        }
    }];
}

- (void)queryAccessorySpecification:(BOOL)isUpdateForm
{
    __weak typeof (self) weakSelf = self;
    [self.parameterViewMode getAccessorySpecification:self.glasses.glassesID CompleteBlock:^{
        if (isUpdateForm) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf updateAccessoryParamater];
        }
    }];
}

#pragma mark //Set UI
- (void)show{
    if ([_glasses filterType] == IPCTopFilterTypeReadingGlass) {
        [self.leftTitleLabel setText:@"度数"];
        [self.rightParameterView setHidden:YES];
    }else if([_glasses filterType] == IPCTopFilterTypeLens){
        [self.leftTitleLabel setText:@"球镜/SPH"];
        [self.rightParameterView setHidden:NO];
    }else{
        self.parameterViewMode = [[IPCGlassParameterViewMode alloc]initWithGlasses:_glasses];
        if ([self.glasses filterType] == IPCTopFilterTypeContactLenses && !isOpenBooking)
            [self.parameterViewMode queryBatchContactDegreeRequest];
    }
    if ([_glasses filterType] == IPCTopFilterTypeReadingGlass || [_glasses filterType] == IPCTopFilterTypeLens) {
        [self loadBatchNormalLensView];
    }else if([_glasses filterType] == IPCTopFilterTypeContactLenses){
        if(isOpenBooking){
            [self loadBatchNoneStockView];
        }else{
            [self loadBatchContactLensView];
        }
    }else if ([_glasses filterType] == IPCTopFilterTypeCustomized){
        [self loadCustomsizedLensView];
    }else{
        if(isOpenBooking){
            [self loadAccessoryNoneStockView];
        }else{
            [self loadBatchAccessoryView];
        }
    }
    [self refreshSureButtonStatus];
    [self refreshContactLensSureStatus];
}


- (void)loadBatchNormalLensView{
    [self addSubview:self.normalLensView];
    [self.normalLensView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    if (self.cartItem) {
        [self.normalLensStepperView setHidden:YES];
        self.normalLensHeight.constant -= self.contactLensStepperView.jk_height + 15;
    }
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
    if (self.cartItem) {
        [self.contactLensStepperView setHidden:YES];
        self.contactLensHeight.constant -= self.contactLensStepperView.jk_height + 15;
    }
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
    if (self.cartItem) {
        [self.accessoryStepperView setHidden:YES];
        self.accessoryLensHeight.constant -= self.accessoryStepperView.jk_height + 15;
    }else{
        [self queryAccessorySpecification:NO];
    }
    [self.accessoryImageView setImageURL:self.glasses.thumbImage.imageURL];
    [self.accessoryNameLabel setText:self.glasses.glassName];
    [self.accessoryPriceLabel setText:[NSString stringWithFormat:@"￥%.f",self.glasses.price]];
}


- (void)loadBatchNoneStockView{
    [self addSubview:self.batchNoneStockView];
    [self.batchNoneStockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    if (self.cartItem) {
        [self.contactNoneStepperView setHidden:YES];
        self.contactNoneStockHeight.constant -= self.contactNoneStepperView.jk_height + 15;
    }
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
}

- (void)loadCustomsizedLensView{
    [self addSubview:self.customsizedParameterView];
    [self.customsizedParameterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    [self. customsizedImageView  setImageURL:self.glasses.thumbImage.imageURL];
    [self.customsizedNameLabel setText:self.glasses.glassName];
    [self.customsizedPriceLabel setText:[NSString stringWithFormat:@"￥%.f",self.glasses.price]];
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
    if (self.cartItem)return;
    
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
    if (self.cartItem)return;
    
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
    if (self.cartItem) {
        [self updateCartParameter];
    }else{
        [self addLensToCart];
    }
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

#pragma mark //选择参数列表
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

//Customsized Lens selection specifications

- (IBAction)customsizedParameterSelectAction:(UITapGestureRecognizer *)sender {
    if ( [self.parameterTableView superview]){
        [self.parameterTableView removeFromSuperview];
    }else{
        self.customsizedType = [sender.view tag];
        [self showParameterTableView:sender InView:self.customsizedParameterView];
    }
}

#pragma mark //购物车处理
//Increase or decrease in the shopping cart
- (IBAction)minusTapAction:(id)sender {
    NSInteger cartCount = 0;
    if ([self.glasses filterType] == IPCTopFilterTypeContactLenses) {
        if ([self.batchNoneStockView superview]) {
            cartCount = [self.batchNoneNumLabel.text integerValue];
            cartCount--;
            [self.batchNoneNumLabel setText:[NSString stringWithFormat:@"%d", cartCount <= 0 ? 0 : cartCount]];
        }else{
            cartCount = [self.contactCartNumLabel.text integerValue];
            cartCount--;
            [self.contactCartNumLabel setText:[NSString stringWithFormat:@"%d",cartCount <= 0 ? 0 : cartCount]];
        }
        [self reloadContactLensCartStatus];
        [self refreshContactLensSureStatus];
    }else if([self.glasses filterType] == IPCTopFilterTypeLens || [self.glasses filterType] == IPCTopFilterTypeReadingGlass){
        cartCount = [self.lensNumLabel.text integerValue];
        cartCount--;
        [self.lensNumLabel setText:[NSString stringWithFormat:@"%d",cartCount <= 0 ? 0 : cartCount]];
    }else{
        if ([self.accessoryNoneStockView superview]) {
            cartCount = [self.preAccessoryNumLabel.text integerValue];
            cartCount--;
            [self.preAccessoryNumLabel setText:[NSString stringWithFormat:@"%d",cartCount <= 0 ? 0 : cartCount]];
        }else{
            cartCount = [self.accessoryCartNumLabel.text integerValue];
            cartCount--;
            [self.accessoryCartNumLabel setText:[NSString stringWithFormat:@"%d",cartCount <= 0 ? 0 : cartCount]];
        }
        [self reloadAccessoryCartStatus];
    }
}

- (IBAction)plusTapAction:(id)sender {
    NSInteger cartCount = 0;
    if ([self.glasses filterType] == IPCTopFilterTypeContactLenses) {
        if ([self.batchNoneStockView superview]) {
            cartCount = [self.batchNoneNumLabel.text integerValue];
            cartCount++;
            [self.batchNoneNumLabel setText:[NSString stringWithFormat:@"%ld",cartCount]];
        }else{
            cartCount = [self.contactCartNumLabel.text integerValue];
            cartCount++;
            [self.contactCartNumLabel setText:[NSString stringWithFormat:@"%ld",cartCount]];
        }
        [self reloadContactLensCartStatus];
        [self refreshContactLensSureStatus];
    }else if([self.glasses filterType] == IPCTopFilterTypeLens || [self.glasses filterType] == IPCTopFilterTypeReadingGlass){
        cartCount = [self.lensNumLabel.text integerValue];
        cartCount++;
        [self.lensNumLabel setText:[NSString stringWithFormat:@"%ld",cartCount]];
    }else{
        if ([self.accessoryNoneStockView superview]) {
            cartCount = [self.preAccessoryNumLabel.text integerValue];
            cartCount++;
            [self.preAccessoryNumLabel setText:[NSString stringWithFormat:@"%ld",cartCount]];
        }else{
            cartCount = [self.accessoryCartNumLabel.text integerValue];
            cartCount++;
            [self.accessoryCartNumLabel setText:[NSString stringWithFormat:@"%ld",cartCount]];
        }
        [self reloadAccessoryCartStatus];
    }
}

#pragma mark //加入购物车
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
                                   IsOpenBooking:NO
                                           Count:[self.lensNumLabel.text integerValue]];
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
                                   IsOpenBooking:NO
                                           Count:[self.lensNumLabel.text integerValue]];
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
                                       IsOpenBooking:YES
                                               Count:[self.batchNoneNumLabel.text integerValue]];
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
                                       IsOpenBooking:NO
                                               Count:[self.contactCartNumLabel.text integerValue]];
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
                                       IsOpenBooking:YES
                                               Count:[self.preAccessoryNumLabel.text integerValue]];
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
                                       IsOpenBooking:NO
                                               Count:[self.accessoryCartNumLabel.text integerValue]];
        }
    }
}


#pragma mark //移除参数选择列表   移除页面
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

#pragma mark //预售切换
//Select PreSell Method
- (IBAction)onPreSellAction:(id)sender {
    if (!isOpenBooking && !self.cartItem) {
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
    if (!isOpenBooking && !self.cartItem) {
        if ([self.glasses filterType] == IPCTopFilterTypeContactLenses) {
            [self.batchNoneStockView removeFromSuperview];
            [self loadBatchContactLensView];
        }else{
            [self.accessoryNoneStockView removeFromSuperview];
            [self loadBatchAccessoryView];
        }
    }
}

#pragma mark //Query Shopping Cart Item
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

#pragma mark //Show CartItem Parameter
- (void)showCartItemParameter{
    if ([self.glasses filterType] == IPCTopFilterTypeReadingGlass) {
        [self.leftParameterLabel setText:self.cartItem.batchReadingDegree];
    }else if ([self.glasses filterType] == IPCTopFilterTypeLens){
        [self.leftParameterLabel setText:self.cartItem.batchSph];
        [self.rightParameterLabel setText:self.cartItem.bacthCyl];
    }else if ([self.glasses filterType] == IPCTopFilterTypeContactLenses){
        if (isOpenBooking) {
            [self.batchNoneDegreeLabel setText:self.cartItem.contactDegree];
        }else{
            currentContactDegreeID = self.cartItem.contactLensID;
            [self.contactDegreeLabel setText:self.cartItem.contactDegree];
            [self.contactBatchNumLabel setText:self.cartItem.batchNum];
            [self.contactKindNumLabel setText:self.cartItem.kindNum];
            [self.contactDateLabel setText:self.cartItem.validityDate];
        }
    }else if ([self.glasses filterType] == IPCTopFilterTypeAccessory){
        [self.accessoryBatchNumLabel setText:self.cartItem.batchNum];
        [self.accessoryKindNumLabel setText:self.cartItem.kindNum];
        [self.accessoryDateLabel setText:self.cartItem.validityDate];
    }else{
        [customsizedLensFunArray addObjectsFromArray:self.cartItem.lensFuncsArray];
        [self.refractionLabel setText:self.cartItem.IOROptions];
        [self.lensFunctionLabel setText:[self.cartItem.lensFuncsArray componentsJoinedByString:@","]];
        [self.lensStyleLabel setText:self.cartItem.lensTypes];
        [self.thinLabel setText:self.cartItem.thinnerOptions];
        [self.upsetLabel setText:self.cartItem.thickenOptions];
        [self.moveHeartLabel setText:self.cartItem.shiftOptions];
    }
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
    [self reloadContactLensCartStatus];
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
    [self reloadAccessoryCartStatus];
    [self refreshContactLensSureStatus];
}

//-------------------购物车修改批量参数/定制类商品参数----------------------//
- (void)updateCartParameter{
    if (!self.cartItem)return;
    
    if ([self.glasses filterType] == IPCTopFilterTypeContactLenses) {
        if ([self cartItemContactLens].count > currentDegreeStock && currentDegreeStock > 0) {
            self.contactSureButton.enabled = NO;
            self.contactSureButton.alpha = 0.5;
            [IPCUIKit showError:@"暂无库存"];
            return;
        }else{
            self.contactSureButton.enabled = YES;
            self.contactSureButton.alpha = 0.5;
        }
    }else if ([self.glasses filterType] == IPCTopFilterTypeAccessory){
        if ([self cartItemAccessory].count > currentAccessoryStock && currentAccessoryStock > 0) {
            self.accessorySureButton.enabled = NO;
            self.accessorySureButton.alpha = 0.5;
            [IPCUIKit showError:@"暂无库存"];
            return;
        }else{
            self.accessorySureButton.enabled = YES;
            self.accessorySureButton.alpha = 0.5;
        }
    }
    
    if ([self.glasses filterType] == IPCTopFilterTypeCustomized) {
        self.cartItem.IOROptions = self.refractionLabel.text;
        [self.cartItem.lensFuncsArray removeAllObjects];
        [self.cartItem.lensFuncsArray addObjectsFromArray:customsizedLensFunArray];
        self.cartItem.lensTypes = self.lensStyleLabel.text;
        self.cartItem.thinnerOptions = self.thinLabel.text;
        self.cartItem.thickenOptions = self.upsetLabel.text;
        self.cartItem.shiftOptions = self.moveHeartLabel.text;
    }else if ([self.glasses filterType] == IPCTopFilterTypeReadingGlass){
        self.cartItem.batchReadingDegree = self.leftParameterLabel.text;
    }else if ([self.glasses filterType] == IPCTopFilterTypeLens){
        self.cartItem.batchSph = self.leftParameterLabel.text;
        self.cartItem.bacthCyl = self.rightParameterLabel.text;
    }else if ([self.glasses filterType] == IPCTopFilterTypeContactLenses){
        if (isOpenBooking) {
            self.cartItem.contactDegree = self.batchNoneDegreeLabel.text;
        }else{
            self.cartItem.contactDegree = self.contactDegreeLabel.text;
            self.cartItem.batchNum = self.contactBatchNumLabel.text;
            self.cartItem.kindNum = self.contactKindNumLabel.text;
            self.cartItem.validityDate = self.contactDateLabel.text;
        }
    }else if ([self.glasses filterType] == IPCTopFilterTypeAccessory){
        self.cartItem.batchNum = self.accessoryBatchNumLabel.text;
        self.cartItem.kindNum = self.accessoryKindNumLabel.text;
        self.cartItem.validityDate = self.accessoryDateLabel.text;
    }
}

#pragma mark //Reload Lens Parameter View Status
//Refresh the lens or relaxing increase or decrease in a shopping cart button state
- (void)reloadLensCartStatus
{
    if (self.leftParameterLabel.text.length || self.rightParameterLabel.text.length)
        self.lensPlusButton.enabled = YES;
    else
        self.lensPlusButton.enabled = NO;
}

//Refresh the contact lenses to increase quantity button state
- (void)reloadContactLensCartStatus{
    //The user to select the number of the specifications of the contact lenses before they can start editing
    if ([self.batchNoneStockView superview]) {
        if (self.batchNoneDegreeLabel.text.length == 0) {
            self.batchNonePlusButton.enabled = NO;
        }else{
            self.batchNonePlusButton.enabled = YES;
        }
    }else{
        if ([self.contactCartNumLabel.text integerValue] + [self cartItemContactLens].count >= currentDegreeStock || !self.contactDegreeLabel.text.length) {
            self.contactPlusButton.enabled = NO;
        }else{
            self.contactPlusButton.enabled = YES;
        }
    }
}

//Refresh the Accessory  to increase quantity button state
- (void)reloadAccessoryCartStatus{
    //The user to select the number of the specifications of the accessory before they can start editing
    if ([self.accessoryCartNumLabel.text integerValue] + [self cartItemAccessory].count >= currentAccessoryStock) {
        self.accessoryplusButton.enabled = NO;
    }else{
        self.accessoryplusButton.enabled = YES;
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
    }else if([_glasses filterType] == IPCTopFilterTypeAccessory){
        if (self.contactSpecType == ContactLenSpecTypeBatchNum){
            return [self.parameterViewMode accessoryBatchNumArray].count;
        }else if (self.contactSpecType == ContactLenSpecTypeKindNum){
            return [self.parameterViewMode accessoryKindNumArray:self.accessoryBatchNumLabel.text].count;
        }else{
            return [self.parameterViewMode accessoryValidityDateArray:self.accessoryBatchNumLabel.text KindNum:self.accessoryKindNumLabel.text].count;
        }
    }else{
        NSArray * array = customsizedArray[self.customsizedType];
        return array.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCBatchParameterCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCBatchParameterCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    if ([_glasses filterType] == IPCTopFilterTypeLens){
        [cell.parameterLabel setText:isLeft ? [IPCAppManager batchSphs][indexPath.row] : [IPCAppManager batchCyls][indexPath.row]];
    }else if([_glasses filterType] == IPCTopFilterTypeReadingGlass){
        [cell.parameterLabel setText:[IPCAppManager batchReadingDegrees][indexPath.row]];
    }else if([_glasses filterType] == IPCTopFilterTypeContactLenses){
        if (self.contactSpecType == ContactLenSpecTypeDegree) {
            if ([self.batchNoneStockView superview]) {
                [cell.parameterLabel setText:[IPCAppManager batchDegrees][indexPath.row]];
            }else{
                BatchParameterObject * parameter = self.parameterViewMode.contactDegreeList[indexPath.row];
                if (parameter)[cell.parameterLabel setText:parameter.degree];
            }
        }else if (self.contactSpecType == ContactLenSpecTypeBatchNum){
            [cell.parameterLabel setText:[self.parameterViewMode batchNumArray][indexPath.row]];
        }else if (self.contactSpecType == ContactLenSpecTypeKindNum){
            [cell.parameterLabel setText:[self.parameterViewMode kindNumArray:self.contactBatchNumLabel.text][indexPath.row]];
        }else{
            NSDictionary * dateDic = [self.parameterViewMode validityDateArray:self.contactBatchNumLabel.text KindNum:self.contactKindNumLabel.text][indexPath.row];
            [cell.parameterLabel setText:dateDic[@"expireDate"]];
        }
    }else if([_glasses filterType] == IPCTopFilterTypeContactLenses || [_glasses filterType] == IPCTopFilterTypeAccessory)
    {
        if (self.contactSpecType == ContactLenSpecTypeBatchNum){
            [cell.parameterLabel setText:[self.parameterViewMode accessoryBatchNumArray][indexPath.row]];
        }else if (self.contactSpecType == ContactLenSpecTypeKindNum){
            [cell.parameterLabel setText:[self.parameterViewMode accessoryKindNumArray:self.accessoryBatchNumLabel.text][indexPath.row]];
        }else{
            [cell.parameterLabel setText:[self.parameterViewMode accessoryValidityDateArray:self.accessoryBatchNumLabel.text KindNum:self.accessoryKindNumLabel.text][indexPath.row]];
        }
    }else{
        NSArray * array = customsizedArray[self.customsizedType];
        [cell.parameterLabel setText:array[indexPath.row]];
        [cell.selectImageView setHidden:YES];
        [customsizedLensFunArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([array[indexPath.row] isEqualToString:obj]) {
                [cell.selectImageView setHidden:NO];
            }
        }];
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
        [self reloadLensCartStatus];
    }else if([_glasses filterType] == IPCTopFilterTypeReadingGlass){
        [self.leftParameterLabel setText:[IPCAppManager batchReadingDegrees][indexPath.row]];
        [self reloadLensCartStatus];
    }else if([_glasses filterType] == IPCTopFilterTypeContactLenses || [_glasses filterType] == IPCTopFilterTypeAccessory){
        if (self.contactSpecType == ContactLenSpecTypeDegree) {
            if ([self.batchNoneStockView superview]) {
                [self.batchNoneDegreeLabel setText:[IPCAppManager batchDegrees][indexPath.row]];
                [self reloadContactLensCartStatus];
            }else{
                BatchParameterObject * parameter = self.parameterViewMode.contactDegreeList[indexPath.row];
                if (parameter) {
                    currentContactDegreeID = parameter.batchID;
                    [self.contactDegreeLabel setText:parameter.degree];
                    [self queryContactLensSpecification:YES];
                }
            }
        }else{
            validityDateTag = 0;
            if (self.contactSpecType == ContactLenSpecTypeBatchNum){
                batchNumTag    = indexPath.row;
                kindNumTag     = 0;
            }else if (self.contactSpecType == ContactLenSpecTypeKindNum){
                kindNumTag     = indexPath.row;
            }else{
                validityDateTag = indexPath.row;
            }
            [_glasses filterType] == IPCTopFilterTypeContactLenses ?  [self updateContactParamater] : [self updateAccessoryParamater];
        }
    }else{
        NSArray * array = customsizedArray[self.customsizedType];
        switch (self.customsizedType) {
            case 0:
                [self.refractionLabel setText:array[indexPath.row]];
                break;
            case 1:{
                if ([customsizedLensFunArray containsObject:array[indexPath.row]]) {
                    [customsizedLensFunArray removeObject:array[indexPath.row]];
                }else{
                    [customsizedLensFunArray addObject:array[indexPath.row]];
                }
                [self.lensFunctionLabel setText:[customsizedLensFunArray componentsJoinedByString:@","]];
            }
                break;
            case 2:
                [self.lensStyleLabel setText:array[indexPath.row]];
                break;
            case 3:
                [self.thinLabel setText:array[indexPath.row]];
                break;
            case 4:
                [self.upsetLabel setText:array[indexPath.row]];
                break;
            case 5:
                [self.moveHeartLabel setText:array[indexPath.row]];
                break;
            default:
                break;
        }
    }
    [tableView removeFromSuperview];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark //UITexViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        NSString * trimmedString = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [textView setText:trimmedString];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
