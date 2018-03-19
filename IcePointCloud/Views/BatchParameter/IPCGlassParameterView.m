//
//  GlassParameterView.m
//  IcePointCloud
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCGlassParameterView.h"
#import "IPCBatchParameterCell.h"

static NSString * const identifier = @"ChooseBatchParameterCellIdentifier";

@interface IPCGlassParameterView()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL           isLeft;//判断sph cyl
    BOOL           isOptometryLeft;//判断左眼 右眼
    double         leftOptometryPrice;//左眼光度价格
    double         rightOptometryPrice;//右眼光度价格
    //CustomsizedLens Funcation
    NSMutableArray<NSString *> * customsizedLensFunArray;
}

@property (strong, nonatomic) UIView *parameterContentView;
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
@property (weak, nonatomic) IBOutlet UIButton *normalSelectButton;
//Customer Optometry
@property (strong, nonatomic) IBOutlet UIView *optometryLensView;
@property (weak, nonatomic) IBOutlet UIImageView *optometryLensImageView;
@property (weak, nonatomic) IBOutlet UILabel *optometryLensNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *optometryLensPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *leftOptometryLensView;
@property (weak, nonatomic) IBOutlet UIView *leftOptometryCylView;
@property (weak, nonatomic) IBOutlet UIView *rightOptometryLensView;
@property (weak, nonatomic) IBOutlet UIView *rightOptometryCylView;
@property (weak, nonatomic) IBOutlet UILabel *leftOptometryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightOptometryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftOptometrySphLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightOptometrySphLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftOptometryCylLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightOptometryCylLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftOptometryNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightOptometryNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *optometrySureButton;
@property (weak, nonatomic) IBOutlet UIButton *optometryCancelButton;
//Parameter TableView
@property (strong, nonatomic) IBOutlet UITableView *parameterTableView;
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
@property (assign, nonatomic) NSInteger   customsizedType;
@property (copy, nonatomic) void(^CompleteBlock)();

@end

@implementation IPCGlassParameterView

- (instancetype)initWithFrame:(CGRect)frame Complete:(void (^)())complete
{
    self = [super initWithFrame:frame];
    if (self) {
        self.CompleteBlock = complete;
        customsizedLensFunArray  = [[NSMutableArray alloc]init];
        
        UIView *mainView = [UIView jk_loadInstanceFromNibWithName:@"IPCGlassParameterView" owner:self];
        [mainView setFrame:frame];
        [self addSubview:mainView];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.normalLensView addBorder:10 Width:0 Color:nil];
    [self.customsizedParameterView addBorder:10 Width:0 Color:nil];
    [self.optometryLensView addBorder:10 Width:0 Color:nil];
    [self.leftParameterView addBorder:5 Width:0.5 Color:nil];
    [self.rightParameterView addBorder:5 Width:0.5 Color:nil];
    [self.leftOptometryLensView addBorder:5 Width:0.5 Color:nil];
    [self.rightOptometryLensView addBorder:5 Width:0.5 Color:nil];
    [self.leftOptometryCylView addBorder:5 Width:0.5 Color:nil];
    [self.rightOptometryCylView addBorder:5 Width:0.5 Color:nil];
    [self.normalLensImageView addBorder:5 Width:0.5 Color:nil];
    [self.customsizedImageView addBorder:5 Width:0.5 Color:nil];
    [self.optometryLensImageView addBorder:5 Width:0.5 Color:nil];
    [self.refractionView addBorder:5 Width:0.5 Color:nil];
    [self.lensStyleView addBorder:5 Width:0.5 Color:nil];
    [self.lensFunctionView addBorder:5 Width:0.5 Color:nil];
    [self.thinView addBorder:5 Width:0.5 Color:nil];
    [self.upsetView addBorder:5 Width:0.5 Color:nil];
    [self.moveHeartView addBorder:5 Width:0.5 Color:nil];
    [self.customsizedMemoView addBorder:5 Width:0.5 Color:nil];
    [self.lensSureButton addSignleCorner:UIRectCornerBottomLeft Size:10];
    [self.optometrySureButton addSignleCorner:UIRectCornerBottomLeft Size:10];
    [self.customsizedSureButton addSignleCorner:UIRectCornerBottomLeft Size:10];
    [self.customsizedMemoView setPlaceholder:@"请输入商品备注信息..."];
    [self.lensCancelButton addSignleCorner:UIRectCornerBottomRight Size:10];
    [self.optometryCancelButton addSignleCorner:UIRectCornerBottomRight Size:10];
    [self.customsizedCancleButton addSignleCorner:UIRectCornerBottomRight Size:10];
}

