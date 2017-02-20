//
//  ExpandableShoppingCartCell.m
//  IcePointCloud
//
//  Created by mac on 8/27/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import "IPCExpandShoppingCartCell.h"

typedef void(^CountBlock)();
typedef void(^ExpandBlock)();
typedef void(^CartBlock)();

@interface IPCExpandShoppingCartCell()<UITextViewDelegate,UITextFieldDelegate>
{
    BOOL       _isExpanded;
    CGFloat   totalHeight;
}

@property (nonatomic, weak) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet IPCImageTextButton *exptendButton;
@property (nonatomic, weak) IBOutlet UIImageView *glassesImgView;
@property (nonatomic, weak) IBOutlet UIButton *checkBtn;
@property (nonatomic, weak) IBOutlet UILabel *glassesNameLbl;
@property (weak, nonatomic) IBOutlet UIView *stepperView;
@property (nonatomic, weak) IBOutlet UIButton *stepperDecreaseBtn;
@property (nonatomic, weak) IBOutlet UILabel *stepperNumLbl;
@property (nonatomic, weak) IBOutlet UIButton *stepperIncreaseBtn;
@property (nonatomic, weak) IBOutlet UITextField *unitPriceTf;
@property (nonatomic, weak) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIView *unitPriceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperatorHeight;
@property (nonatomic, weak) IBOutlet UILabel *totalPriceLbl;
//Lens with presbyopia fill column ball lens eyeglasses lenses complete specifications
@property (weak, nonatomic) IBOutlet UILabel *parameterLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactDegreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactBatchNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *degreeWidthConstraint;


@property (copy, nonatomic) CountBlock countBlock;
@property (copy, nonatomic) ExpandBlock expandBlock;
@property (copy, nonatomic) CartBlock  cartBlock;

@end

@implementation IPCExpandShoppingCartCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self.exptendButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft];
    [self.glassesImgView addBorder:3 Width:1];
}


