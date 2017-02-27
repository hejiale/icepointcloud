//
//  ExpandableShoppingCartCell.m
//  IcePointCloud
//
//  Created by mac on 8/27/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCExpandShoppingCartCell.h"

@interface IPCExpandShoppingCartCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (nonatomic, weak) IBOutlet IPCImageTextButton * unitPriceButton;
@property (nonatomic, weak) IBOutlet UIImageView *glassesImgView;
@property (nonatomic, weak) IBOutlet UIButton *checkBtn;
@property (nonatomic, weak) IBOutlet UILabel *glassesNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *preSellImage;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *priceSureButton;
@property (nonatomic, weak) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unitPriceButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *glassNameHeight;


@property (copy, nonatomic) void(^ReloadBlock)();


@end

@implementation IPCExpandShoppingCartCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self.glassesImgView addBorder:3 Width:1];
    [self.priceTextField addBorder:3 Width:1];
}



- (void)setCartItem:(IPCShoppingCartItem *)cartItem Reload:(void(^)())reload
{
    _cartItem = cartItem;
    self.ReloadBlock = reload;
    [self.checkBtn setSelected:_cartItem.selected];
    
    
    //    if ([cartItem.glasses filterType] == IPCTopFilterTypeContactLenses || [cartItem.glasses filterType] == IPCTopFilterTypeAccessory) {
    //        [self.parameterLabel setTextColor:[UIColor lightGrayColor]];
    //        [self.parameterLabel setFont:[UIFont systemFontOfSize:11 weight:UIFontWeightThin]];
    //        [self.contactDegreeLabel setHidden:NO];[self.contactBatchNumLabel setHidden:NO];
    //        if ([cartItem.glasses filterType] == IPCTopFilterTypeAccessory) {
    //            self.degreeWidthConstraint.constant = 0;
    //        }
    //    }else{
    //        [self.parameterLabel setTextColor:[UIColor darkGrayColor]];
    //        [self.parameterLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightThin]];
    //        [self.contactDegreeLabel setHidden:YES];[self.contactBatchNumLabel setHidden:YES];
    //    }
    
    //    if ([self isExpandable]) {
    //        self.mainView.hidden = !_cartItem.expanded;
    //        [self.separatorView setHidden:NO];
    //        self.seperatorHeight.constant = 25;
    //        [self constructUI];
    //    }else{
    //        self.seperatorHeight.constant = 0;
    //        [self.separatorView setHidden:YES];
    //        [self.mainView setHidden:YES];
    //    }
    
    IPCGlassesImage *gi = [_cartItem.glasses imageWithType:IPCGlassesImageTypeThumb];
    if (gi)[self.glassesImgView setImageWithURL:[NSURL URLWithString:gi.imageURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
    
    self.glassesNameLbl.text = _cartItem.glasses.glassName;
    self.countLbl.text      = [NSString stringWithFormat:@"x%ld", (long)[[IPCShoppingCart sharedCart]itemsCount:self.cartItem]];
    NSString * unitPriceStr = [NSString stringWithFormat:@"￥%.f", _cartItem.unitPrice];
    [self.unitPriceButton setTitle:unitPriceStr forState:UIControlStateNormal];
    CGFloat unitPriceWidth = [unitPriceStr jk_sizeWithFont:self.unitPriceButton.titleLabel.font constrainedToHeight:self.unitPriceButton.jk_height].width;
    self.unitPriceButtonWidth.constant = unitPriceWidth + 20;
    [self.unitPriceButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft];
    if (self.cartItem.isPreSell) {
        [self.preSellImage setHidden:NO];
    }else{
        [self.preSellImage setHidden:YES];
    }
    [self.priceTextField setText:[NSString stringWithFormat:@"%.f", _cartItem.unitPrice]];
    
    CGFloat nameHeight = [self.glassesNameLbl.text jk_sizeWithFont:self.glassesNameLbl.font constrainedToWidth:self.glassesNameLbl.jk_width].height;
    if ((([self.cartItem.glasses filterType] == IPCTopFilterTypeContactLenses || [self.cartItem.glasses filterType] == IPCTopFilterTypeAccessory) && self.cartItem.glasses.isBatch) && !self.cartItem.isPreSell)
    {
        nameHeight = 20;
    }else{
        if (nameHeight <= 20) {
            nameHeight = 20;
        }else{
            nameHeight = 35;
        }
    }
    self.glassNameHeight.constant = nameHeight;
    [self loadContactLensBatchSpecification:nameHeight];
    
    //    if ([cartItem.glasses filterType] == IPCTopFilterTypeLens) {
    //        if (cartItem.batchSph.length && cartItem.bacthCyl.length)
    //            [self.parameterLabel setText:[NSString stringWithFormat:@"球镜/SPH: %@  柱镜/CYL: %@",cartItem.batchSph,cartItem.bacthCyl]];
    //    }else if([cartItem.glasses filterType] == IPCTopFilterTypeContactLenses || [cartItem.glasses filterType] == IPCTopFilterTypeAccessory){
    //        if (cartItem.contactDegree.length)
    //            [self.contactDegreeLabel setText:[NSString stringWithFormat:@"度数: %@",cartItem.contactDegree]];
    //        if (cartItem.batchNum.length)
    //            [self.contactBatchNumLabel setText:[NSString stringWithFormat:@"批次号: %@",cartItem.batchNum]];
    //        if (cartItem.kindNum.length && cartItem.validityDate.length)
    //            [self.parameterLabel setText:[NSString stringWithFormat:@"准字号：%@   有效期：%@",cartItem.kindNum,cartItem.validityDate]];
    //    }else if([cartItem.glasses filterType] == IPCTopFilterTypeReadingGlass){
    //        if (cartItem.batchReadingDegree.length)
    //            [self.parameterLabel setText:[NSString stringWithFormat:@"度数: %@",cartItem.batchReadingDegree]];
    //    }
    //
    //    [self updateUIByCount];
}


- (IBAction)onEditPriceActiom:(UIButton *)sender {
    [sender setHidden:YES];
    [self.priceTextField setHidden:NO];
    [self.priceSureButton setHidden:NO];
}


- (IBAction)onEditPriceSureAction:(id)sender {
    [self.unitPriceButton setHidden:NO];
    [self.priceTextField setHidden:YES];
    [self.priceSureButton setHidden:YES];
    [self.priceTextField endEditing:YES];
    NSString * str = [self.priceTextField.text jk_trimmingWhitespace];
    double price = [str doubleValue];
    if (price > 0) {
        self.cartItem.unitPrice = price;
        
        if (self.ReloadBlock) {
            self.ReloadBlock();
        }
    }
}

#pragma mark //UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![IPCCommon judgeIsNumber:string])return NO;
    return YES;
}

#pragma mark //Set UI
- (void)loadContactLensBatchSpecification:(CGFloat)height{
    UIView * specificationView = [[UIView alloc]initWithFrame:CGRectMake(self.glassesImgView.jk_right + 10, self.glassesNameLbl.jk_top+height+5, self.jk_width - self.glassesImgView.jk_right - 10, 30)];
    [self.mainContentView addSubview:specificationView];
    
    if ([self.cartItem.glasses filterType] == IPCTopFilterTypeContactLenses && self.cartItem.glasses.isBatch) {
        if (self.cartItem.isPreSell) {
            UILabel * degreeLabel = [[UILabel alloc]initWithFrame:specificationView.bounds];
            [degreeLabel setText:[NSString stringWithFormat:@"度数: %@",self.cartItem.contactDegree]];
            [degreeLabel setFont:[UIFont systemFontOfSize:10 weight:UIFontWeightThin]];
            [degreeLabel setTextColor:[UIColor lightGrayColor]];
            [specificationView addSubview:degreeLabel];
        }else{
            CGFloat halfWidth = specificationView.jk_width/2;
            NSArray * titleArray = @[@"度数",@"批次号",@"准字号",@"有效期"];
            NSArray * valueArray = @[self.cartItem.contactDegree,self.cartItem.batchNum,self.cartItem.kindNum,self.cartItem.validityDate];
            
            for (NSInteger i= 0; i < titleArray.count; i++) {
                UILabel * titleLbl = nil;
                if (i < 2) {
                    titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(halfWidth*i  , 0, 40, 15)];
                }else{
                    titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(halfWidth*(i-2), 15, 40, 15)];
                }
                [titleLbl setText:titleArray[i]];
                [titleLbl setFont:[UIFont systemFontOfSize:10 weight:UIFontWeightThin]];
                [titleLbl setTextColor:[UIColor lightGrayColor]];
                [specificationView addSubview:titleLbl];
                
                UILabel * valueLbl = [[UILabel alloc]initWithFrame:CGRectMake(titleLbl.jk_right, titleLbl.jk_top, halfWidth - titleLbl.jk_width, 15)];
                [valueLbl setFont:titleLbl.font];
                [valueLbl setTextColor:titleLbl.textColor];
                [valueLbl setText:valueArray[i]];
                [specificationView addSubview:valueLbl];
            }
        }
    }else if ([self.cartItem.glasses filterType] == IPCTopFilterTypeAccessory && self.cartItem.glasses.isBatch){
        if (!self.cartItem.isPreSell) {
            CGFloat halfWidth = specificationView.jk_width/2;
            NSArray * titleArray = @[@"批次号",@"有效期",@"准字号"];
            NSArray * valueArray = @[self.cartItem.batchNum,self.cartItem.validityDate,self.cartItem.kindNum];
            
            for (NSInteger i= 0; i < titleArray.count; i++) {
                UILabel * titleLbl = nil;
                if (i < 2) {
                    titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(halfWidth*i  , 0, 40, 15)];
                }else{
                    titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 40, 15)];
                }
                [titleLbl setText:titleArray[i]];
                [titleLbl setFont:[UIFont systemFontOfSize:10 weight:UIFontWeightThin]];
                [titleLbl setTextColor:[UIColor lightGrayColor]];
                [specificationView addSubview:titleLbl];
                
                UILabel * valueLbl = [[UILabel alloc]initWithFrame:CGRectMake(titleLbl.jk_right, titleLbl.jk_top, i < 2 ? halfWidth - titleLbl.jk_width: specificationView.jk_width - titleLbl.jk_width, 15)];
                [valueLbl setFont:titleLbl.font];
                [valueLbl setTextColor:titleLbl.textColor];
                [valueLbl setText:valueArray[i]];
                [specificationView addSubview:valueLbl];
            }
        }
    }else if ([self.cartItem.glasses filterType] == IPCTopFilterTypeReadingGlass && self.cartItem.glasses.isBatch){
        UILabel * degreeLabel = [[UILabel alloc]initWithFrame:specificationView.bounds];
        [degreeLabel setText:[NSString stringWithFormat:@"度数: %@",self.cartItem.batchReadingDegree]];
        [degreeLabel setFont:[UIFont systemFontOfSize:10 weight:UIFontWeightThin]];
        [degreeLabel setTextColor:[UIColor lightGrayColor]];
        [specificationView addSubview:degreeLabel];
    }else if ([self.cartItem.glasses filterType] == IPCTopFilterTypeLens && self.cartItem.glasses.isBatch){
        UILabel * sphLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, specificationView.jk_width/2, 20)];
        [sphLabel setText:[NSString stringWithFormat:@"球镜/SPH: %@",self.cartItem.batchSph]];
        [sphLabel setFont:[UIFont systemFontOfSize:10 weight:UIFontWeightThin]];
        [sphLabel setTextColor:[UIColor lightGrayColor]];
        [specificationView addSubview:sphLabel];
        
        UILabel * cylLabel = [[UILabel alloc]initWithFrame:CGRectMake(sphLabel.jk_right, 0, specificationView.jk_width/2, 20)];
        [cylLabel setText:[NSString stringWithFormat:@"柱镜/CYL: %@",self.cartItem.bacthCyl]];
        [cylLabel setFont:[UIFont systemFontOfSize:10 weight:UIFontWeightThin]];
        [cylLabel setTextColor:[UIColor lightGrayColor]];
        [specificationView addSubview:cylLabel];
    }
}