#pragma mark //Set Data
- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        [self showParameterView];
    }
}

- (void)setCartItem:(IPCShoppingCartItem *)cartItem{
    _cartItem = cartItem;
    
    if (_cartItem) {
        _glasses = _cartItem.glasses;
        
        [self showParameterView];
        [self showCartItemParameter];
    }
}

#pragma mark //Request Data
- (void)querySuggestPrice
{
    __weak typeof(self) weakSelf = self;
    if ([_glasses filterType] == IPCTopFilterTypeReadingGlass) {
        [IPCBatchRequestManager queryBatchLensPriceWithProductId:[self.glasses glassId]
                                                            Type:[self.glasses glassType]
                                                             Sph:self.leftParameterLabel.text.length ? self.leftParameterLabel.text : @"0.00"
                                                             Cyl:@"0.00"
                                                    SuccessBlock:^(id responseValue){
                                                        [weakSelf reloadUIWithResponseValue:responseValue];
                                                    } FailureBlock:^(NSError *error) {
                                                        [IPCCommonUI showError:error.domain];
                                                    }];
    }else{
        [IPCBatchRequestManager queryBatchLensPriceWithProductId:[self.glasses glassId]
                                                            Type:[self.glasses glassType]
                                                             Sph:self.leftParameterLabel.text.length ? self.leftParameterLabel.text : @"0.00"
                                                             Cyl:self.rightParameterLabel.text.length ? self.rightParameterLabel.text : @"0.00"
                                                    SuccessBlock:^(id responseValue){
                                                        [weakSelf reloadUIWithResponseValue:responseValue];
                                                    } FailureBlock:^(NSError *error) {
                                                        [IPCCommonUI showError:error.domain];
                                                    }];
    }
}

- (void)queryOptometryLensSuggestPriceWithSph:(NSString *)sph Cyl:(NSString *)cyl IsLeft:(BOOL)isLeft
{
    if ([_glasses filterType] == IPCTopFilterTypeReadingGlass) {
        [IPCBatchRequestManager queryBatchLensPriceWithProductId:[self.glasses glassId]
                                                            Type:[self.glasses glassType]
                                                             Sph:sph
                                                             Cyl:@"0.00"
                                                    SuccessBlock:^(id responseValue){
                                                        IPCBatchGlassesConfig * config = [[IPCBatchGlassesConfig alloc] initWithResponseValue:responseValue];
                                                        if (isLeft) {
                                                            leftOptometryPrice = config.suggestPrice;
                                                        }else{
                                                            rightOptometryPrice = config.suggestPrice;
                                                        }
                                                    } FailureBlock:^(NSError *error) {
                                                        [IPCCommonUI showError:error.domain];
                                                    }];
    }else{
        [IPCBatchRequestManager queryBatchLensPriceWithProductId:[self.glasses glassId]
                                                            Type:[self.glasses glassType]
                                                             Sph:sph
                                                             Cyl:cyl
                                                    SuccessBlock:^(id responseValue){
                                                        IPCBatchGlassesConfig * config = [[IPCBatchGlassesConfig alloc] initWithResponseValue:responseValue];
                                                        if (isLeft) {
                                                            leftOptometryPrice = config.suggestPrice;
                                                        }else{
                                                            rightOptometryPrice = config.suggestPrice;
                                                        }
                                                    } FailureBlock:^(NSError *error) {
                                                        [IPCCommonUI showError:error.domain];
                                                    }];
    }
}

