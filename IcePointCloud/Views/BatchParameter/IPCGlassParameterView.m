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
    BOOL           isLeft;
    //Customsized Parameter
    NSArray   *   customsizedArray;
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
    
    [self.normalLensView addBorder:10 Width:0 Color:nil];
    [self.customsizedParameterView addBorder:10 Width:0 Color:nil];
    [self.leftParameterView addBorder:5 Width:0.5 Color:nil];
    [self.rightParameterView addBorder:5 Width:0.5 Color:nil];
    [self.normalLensImageView addBorder:5 Width:0.5 Color:nil];
    [self.customsizedImageView addBorder:5 Width:0.5 Color:nil];
    [self.refractionView addBorder:5 Width:0.5 Color:nil];
    [self.lensStyleView addBorder:5 Width:0.5 Color:nil];
    [self.lensFunctionView addBorder:5 Width:0.5 Color:nil];
    [self.thinView addBorder:5 Width:0.5 Color:nil];
    [self.upsetView addBorder:5 Width:0.5 Color:nil];
    [self.moveHeartView addBorder:5 Width:0.5 Color:nil];
    [self.customsizedMemoView addBorder:5 Width:0.5 Color:nil];
    
    [self.lensSureButton addSignleCorner:UIRectCornerBottomLeft Size:10];
    [self.customsizedSureButton addSignleCorner:UIRectCornerBottomLeft Size:10];
    [self.customsizedMemoView setPlaceholder:@"请输入商品备注信息..."];
    
    [self.lensCancelButton addSignleCorner:UIRectCornerBottomRight Size:10];
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
    if ([_glasses filterType] == IPCTopFilterTypeReadingGlass) {
        [IPCBatchRequestManager queryBatchLensPriceWithProductId:[self.glasses glassId]
                                                            Type:[self.glasses glassType]
                                                          Degree:self.leftParameterLabel.text
                                                             Sph:nil
                                                             Cyl:nil
                                                    SuccessBlock:^(id responseValue)
         {
             IPCBatchGlassesConfig * config = [[IPCBatchGlassesConfig alloc] initWithResponseValue:responseValue];
             if (self.cartItem) {
                 self.cartItem.glasses.updatePrice = config.suggestPrice;
             }else{
                 self.glasses.updatePrice = config.suggestPrice;
             }
             [self.normalLensPriceLabel setText:[NSString stringWithFormat:@"￥%.f",self.glasses.updatePrice]];
         } FailureBlock: nil];
    }else{
        [IPCBatchRequestManager queryBatchLensPriceWithProductId:[self.glasses glassId]
                                                            Type:[self.glasses glassType]
                                                          Degree:nil
                                                             Sph:self.leftParameterLabel.text.length ? self.leftParameterLabel.text : @"0.00"
                                                             Cyl:self.rightParameterLabel.text.length ? self.rightParameterLabel.text : @"0.00"
                                                    SuccessBlock:^(id responseValue)
         {
             IPCBatchGlassesConfig * config = [[IPCBatchGlassesConfig alloc] initWithResponseValue:responseValue];
             if (self.cartItem) {
                 self.cartItem.glasses.updatePrice = config.suggestPrice;
             }else{
                 self.glasses.updatePrice = config.suggestPrice;
             }
             [self.normalLensPriceLabel setText:[NSString stringWithFormat:@"￥%.f",self.glasses.updatePrice]];
         } FailureBlock: nil];
    }
}

#pragma mark //Set UI
- (void)showParameterView
{
    if ([_glasses filterType] == IPCTopFilterTypeReadingGlass) {
        [self.leftTitleLabel setText:@"度数"];
    }else if([_glasses filterType] == IPCTopFilterTypeLens || [_glasses filterType] == IPCTopFilterTypeContactLenses){
        [self.leftTitleLabel setText:@"球镜/SPH"];
        [self.rightParameterView setHidden:NO];
    }
    
    if ([_glasses filterType] == IPCTopFilterTypeReadingGlass || [_glasses filterType] == IPCTopFilterTypeLens || [_glasses filterType] == IPCTopFilterTypeContactLenses)
    {
        [self loadBatchNormalLensView];
    }else if ([_glasses filterType] == IPCTopFilterTypeCustomized){
        [self loadCustomsizedLensView];
    }
    [self refreshSureButtonStatus];
    
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
        [self.normalLensPriceLabel setText:[NSString stringWithFormat:@"￥%.f",self.glasses.updatePrice]];
    }else{
        [self.normalLensPriceLabel setText:[NSString stringWithFormat:@"￥%.f",self.glasses.price]];
    }
    [self.normalLensImageView setImageWithURL:[NSURL URLWithString:self.glasses.thumbImage.imageURL] placeholder:[UIImage imageNamed:@"default_placeHolder"]];
    [self.normalLensNameLabel setText:self.glasses.glassName];
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
    [self.customsizedPriceLabel setText:[NSString stringWithFormat:@"￥%.f",self.glasses.price]];
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