- (void)loadAccessoryBatchSpecification{
    
}


//- (void)constructUI
//{
//    [self.mainView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//
//    if (self.cartItem.expanded) {
//        if ([self.cartItem.glasses filterType] == IPCTopFilterTypeLens) {
//            [self addThickenView];
//            [self addThinnerView];
//            [self addShiftView];
//            [self addRemarksView];
//        } else {
//            [self addIORView];
//            [self addLensTypeView];
//            [self addLensFuncView];
//            [self addThickenView];
//            [self addThinnerView];
//            [self addShiftView];
//            [self addRemarksView];
//        }
//    }
//}


//- (void)addIORView
//{
//    [self addButtonsViewWithTitle:@"折射率"
//            supportMultipleChoice:NO
//                            items:@[@"1.601", @"1.670", @"1.740"]
//                     defaultItems:self.cartItem.IOROptions
//                              tag:101];
//}
//
//- (void)addLensTypeView
//{
//    [self addButtonsViewWithTitle:@"镜片类型"
//            supportMultipleChoice:NO
//                            items:@[@"单焦点", @"多焦点"]
//                     defaultItems:self.cartItem.lensTypes
//                              tag:102];
//}
//
//- (void)addLensFuncView
//{
//    [self addButtonsViewWithTitle:@"镜片功能"
//            supportMultipleChoice:YES
//                            items:@[@"无", @"双光", @"内渐进", @"外渐进", @"防蓝光", @"抗疲劳", @"染色", @"变色", @"偏光"]
//                     defaultItems:self.cartItem.lensFuncs
//                              tag:103];
//}
//
//- (void)addThickenView
//{
//    [self addButtonsViewWithTitle:@"加厚（mm）"
//            supportMultipleChoice:NO
//                            items:@[@"0", @"+1", @"+2", @"+3", @"+4"]
//                     defaultItems:self.cartItem.thickenOptions
//                              tag:104];
//}
//
//- (void)addThinnerView
//{
//    [self addButtonsViewWithTitle:@"美薄"
//            supportMultipleChoice:NO
//                            items:@[@"是", @"否"]
//                     defaultItems:self.cartItem.thinnerOptions
//                              tag:105];
//}
//
//- (void)addShiftView
//{
//    [self addButtonsViewWithTitle:@"移心（mm）"
//            supportMultipleChoice:NO
//                            items:@[@"0", @"5", @"6", @"7", @"8", @"9"]
//                     defaultItems:self.cartItem.shiftOptions
//                              tag:106];
//}