///Reload UI
- (void)reloadUIWithResponseValue:(id)responseValue
{
    IPCBatchGlassesConfig * config = [[IPCBatchGlassesConfig alloc] initWithResponseValue:responseValue];
    
    if (self.cartItem) {
        self.cartItem.unitPrice = config.suggestPrice * ([[IPCShoppingCart sharedCart] customDiscount] / 100);
        self.cartItem.prePrice = config.suggestPrice;
    }else{
        self.glasses.updatePrice = config.suggestPrice;
        
        if ([self.lensNumLabel.text isEqualToString:@"0"]) {
            [self.lensNumLabel setText:@"1"];
        }
    }
    [self.normalLensPriceLabel setText:[NSString stringWithFormat:@"￥%.f", config.suggestPrice]];
    [self reloadLensCartStatus];
}

#pragma mark //Set UI
- (void)showParameterView
{
    if ([_glasses filterType] == IPCTopFilterTypeReadingGlass) {
        [self.leftTitleLabel setText:@"度数"];
        [self.leftOptometryTitleLabel setText:@"度数"];
        [self.rightOptometryTitleLabel setText:@"度数"];
        [self.leftParameterLabel setText:[IPCBatchDegreeObject instance].currentDegree];
    }else if([_glasses filterType] == IPCTopFilterTypeLens || [_glasses filterType] == IPCTopFilterTypeContactLenses){
        [self.leftTitleLabel setText:@"球镜/SPH"];
        [self.leftOptometryTitleLabel setText:@"球镜/SPH"];
        [self.rightOptometryTitleLabel setText:@"球镜/SPH"];
        [self.rightParameterView setHidden:NO];
        [self.rightOptometryCylView setHidden:NO];
        [self.leftOptometryCylView setHidden:NO];
        [self.leftParameterLabel setText:[IPCBatchDegreeObject instance].currentSph];
        [self.rightParameterLabel setText:[IPCBatchDegreeObject instance].currentCyl];
    }
    if ([IPCPayOrderCurrentCustomer sharedManager].currentOpometry.optometryID && !self.cartItem && [_glasses filterType] != IPCTopFilterTypeReadingGlass) {
        [self.normalSelectButton setHidden:NO];
        IPCOptometryMode * optometry = [IPCPayOrderCurrentCustomer sharedManager].currentOpometry;
        
        [self.leftOptometrySphLabel setText: optometry.sphLeft.length ? optometry.sphLeft : @"0.00"];
        [self.leftOptometryCylLabel setText:optometry.cylLeft.length ? optometry.cylLeft : @"0.00"];
        [self.rightOptometrySphLabel setText:optometry.sphRight.length ? optometry.sphRight : @"0.00"];
        [self.rightOptometryCylLabel setText:optometry.cylRight.length ? optometry.cylRight : @"0.00"];
    }
    
    if ([_glasses filterType] == IPCTopFilterTypeReadingGlass || [_glasses filterType] == IPCTopFilterTypeLens || [_glasses filterType] == IPCTopFilterTypeContactLenses)
    {
        if ([IPCPayOrderCurrentCustomer sharedManager].currentOpometry.optometryID && !self.cartItem && [_glasses filterType] != IPCTopFilterTypeReadingGlass)
        {
            [self loadOptometryLensView];
        }else{
            [self loadBatchNormalLensView];
        }
    }else if ([_glasses filterType] == IPCTopFilterTypeCustomized){
        [self loadCustomsizedLensView];
    }

    CGAffineTransform transform = CGAffineTransformScale(self.parameterContentView.transform, 0.3, 0.3);
    [self.parameterContentView setTransform:transform];
}