#pragma mark //购物车处理
//Increase or decrease in the shopping cart
- (IBAction)minusTapAction:(id)sender {
    NSInteger cartCount = 0;
    cartCount = [self.lensNumLabel.text integerValue];
    cartCount--;
    if (cartCount <= 0) {
        cartCount = 0;
    }
    [self.lensNumLabel setText:[NSString stringWithFormat:@"%ld",cartCount]];
    
    [self reloadLensCartStatus];
}

- (IBAction)plusTapAction:(id)sender {
    NSInteger cartCount = 0;
    cartCount = [self.lensNumLabel.text integerValue];
    cartCount++;
    [self.lensNumLabel setText:[NSString stringWithFormat:@"%ld",cartCount]];
    
    [self reloadLensCartStatus];
}

#pragma mark //加入购物车
- (void)addLensToCart{
    if ([_glasses filterType] == IPCTopFilterTypeLens)
    {
        [[IPCShoppingCart sharedCart] addLensWithGlasses:self.glasses
                                                     Sph:self.leftParameterLabel.text.length ? self.leftParameterLabel.text : @"0.00"
                                                     Cyl:self.rightParameterLabel.text.length ? self.rightParameterLabel.text : @"0.00"
                                                   Count:[self.lensNumLabel.text integerValue]];
    }else if([_glasses filterType] == IPCTopFilterTypeReadingGlass)
    {
        [[IPCShoppingCart sharedCart] addReadingLensWithGlasses:self.glasses
                                                  ReadingDegree:self.leftParameterLabel.text
                                                          Count:[self.lensNumLabel.text integerValue]];
    }
    else if([_glasses filterType] == IPCTopFilterTypeContactLenses)
    {
        [[IPCShoppingCart sharedCart] addContactLensWithGlasses:self.glasses
                                                            Sph:self.leftParameterLabel.text.length ? self.leftParameterLabel.text : @"0.00"
                                                            Cyl:self.rightParameterLabel.text.length ? self.rightParameterLabel.text : @"0.00"
                                                          Count:[self.lensNumLabel.text integerValue]];
    }
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
- (void)removeCover{
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
}

#pragma mark //Reload Lens Parameter View Status
//Refresh Sure Button Status
- (void)refreshSureButtonStatus{
    if (self.cartItem)return;
    
    __weak typeof (self) weakSelf = self;
    
    [[[RACSignal combineLatest:@[RACObserve(self, self.leftParameterLabel.text),RACObserve(self, self.rightParameterLabel.text),RACObserve(self, self.lensNumLabel.text)] reduce:^id(NSString *leftParametr,NSString *rightParameter,NSString *cartNum){
        return  @(leftParametr.length && rightParameter.length && [cartNum integerValue] > 0);
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
    
    [[[RACSignal combineLatest:@[RACObserve(self, self.leftParameterLabel.text),RACObserve(self, self.rightParameterLabel.text)] reduce:^id(NSString *leftParametr,NSString *rightParameter){
        return  @(leftParametr.length && rightParameter.length);
    }]distinctUntilChanged] subscribeNext:^(NSNumber *valid) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (valid.boolValue) {
            [strongSelf querySuggestPrice];
        }
    }];
}


//Refresh the lens or relaxing increase or decrease in a shopping cart button state
- (void)reloadLensCartStatus
{
    if (self.leftParameterLabel.text.length && self.rightParameterLabel.text.length)
        self.lensPlusButton.enabled = YES;
    else
        self.lensPlusButton.enabled = NO;
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_glasses filterType] == IPCTopFilterTypeLens || [_glasses filterType] == IPCTopFilterTypeContactLenses){
        return isLeft ? [IPCBatchDegreeObject instance].lensSph.count : [IPCBatchDegreeObject instance].lensCyl.count;
    }else if ([_glasses filterType] == IPCTopFilterTypeReadingGlass){
        return [[IPCBatchDegreeObject instance].readingDegrees count];
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
    if ([_glasses filterType] == IPCTopFilterTypeLens || [_glasses filterType] == IPCTopFilterTypeContactLenses){
        [cell.parameterLabel setText:isLeft ? [IPCBatchDegreeObject instance].lensSph[indexPath.row] : [IPCBatchDegreeObject instance].lensCyl[indexPath.row]];
    }else if([_glasses filterType] == IPCTopFilterTypeReadingGlass){
        [cell.parameterLabel setText:[IPCBatchDegreeObject instance].readingDegrees[indexPath.row]];
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
    if ([_glasses filterType] == IPCTopFilterTypeLens || [_glasses filterType] == IPCTopFilterTypeContactLenses) {
        if (isLeft) {
            [self.leftParameterLabel setText:[IPCBatchDegreeObject instance].lensSph[indexPath.row]];
        }else{
            [self.rightParameterLabel setText:[IPCBatchDegreeObject instance].lensCyl[indexPath.row]];
        }
    }else if([_glasses filterType] == IPCTopFilterTypeReadingGlass){
        [self.leftParameterLabel setText:[IPCBatchDegreeObject instance].readingDegrees[indexPath.row]];
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
    if ([_glasses filterType] == IPCTopFilterTypeReadingGlass || [_glasses filterType] == IPCTopFilterTypeLens || [_glasses filterType] == IPCTopFilterTypeContactLenses)
    {
        [self reloadLensCartStatus];
    }
    [tableView removeFromSuperview];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