//- (void)addButtonsViewWithTitle:(NSString *)title
//          supportMultipleChoice:(BOOL)supportMultipleChoice
//                          items:(NSArray *)items
//                   defaultItems:(NSArray *)defaultItems
//                            tag:(NSInteger)tag
//{
//    CGFloat actualHeight = 25;
//    CGFloat vMargin = 10;
//    CGFloat btnWidth = 64;
//    CGFloat spacing = 8;
//
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, totalHeight, self.mainView.jk_width, actualHeight + vMargin)];
//    view.tag = tag;
//    totalHeight += view.jk_height;
//
//    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, actualHeight)];
//    lbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
//    lbl.textColor = [UIColor lightGrayColor];
//    lbl.text = title;
//    [view addSubview:lbl];
//
//    for (int i = 0; i < items.count; i++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(lbl.jk_right + (btnWidth + spacing) * i, 0, btnWidth, actualHeight);
//        btn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
//        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        [btn jk_setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
//        [btn jk_setBackgroundColor:COLOR_RGB_BLUE forState:UIControlStateSelected];
//        [btn setTitle:items[i] forState:UIControlStateNormal];
//
//        for (NSString *str in defaultItems) {
//            if ([str isEqualToString:items[i]]) {
//                btn.selected = YES;
//                break;
//            }
//        }
//        [self updateBorderForButtonSelection:btn];
//        [btn addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:btn];
//    }
//
//    [self.mainView addSubview:view];
//}
//


