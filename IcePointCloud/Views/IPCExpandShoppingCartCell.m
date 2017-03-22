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
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *glassesImgView;
@property (nonatomic, weak) IBOutlet UIButton *checkBtn;
@property (nonatomic, weak) IBOutlet UILabel *glassesNameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *preSellImage;
@property (nonatomic, weak) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *glassNameHeight;
@property (copy, nonatomic) void(^ReloadBlock)();


@end

@implementation IPCExpandShoppingCartCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self.glassesImgView addBorder:3 Width:1];
}



- (void)setCartItem:(IPCShoppingCartItem *)cartItem Reload:(void(^)())reload
{
    _cartItem = cartItem;
    self.ReloadBlock = reload;
    [self.checkBtn setSelected:_cartItem.selected];
    
    IPCGlassesImage *gi = [_cartItem.glasses imageWithType:IPCGlassesImageTypeThumb];
    if (gi)[self.glassesImgView setImageWithURL:[NSURL URLWithString:gi.imageURL] placeholder:[UIImage imageNamed:@"glasses_placeholder"]];
    
    self.glassesNameLbl.text = _cartItem.glasses.glassName;
    self.countLbl.text      = [NSString stringWithFormat:@"x%ld", (long)[[IPCShoppingCart sharedCart]itemsCount:self.cartItem]];
    [self.unitPriceLabel setText:[NSString stringWithFormat:@"￥%.f", _cartItem.unitPrice]];
    
    if (self.cartItem.isPreSell) {
        [self.preSellImage setHidden:NO];
    }else{
        [self.preSellImage setHidden:YES];
    }
    
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
}


#pragma mark //UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![IPCCommon judgeIsNumber:string])return NO;
    return YES;
}

#pragma mark //Set UI
- (void)loadContactLensBatchSpecification:(CGFloat)height{
    UIView * specificationView = [[UIView alloc]initWithFrame:CGRectMake(self.glassesImgView.jk_right + 10, self.glassesNameLbl.jk_top+height+10, self.jk_width - self.glassesImgView.jk_right - 10, 30)];
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
    }else if ([self.cartItem.glasses filterType] == IPCTopFilterTypeAccessory && self.cartItem.glasses.solutionType){
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


#pragma mark //Clicked Events
- (IBAction)onCheckBtnTapped:(id)sender{
    self.cartItem.selected = !self.cartItem.selected;
    if (self.ReloadBlock) {
        self.ReloadBlock();
    }
}


@end