- (void)setCartItem:(IPCShoppingCartItem *)cartItem Count:(void (^)())count Expand:(void (^)())expand Cart:(void (^)())cart
{
    _cartItem = cartItem;
    self.countBlock = count;
    self.expandBlock = expand;
    self.cartBlock = cart;
    totalHeight = 5;
    
    [self.checkBtn setHidden:self.isInOrder];
    [self.checkBtn setSelected:_cartItem.selected];
    [self.unitPriceView setHidden:self.isInOrder];
    [self.stepperView setHidden:self.isInOrder];
    self.imageLeftPadding.constant = self.isInOrder ? -20 : 20;
    
    if ([cartItem.glasses filterType] == IPCTopFilterTypeContactLenses || [cartItem.glasses filterType] == IPCTopFilterTypeAccessory) {
        [self.parameterLabel setTextColor:[UIColor lightGrayColor]];
        [self.parameterLabel setFont:[UIFont systemFontOfSize:11 weight:UIFontWeightThin]];
        [self.contactDegreeLabel setHidden:NO];[self.contactBatchNumLabel setHidden:NO];
        if ([cartItem.glasses filterType] == IPCTopFilterTypeAccessory) {
            self.degreeWidthConstraint.constant = 0;
        }
    }else{
        [self.parameterLabel setTextColor:[UIColor darkGrayColor]];
        [self.parameterLabel setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightThin]];
        [self.contactDegreeLabel setHidden:YES];[self.contactBatchNumLabel setHidden:YES];
    }
    
    if ([self isExpandable]) {
        self.mainView.hidden = !_cartItem.expanded;
        [self.separatorView setHidden:NO];
        self.seperatorHeight.constant = 25;
        [self constructUI];
    }else{
        self.seperatorHeight.constant = 0;
        [self.separatorView setHidden:YES];
        [self.mainView setHidden:YES];
    }
    
    IPCGlassesImage *gi = [_cartItem.glasses imageWithType:IPCGlassesImageTypeThumb];
    if (gi)[self.glassesImgView setImageWithURL:[NSURL URLWithString:gi.imageURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
    
    self.glassesNameLbl.text = _cartItem.glasses.glassName;
    self.unitPriceTf.text    = [NSString stringWithFormat:@"%.f", _cartItem.unitPrice];
    
    if ([cartItem.glasses filterType] == IPCTopFilterTypeLens) {
        if (cartItem.batchSph.length && cartItem.bacthCyl.length)
            [self.parameterLabel setText:[NSString stringWithFormat:@"球镜/SPH: %@  柱镜/CYL: %@",cartItem.batchSph,cartItem.bacthCyl]];
    }else if([cartItem.glasses filterType] == IPCTopFilterTypeContactLenses || [cartItem.glasses filterType] == IPCTopFilterTypeAccessory){
        if (cartItem.contactDegree.length)
            [self.contactDegreeLabel setText:[NSString stringWithFormat:@"度数: %@",cartItem.contactDegree]];
        if (cartItem.batchNum.length)
            [self.contactBatchNumLabel setText:[NSString stringWithFormat:@"批次号: %@",cartItem.batchNum]];
        if (cartItem.kindNum.length && cartItem.validityDate.length)
            [self.parameterLabel setText:[NSString stringWithFormat:@"准字号：%@   有效期：%@",cartItem.kindNum,cartItem.validityDate]];
    }else if([cartItem.glasses filterType] == IPCTopFilterTypeReadingGlass){
        if (cartItem.batchReadingDegree.length)
            [self.parameterLabel setText:[NSString stringWithFormat:@"度数: %@",cartItem.batchReadingDegree]];
    }
    
    [self updateUIByCount];
}

#pragma mark //Set UI
- (void)constructUI
{
    [self.mainView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.cartItem.expanded) {
        if ([self.cartItem.glasses filterType] == IPCTopFilterTypeLens) {
            [self addThickenView];
            [self addThinnerView];
            [self addShiftView];
            [self addRemarksView];
        } else {
            [self addIORView];
            [self addLensTypeView];
            [self addLensFuncView];
            [self addThickenView];
            [self addThinnerView];
            [self addShiftView];
            [self addRemarksView];
        }
    }
}


- (void)addIORView
{
    [self addButtonsViewWithTitle:@"折射率"
            supportMultipleChoice:NO
                            items:@[@"1.601", @"1.670", @"1.740"]
                     defaultItems:self.cartItem.IOROptions
                              tag:101];
}

- (void)addLensTypeView
{
    [self addButtonsViewWithTitle:@"镜片类型"
            supportMultipleChoice:NO
                            items:@[@"单焦点", @"多焦点"]
                     defaultItems:self.cartItem.lensTypes
                              tag:102];
}

- (void)addLensFuncView
{
    [self addButtonsViewWithTitle:@"镜片功能"
            supportMultipleChoice:YES
                            items:@[@"无", @"双光", @"内渐进", @"外渐进", @"防蓝光", @"抗疲劳", @"染色", @"变色", @"偏光"]
                     defaultItems:self.cartItem.lensFuncs
                              tag:103];
}

- (void)addThickenView
{
    [self addButtonsViewWithTitle:@"加厚（mm）"
            supportMultipleChoice:NO
                            items:@[@"0", @"+1", @"+2", @"+3", @"+4"]
                     defaultItems:self.cartItem.thickenOptions
                              tag:104];
}

- (void)addThinnerView
{
    [self addButtonsViewWithTitle:@"美薄"
            supportMultipleChoice:NO
                            items:@[@"是", @"否"]
                     defaultItems:self.cartItem.thinnerOptions
                              tag:105];
}

- (void)addShiftView
{
    [self addButtonsViewWithTitle:@"移心（mm）"
            supportMultipleChoice:NO
                            items:@[@"0", @"5", @"6", @"7", @"8", @"9"]
                     defaultItems:self.cartItem.shiftOptions
                              tag:106];
}

- (void)addButtonsViewWithTitle:(NSString *)title
          supportMultipleChoice:(BOOL)supportMultipleChoice
                          items:(NSArray *)items
                   defaultItems:(NSArray *)defaultItems
                            tag:(NSInteger)tag
{
    CGFloat actualHeight = 25;
    CGFloat vMargin = 10;
    CGFloat btnWidth = 64;
    CGFloat spacing = 8;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, totalHeight, self.mainView.jk_width, actualHeight + vMargin)];
    view.tag = tag;
    totalHeight += view.jk_height;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, actualHeight)];
    lbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    lbl.textColor = [UIColor lightGrayColor];
    lbl.text = title;
    [view addSubview:lbl];
    
    for (int i = 0; i < items.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(lbl.jk_right + (btnWidth + spacing) * i, 0, btnWidth, actualHeight);
        btn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn jk_setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn jk_setBackgroundColor:COLOR_RGB_BLUE forState:UIControlStateSelected];
        [btn setTitle:items[i] forState:UIControlStateNormal];
        
        for (NSString *str in defaultItems) {
            if ([str isEqualToString:items[i]]) {
                btn.selected = YES;
                break;
            }
        }
        [self updateBorderForButtonSelection:btn];
        [btn addTarget:self action:@selector(onButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    [self.mainView addSubview:view];
}

- (void)addRemarksView
{
    IQTextView *tv = [[IQTextView alloc] initWithFrame:CGRectMake(0, totalHeight, self.mainView.jk_width, 40)];
    tv.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    tv.delegate = self;
    tv.returnKeyType = UIReturnKeyDone;
    tv.text = self.cartItem.remarks;
    tv.placeholder = @"请输入商品备注信息...";
    [tv addBorder:3 Width:1];
    [self.mainView addSubview:tv];
    
}

#pragma mark //Clicked Events
- (void)onButtonTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self updateBorderForButtonSelection:sender];
    
    NSMutableArray *selected = [NSMutableArray new];
    
    UIView *parent = sender.superview;
    for (UIButton *btn in parent.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            
            BOOL handled = NO;
            
            if (parent.tag == 103) {
                if ([[sender titleForState:UIControlStateNormal] isEqual:@"无"] && sender.selected) {
                    if (btn != sender) {
                        btn.selected = NO;
                        [self updateBorderForButtonSelection:btn];
                        handled = YES;
                    }
                } else if (![[sender titleForState:UIControlStateNormal] isEqual:@"无"] && sender.selected) {
                    if ([[btn titleForState:UIControlStateNormal] isEqual:@"无"] && btn.selected) {
                        btn.selected = NO;
                        [self updateBorderForButtonSelection:btn];
                        handled = YES;
                    }
                }
            }
            
            if (!handled) {
                if (btn != sender) {
                    if (![self supportMultipleChoiceForTag:parent.tag]) {
                        btn.selected = NO;
                        [self updateBorderForButtonSelection:btn];
                    }
                }
            }
            if (btn.selected)[selected addObject:[btn titleForState:UIControlStateNormal]];
        }
    }
    
    switch (parent.tag) {
        case 101:
            self.cartItem.IOROptions = selected;
            break;
        case 102:
            self.cartItem.lensTypes = selected;
            break;
        case 103:
            self.cartItem.lensFuncs = selected;
            break;
        case 104:
            self.cartItem.thickenOptions = selected;
            break;
        case 105:
            self.cartItem.thinnerOptions = selected;
            break;
        case 106:
            self.cartItem.shiftOptions = selected;
            break;
        default:
            break;
    }
}