#pragma mark //Clicked Events
//- (void)onButtonTapped:(UIButton *)sender
//{
//    sender.selected = !sender.selected;
//    [self updateBorderForButtonSelection:sender];
//
//    NSMutableArray *selected = [NSMutableArray new];
//
//    UIView *parent = sender.superview;
//    for (UIButton *btn in parent.subviews) {
//        if ([btn isKindOfClass:[UIButton class]]) {
//
//            BOOL handled = NO;
//
//            if (parent.tag == 103) {
//                if ([[sender titleForState:UIControlStateNormal] isEqual:@"无"] && sender.selected) {
//                    if (btn != sender) {
//                        btn.selected = NO;
//                        [self updateBorderForButtonSelection:btn];
//                        handled = YES;
//                    }
//                } else if (![[sender titleForState:UIControlStateNormal] isEqual:@"无"] && sender.selected) {
//                    if ([[btn titleForState:UIControlStateNormal] isEqual:@"无"] && btn.selected) {
//                        btn.selected = NO;
//                        [self updateBorderForButtonSelection:btn];
//                        handled = YES;
//                    }
//                }
//            }
//
//            if (!handled) {
//                if (btn != sender) {
//                    if (![self supportMultipleChoiceForTag:parent.tag]) {
//                        btn.selected = NO;
//                        [self updateBorderForButtonSelection:btn];
//                    }
//                }
//            }
//            if (btn.selected)[selected addObject:[btn titleForState:UIControlStateNormal]];
//        }
//    }
//



- (IBAction)onCheckBtnTapped:(id)sender{
    self.cartItem.selected = !self.cartItem.selected;
    if (self.ReloadBlock) {
        self.ReloadBlock();
    }
}


@end