- (void)loadBatchNormalLensView{
    [self addSubview:self.normalLensView];
    self.parameterContentView = self.normalLensView;
    [self.normalLensView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    if (self.cartItem) {
        [self.normalLensStepperView setHidden:YES];
        self.normalLensHeight.constant -= 55;
        [self.normalLensPriceLabel setText:[NSString stringWithFormat:@"￥%.f",self.cartItem.prePrice]];
    }else{
        [self.normalLensPriceLabel setText:[NSString stringWithFormat:@"￥%.f",self.glasses.suggestPrice]];
    }
    [self.normalLensImageView setImageWithURL:[NSURL URLWithString:self.glasses.thumbImage.imageURL] placeholder:[UIImage imageNamed:@"default_placeHolder"]];
    [self.normalLensNameLabel setText:self.glasses.glassName];
    
    [self refreshConfigPrice];
    [self refreshSureButtonStatus];
}

- (void)loadOptometryLensView{
    [self addSubview:self.optometryLensView];
    self.parameterContentView = self.optometryLensView;
    
    [self.optometryLensView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    [self.optometryLensImageView  setImageWithURL:[NSURL URLWithString:self.glasses.thumbImage.imageURL] placeholder:[UIImage imageNamed:@"default_placeHolder"]];
    [self.optometryLensNameLabel setText:self.glasses.glassName];
    [self.optometryLensPriceLabel setText:[NSString stringWithFormat:@"￥%.f",self.glasses.suggestPrice]];
    
    [self refreshConfigPrice];
    [self refreshSureButtonStatus];
}

- (void)loadCustomsizedLensView{
    [self addSubview:self.customsizedParameterView];
    self.parameterContentView = self.customsizedParameterView;
    [self.customsizedParameterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
    }];
    [self. customsizedImageView  setImageWithURL:[NSURL URLWithString:self.glasses.thumbImage.imageURL] placeholder:[UIImage imageNamed:@"default_placeHolder"]];
    [self.customsizedNameLabel setText:self.glasses.glassName];
    [self.customsizedPriceLabel setText:[NSString stringWithFormat:@"￥%.f",self.glasses.suggestPrice]];
    
    [self refreshSureButtonStatus];
}

- (void)showParameterTableView:(UITapGestureRecognizer *)sender InView:(UIView *)contentView
{
    [self.parameterTableView addBorder:3 Width:0.5 Color:nil];
    [self.parameterTableView setFrame:CGRectMake(sender.view.jk_left + contentView.jk_left, sender.view.jk_bottom + contentView.jk_top, sender.view.jk_width, 300)];
    [self.parameterTableView setTableFooterView:[[UIView alloc]init]];
    [self addSubview:self.parameterTableView];
    [self.parameterTableView reloadData];
}

#pragma mark //Clicked Events
- (void)show{
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGAffineTransform newTransform =  CGAffineTransformConcat(self.parameterContentView.transform,  CGAffineTransformInvert(self.parameterContentView.transform));
        [self.parameterContentView setTransform:newTransform];
        self.parameterContentView.alpha = 1.0;
    } completion:nil];
}