- (void)updateBorderForButtonSelection:(UIButton *)btn
{
    if (btn.selected) {
        btn.layer.cornerRadius = 4;
        btn.layer.borderColor = NULL;
        btn.layer.borderWidth = 0;
        btn.layer.masksToBounds = YES;
    } else {
        [btn  addBorder:3 Width:1];
        btn.layer.masksToBounds = YES;
    }
}

- (IBAction)onExpandBtnTapped:(id)sender
{
    self.cartItem.expanded = !self.cartItem.expanded;
    self.mainView.hidden = !self.cartItem.expanded;
    
    if (self.expandBlock) {
        self.expandBlock();
    }
}

- (IBAction)onCheckBtnTapped:(id)sender{
    self.checkBtn.selected = !self.checkBtn.selected;
    self.cartItem.selected = !self.cartItem.selected;
    [self notifyCountChanged];
}


- (IBAction)onStepperDecreaseBtnTapped:(id)sender{
    if (self.cartItem.count == 1) {
        [IPCUIKit showAlert:@"冰点云" Message:@"确认要删除该商品吗?" Owner:[UIApplication sharedApplication].keyWindow.rootViewController Done:^{
            [[IPCShoppingCart sharedCart] reduceItem:self.cartItem];
            [self notifyCountChanged];
        }];
    }else{
        [[IPCShoppingCart sharedCart] reduceItem:self.cartItem];
        [self notifyCountChanged];
    }
}

/**
 *  When add contacts to determine the inventory
 *
 *
 */
- (IBAction)onStepperIncreaseBtnTapped:(id)sender{
    if (([self.cartItem.glasses filterType] == IPCTopFilterTypeContactLenses && self.cartItem.glasses.isBatch) || ([self.cartItem.glasses filterType] == IPCTopFilterTypeAccessory && self.cartItem.glasses.solutionType))
    {
        if (self.cartBlock) {
            self.cartBlock();
        }
    }else{
        [[IPCShoppingCart sharedCart] plusItem:self.cartItem];
        [self notifyCountChanged];
    }
}

- (void)notifyCountChanged
{
    if (self.countBlock) {
        self.countBlock();
    }
}

- (void)updateUIByCount
{
    self.totalPriceLbl.text = [NSString stringWithFormat:@"￥%.f", [[IPCShoppingCart sharedCart]itemsCount:self.cartItem] * self.cartItem.unitPrice];
    self.countLbl.text      = [NSString stringWithFormat:@"x%ld", (long)[[IPCShoppingCart sharedCart]itemsCount:self.cartItem]];
    self.stepperNumLbl.text = [NSString stringWithFormat:@"%ld", (long)[[IPCShoppingCart sharedCart]itemsCount:self.cartItem]];
    self.unitPriceTf.text   = [NSString stringWithFormat:@"%.f", self.cartItem.unitPrice];
}


#pragma mark //UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![IPCCommon judgeIsNumber:string])return NO;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * str = [textField.text jk_trimmingWhitespace];
    
    if ([textField isEqual:self.unitPriceTf]) {
        double price = [str doubleValue];
        
        if (price > 0) {
            self.cartItem.unitPrice = price;
            [self updateUIByCount];
            
            if (self.countBlock) {
                self.countBlock();
            }
        }
    }
}

#pragma mark //UITextViewDelegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.cartItem.remarks = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView endEditing:YES];
        return NO;
    }
    return YES;
}

#pragma mark //Determine whether a
- (BOOL)isExpandable
{
    if ([self.cartItem.glasses filterType] == IPCTopFilterTypeLens || [self.cartItem.glasses filterType] == IPCTopFilterTypeCustomized)return  YES;
    return  NO;
}

#pragma mark //Determine whether to choose more
- (BOOL)supportMultipleChoiceForTag:(NSInteger)tag
{
    if (tag == 103)
        return YES;
    return NO;
}

@end