- (IBAction)completeAction:(id)sender
{
    if (self.cartItem) {
        [self updateCartParameter];
    }else{
        if ([IPCPayOrderCurrentCustomer sharedManager].currentOpometry.optometryID && [self.optometryLensView superview]) {
            [self addOptometryLensToCart];
        }else{
            [self addLensToCart];
        }
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

- (IBAction)selectOptometryAction:(UIButton *)sender
{
    if (sender.selected) {
        [self.optometryLensView removeFromSuperview];
        [self loadBatchNormalLensView];
    }else{
        [self.normalLensView removeFromSuperview];
        [self loadOptometryLensView];
    }
}

#pragma mark //选择参数列表
/**
 *  Lenses or glasses for batch option
 */
- (IBAction)normalLensParameterAction:(UITapGestureRecognizer *)sender {
    if ([self.parameterTableView superview]){
        [self.parameterTableView removeFromSuperview];
    }else{
        isLeft =  [[sender view] isEqual:self.leftParameterView]  ? YES:  NO;
        [self showParameterTableView:sender InView:self.normalLensView];
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

//Optometry Lens Selection Specifications
- (IBAction)optometryLensParameterSelectAction:(UITapGestureRecognizer *)sender
{
    if ( [self.parameterTableView superview]){
        [self.parameterTableView removeFromSuperview];
    }else{
        isLeft =  [[sender view] isEqual:self.leftOptometryLensView] || [[sender view] isEqual:self.rightOptometryLensView] ?  YES:  NO;
        isOptometryLeft = [[sender view] isEqual:self.leftOptometryLensView] || [[sender view] isEqual:self.leftOptometryCylView]  ? YES:  NO;
        [self showParameterTableView:sender InView:self.optometryLensView];
    }
}


#pragma mark //购物车处理
//Increase or decrease in the shopping cart
- (IBAction)minusTapAction:(UIButton *)sender {
    NSInteger cartCount = 0;
    if ([IPCPayOrderCurrentCustomer sharedManager].currentOpometry.optometryID && [self.optometryLensView superview]) {
        if (sender.tag == 1) {
            cartCount = [self.leftOptometryNumLabel.text integerValue];
        }else{
            cartCount = [self.rightOptometryNumLabel.text integerValue];
        }
    }else{
        cartCount = [self.lensNumLabel.text integerValue];
    }
    cartCount--;
    
    if (cartCount <= 0) {
        cartCount = 0;
    }
    if ([IPCPayOrderCurrentCustomer sharedManager].currentOpometry.optometryID && [self.optometryLensView superview]) {
        if (sender.tag == 1) {
            [self.leftOptometryNumLabel setText:[NSString stringWithFormat:@"%ld",cartCount]];
        }else{
            [self.rightOptometryNumLabel setText:[NSString stringWithFormat:@"%ld",cartCount]];
        }
    }else{
        [self.lensNumLabel setText:[NSString stringWithFormat:@"%ld",cartCount]];
        [self reloadLensCartStatus];
    }
}

- (IBAction)plusTapAction:(UIButton *)sender {
    NSInteger cartCount = 0;
    if ([IPCPayOrderCurrentCustomer sharedManager].currentOpometry.optometryID && [self.optometryLensView superview]) {
        if (sender.tag == 1) {
            cartCount = [self.leftOptometryNumLabel.text integerValue];
        }else{
            cartCount = [self.rightOptometryNumLabel.text integerValue];
        }
    }else{
        cartCount = [self.lensNumLabel.text integerValue];
    }
    cartCount++;
    
    if ([IPCPayOrderCurrentCustomer sharedManager].currentOpometry.optometryID && [self.optometryLensView superview]) {
        if (sender.tag == 1) {
            [self.leftOptometryNumLabel setText:[NSString stringWithFormat:@"%ld",cartCount]];
        }else{
            [self.rightOptometryNumLabel setText:[NSString stringWithFormat:@"%ld",cartCount]];
        }
    }else{
        [self.lensNumLabel setText:[NSString stringWithFormat:@"%ld",cartCount]];
        [self reloadLensCartStatus];
    }
}

#pragma mark //加入购物车
- (void)addLensToCart
{
    __block IPCGlasses * glass = self.glasses;
    
    if ([_glasses filterType] == IPCTopFilterTypeLens){
        [[IPCShoppingCart sharedCart] addLensWithGlasses:glass
                                                     Sph:self.leftParameterLabel.text.length ? self.leftParameterLabel.text : @"0.00"
                                                     Cyl:self.rightParameterLabel.text.length ? self.rightParameterLabel.text : @"0.00"
                                                   Count:[self.lensNumLabel.text integerValue]];
    }else if([_glasses filterType] == IPCTopFilterTypeReadingGlass){
        [[IPCShoppingCart sharedCart] addReadingLensWithGlasses:glass
                                                  ReadingDegree:self.leftParameterLabel.text
                                                          Count:[self.lensNumLabel.text integerValue]];
    }else if([_glasses filterType] == IPCTopFilterTypeContactLenses){
        [[IPCShoppingCart sharedCart] addContactLensWithGlasses:glass
                                                            Sph:self.leftParameterLabel.text.length ? self.leftParameterLabel.text : @"0.00"
                                                            Cyl:self.rightParameterLabel.text.length ? self.rightParameterLabel.text : @"0.00"
                                                          Count:[self.lensNumLabel.text integerValue]];
    }
    glass = nil;
    
    if (self.CompleteBlock) {
        self.CompleteBlock();
    }
}

- (void)addOptometryLensToCart
{
    __block IPCGlasses * glass = self.glasses;
    
    if ([_glasses filterType] == IPCTopFilterTypeLens){
        glass.updatePrice = leftOptometryPrice;
        [[IPCShoppingCart sharedCart] addLensWithGlasses:glass
                                                     Sph:self.leftOptometrySphLabel.text.length ? self.leftOptometrySphLabel.text : @"0.00"
                                                     Cyl:self.leftOptometryCylLabel.text.length ? self.leftOptometryCylLabel.text : @"0.00"
                                                   Count:[self.leftOptometryNumLabel.text integerValue]];
        glass.updatePrice = rightOptometryPrice;
        [[IPCShoppingCart sharedCart] addLensWithGlasses:glass
                                                     Sph:self.rightOptometrySphLabel.text.length ? self.rightOptometrySphLabel.text : @"0.00"
                                                     Cyl:self.rightOptometryCylLabel.text.length ? self.rightOptometryCylLabel.text : @"0.00"
                                                   Count:[self.rightOptometryNumLabel.text integerValue]];
    }else if([_glasses filterType] == IPCTopFilterTypeReadingGlass){
        glass.updatePrice = leftOptometryPrice;
        [[IPCShoppingCart sharedCart] addReadingLensWithGlasses:glass
                                                  ReadingDegree:self.leftOptometrySphLabel.text
                                                          Count:[self.leftOptometryNumLabel.text integerValue]];
        glass.updatePrice = rightOptometryPrice;
        [[IPCShoppingCart sharedCart] addReadingLensWithGlasses:glass
                                                  ReadingDegree:self.rightOptometrySphLabel.text
                                                          Count:[self.rightOptometryNumLabel.text integerValue]];
    }else if([_glasses filterType] == IPCTopFilterTypeContactLenses){
        glass.updatePrice = leftOptometryPrice;
        [[IPCShoppingCart sharedCart] addContactLensWithGlasses:glass
                                                            Sph:self.leftOptometrySphLabel.text.length ? self.leftOptometrySphLabel.text : @"0.00"
                                                            Cyl:self.leftOptometryCylLabel.text.length ? self.leftOptometryCylLabel.text : @"0.00"
                                                          Count:[self.leftOptometryNumLabel.text integerValue]];
        glass.updatePrice = rightOptometryPrice;
        [[IPCShoppingCart sharedCart] addContactLensWithGlasses:glass
                                                            Sph:self.rightOptometrySphLabel.text.length ? self.rightOptometrySphLabel.text : @"0.00"
                                                            Cyl:self.rightOptometryCylLabel.text.length ? self.rightOptometryCylLabel.text : @"0.00"
                                                          Count:[self.rightOptometryNumLabel.text integerValue]];
    }
    glass = nil;
    
    if (self.CompleteBlock) {
        self.CompleteBlock();
    }
}

#pragma mark //移除参数选择列表   移除页面
//According to specification data list
- (IBAction)removerParameterTableViewAction:(id)sender {
    if ([self.parameterTableView superview])
        [self.parameterTableView removeFromSuperview];
}

//Remove page
- (void)removeCover
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGAffineTransform transform = CGAffineTransformScale(self.parameterContentView.transform, 0.3, 0.3);
        [self.parameterContentView setTransform:transform];
        self.parameterContentView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self removeFromSuperview];
        }
    }];
}

#pragma mark //Query Shopping Cart Item
- (IPCShoppingCartItem *)cartItemContactLens{
    return [[IPCShoppingCart sharedCart] contactLensForGlasses:self.glasses ContactDegree:self.leftParameterLabel.text];
}

#pragma mark //Show CartItem Parameter
- (void)showCartItemParameter{
    if ([self.glasses filterType] == IPCTopFilterTypeReadingGlass) {
        [self.leftParameterLabel setText:self.cartItem.batchReadingDegree];
    }else if ([self.glasses filterType] == IPCTopFilterTypeLens || [self.glasses filterType] == IPCTopFilterTypeContactLenses){
        [self.leftParameterLabel setText:self.cartItem.batchSph];
        [self.rightParameterLabel setText:self.cartItem.bacthCyl];
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
//-------------------购物车修改批量参数/定制类商品参数----------------------//
- (void)updateCartParameter{
    if (!self.cartItem)return;
    
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
    }else if ([self.glasses filterType] == IPCTopFilterTypeLens || [self.glasses filterType] == IPCTopFilterTypeContactLenses){
        self.cartItem.batchSph = self.leftParameterLabel.text;
        self.cartItem.bacthCyl = self.rightParameterLabel.text;
    }
    if (self.CompleteBlock) {
        self.CompleteBlock();
    }
}

#pragma mark //Reload Lens Parameter View Status
- (void)refreshConfigPrice
{
    if ([IPCPayOrderCurrentCustomer sharedManager].currentOpometry.optometryID && [self.optometryLensView superview] && !self.cartItem){
        ///查询已选验光单批量价格
        [self queryOptometryLensSuggestPriceWithSph:self.leftOptometrySphLabel.text Cyl:self.leftOptometryCylLabel.text IsLeft:YES];
        [self queryOptometryLensSuggestPriceWithSph:self.rightOptometrySphLabel.text Cyl:self.rightOptometryCylLabel.text IsLeft:NO];
    }else{
        ///查询批量规格价格
        [self querySuggestPrice];
    }
}


//Refresh Sure Button Status
- (void)refreshSureButtonStatus
{
    if (self.cartItem)return;
    
    [[[RACSignal combineLatest:@[RACObserve(self, self.leftParameterLabel.text),RACObserve(self, self.rightParameterLabel.text),RACObserve(self, self.lensNumLabel.text)] reduce:^id(NSString *leftParametr,NSString *rightParameter,NSString *cartNum)
       {
           if ([self.glasses filterType] == IPCTopFilterTypeReadingGlass) {
               return @((leftParametr.length || rightParameter.length) && [cartNum integerValue] > 0);
           }
           return  @(leftParametr.length && rightParameter.length && [cartNum integerValue] > 0);
       }]distinctUntilChanged] subscribeNext:^(NSNumber *valid) {
           if (valid.boolValue) {
               [self.lensSureButton setEnabled:YES];
               self.lensSureButton.alpha = 1;
           }else{
               [self.lensSureButton setEnabled:NO];
               self.lensSureButton.alpha = 0.5;
           }
       }];
    
    [[[RACSignal combineLatest:@[RACObserve(self, self.leftOptometrySphLabel.text),RACObserve(self, self.leftOptometryCylLabel.text),RACObserve(self, self.rightOptometrySphLabel.text),RACObserve(self, self.rightOptometryCylLabel.text),RACObserve(self, self.leftOptometryNumLabel.text),RACObserve(self, self.rightOptometryNumLabel.text)] reduce:^id(NSString *leftSph,NSString *rightSph,NSString *leftCyl,NSString *rightCyl,NSString *leftcartNum,NSString *rightcartNum)
       {
           return  @(leftSph.length && rightSph.length && leftCyl.length && rightCyl.length &&[leftcartNum integerValue] > 0 && [rightcartNum integerValue] > 0);
       }]distinctUntilChanged] subscribeNext:^(NSNumber *valid) {
           if (valid.boolValue) {
               [self.optometrySureButton setEnabled:YES];
               self.optometrySureButton.alpha = 1;
           }else{
               [self.optometrySureButton setEnabled:NO];
               self.optometrySureButton.alpha = 0.5;
           }
       }];
}

//Refresh the lens or relaxing increase or decrease in a shopping cart button state
- (void)reloadLensCartStatus
{
    if ([self.glasses filterType] != IPCTopFilterTypeReadingGlass) {
        if (self.leftParameterLabel.text.length && self.rightParameterLabel.text.length)
            self.lensPlusButton.enabled = YES;
        else
            self.lensPlusButton.enabled = NO;
    }else{
        if (self.leftParameterLabel.text.length || self.rightParameterLabel.text.length)
            self.lensPlusButton.enabled = YES;
        else
            self.lensPlusButton.enabled = NO;
    }
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_glasses filterType] == IPCTopFilterTypeLens || [_glasses filterType] == IPCTopFilterTypeContactLenses){
        return isLeft ? [IPCBatchDegreeObject instance].lensSph.count : [IPCBatchDegreeObject instance].lensCyl.count;
    }else if ([_glasses filterType] == IPCTopFilterTypeReadingGlass){
        return [[IPCBatchDegreeObject instance].readingDegrees count];
    }else{
        NSArray * array = [[IPCBatchDegreeObject instance] customsizedParameter][self.customsizedType];
        return array.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCBatchParameterCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCBatchParameterCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    if ([_glasses filterType] == IPCTopFilterTypeLens || [_glasses filterType] == IPCTopFilterTypeContactLenses){
        [cell.parameterLabel setText:isLeft ? [IPCBatchDegreeObject instance].lensSph[indexPath.row] : [IPCBatchDegreeObject instance].lensCyl[indexPath.row]];
    }else if([_glasses filterType] == IPCTopFilterTypeReadingGlass){
        [cell.parameterLabel setText:[IPCBatchDegreeObject instance].readingDegrees[indexPath.row]];
    }else{
        NSArray * array = [[IPCBatchDegreeObject instance] customsizedParameter][self.customsizedType];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_glasses filterType] == IPCTopFilterTypeLens || [_glasses filterType] == IPCTopFilterTypeContactLenses) {
        if (isLeft) {
            if ([IPCPayOrderCurrentCustomer sharedManager].currentOpometry.optometryID && [self.optometryLensView superview]) {
                if (isOptometryLeft) {
                    [self.leftOptometrySphLabel setText:[IPCBatchDegreeObject instance].lensSph[indexPath.row]];
                }else{
                    [self.rightOptometrySphLabel setText:[IPCBatchDegreeObject instance].lensSph[indexPath.row]];
                }
            }else{
                [self.leftParameterLabel setText:[IPCBatchDegreeObject instance].lensSph[indexPath.row]];
            }
        }else{
            if ([IPCPayOrderCurrentCustomer sharedManager].currentOpometry.optometryID && [self.optometryLensView superview]) {
                if (isOptometryLeft) {
                    [self.leftOptometryCylLabel setText:[IPCBatchDegreeObject instance].lensCyl[indexPath.row]];
                }else{
                    [self.rightOptometryCylLabel setText:[IPCBatchDegreeObject instance].lensCyl[indexPath.row]];
                }
            }else{
                [self.rightParameterLabel setText:[IPCBatchDegreeObject instance].lensCyl[indexPath.row]];
            }
        }
    }else if([_glasses filterType] == IPCTopFilterTypeReadingGlass){
        if ([IPCPayOrderCurrentCustomer sharedManager].currentOpometry.optometryID && [self.optometryLensView superview]) {
            if (isOptometryLeft) {
                [self.leftOptometrySphLabel setText:[IPCBatchDegreeObject instance].readingDegrees[indexPath.row]];
            }else{
                [self.rightOptometrySphLabel setText:[IPCBatchDegreeObject instance].readingDegrees[indexPath.row]];
            }
        }else{
            [self.leftParameterLabel setText:[IPCBatchDegreeObject instance].readingDegrees[indexPath.row]];
        }
    }else{
        NSArray * array = [[IPCBatchDegreeObject instance] customsizedParameter][self.customsizedType];
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
    if ([_glasses filterType] == IPCTopFilterTypeReadingGlass || [_glasses filterType] == IPCTopFilterTypeLens || [_glasses filterType] == IPCTopFilterTypeContactLenses){
        [self reloadLensCartStatus];
        [self refreshConfigPrice];
    }
    [tableView removeFromSuperview];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
