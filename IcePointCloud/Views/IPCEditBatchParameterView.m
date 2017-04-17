//
//  EditBatchParameterView.m
//  IcePointCloud
//
//  Created by mac on 16/9/5.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCEditBatchParameterView.h"
#import "IPCEditBatchParameterViewMode.h"
#import "IPCEditParameterCell.h"

static NSString * const parameterIdentifier = @"EditParameterCellIdentifier";

@interface IPCEditBatchParameterView()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIView * editContentView;
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
@property (strong, nonatomic) IPCEditBatchParameterViewMode * editParameterMode;
@property (copy, nonatomic) void(^DismissBlock)();

@end

@implementation IPCEditBatchParameterView

- (instancetype)initWithFrame:(CGRect)frame Glasses:(IPCGlasses *)glasses  Dismiss:(void(^)())dismiss
{
    self = [super initWithFrame:frame];
    if (self) {
        self.DismissBlock = dismiss;
        self.editParameterMode = [[IPCEditBatchParameterViewMode alloc]initWithGlasses:glasses UpdateUI:^{
            [self.parameterTableView reloadData];
        }];
     
        UIView * parameterBgView = [UIView jk_loadInstanceFromNibWithName:@"IPCEditBatchParameterView" owner:self];
        [parameterBgView setFrame:frame];
        [self addSubview:parameterBgView];
        
        [self.glassImageView setImageURL:[NSURL URLWithString:glasses.thumbImage.imageURL]];
        [self.noneAccessoryImageView setImageURL:[NSURL URLWithString:glasses.thumbImage.imageURL]];
        [self.glassNameLabel setText:glasses.glassName];
        [self.noneAccessoryNameLabel setText:glasses.glassName];
        [self.glassPriceLabel setText:[NSString stringWithFormat:@"￥%.f",glasses.price]];
        [self.noneAccessoryPriceLabel setText:[NSString stringWithFormat:@"￥%.f",glasses.price]];
    
        if (glasses){
            if ([glasses filterType] ==IPCTopFilterTypeLens) {
                [self.editParameterMode queryBatchStockRequest];
            }else if([glasses filterType] ==IPCTopFilterTypeReadingGlass){
                [self.editParameterMode queryBatchReadingDegreeRequest];
            }else if([glasses filterType] == IPCTopFilterTypeContactLenses){
                [self.editParameterMode  getContactLensSpecification];
            }else{
                [self.editParameterMode queryAccessoryStock];
            }
            
            if (([glasses filterType] == IPCTopFilterTypeAccessory && glasses.solutionType) && glasses.stock <= 0) {
                [self.editNoneAccessoryView setHidden:NO];
                self.editContentView = self.editNoneAccessoryView;
//                [self.noneAccessoryCartNumLbl setText:[NSString stringWithFormat:@"%d",[self cartItemAccessory].count]];
            }else{
                [self.editParameterView setHidden:NO];
                self.editContentView = self.editParameterView;
            }
            CGAffineTransform transform = CGAffineTransformScale(self.editContentView.transform, 0.2, 0.2);
            [self.editContentView setTransform:transform];
        }
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self.editParameterView addBorder:8 Width:0];
    [self.editNoneAccessoryView addBorder:8 Width:0];
    [self.glassImageView addBorder:5 Width:0.7];
    [self.noneAccessoryImageView addBorder:5 Width:0.7];
    [self.parameterTableView setTableFooterView:[[UIView alloc]init]];
}

//- (IPCShoppingCartItem *)cartItemAccessory{
//    return [[IPCShoppingCart sharedCart] preSellAccessoryForGlass:self.editParameterMode.currentGlass];
//}

#pragma mark //Clicked Events
- (void)show{
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGAffineTransform newTransform =  CGAffineTransformConcat(self.editContentView.transform,  CGAffineTransformInvert(self.editContentView.transform));
        [self.editContentView setTransform:newTransform];
        self.editContentView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}


- (IBAction)closeAction:(id)sender {
    [self removeCover];
}

- (IBAction)reduceNoneAccessoryCartAction:(id)sender {
//    [[IPCShoppingCart sharedCart] removeGlasses:self.editParameterMode.currentGlass];
//    [self.noneAccessoryCartNumLbl setText:[NSString stringWithFormat:@"%d",[self cartItemAccessory].count]];
//    if ([self cartItemAccessory].count == 0) {
//        [self removeCover];
//    }
}

- (IBAction)addNoneAccessoryCartAction:(id)sender {
//    [[IPCShoppingCart sharedCart] plusGlass:self.editParameterMode.currentGlass];
//    [self.noneAccessoryCartNumLbl setText:[NSString stringWithFormat:@"%d",[self cartItemAccessory].count]];
}

- (void)removeCover{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGAffineTransform transform = CGAffineTransformScale(self.editContentView.transform, 0.3, 0.3);
        [self.editContentView setTransform:transform];
        self.editContentView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.DismissBlock)self.DismissBlock();
        }
    }];
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[IPCShoppingCart sharedCart] batchParameterList:self.editParameterMode.currentGlass].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCEditParameterCell * cell = [tableView dequeueReusableCellWithIdentifier:parameterIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCEditParameterCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
    }
    __weak typeof (self) weakSelf = self;
    IPCShoppingCartItem * cartItem = [[IPCShoppingCart sharedCart] batchParameterList:self.editParameterMode.currentGlass][indexPath.row];
    [cell setCartItem:cartItem Reload:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf.parameterTableView reloadData];
    }];
    
    __block BOOL isHasStock = NO;
    if ([self.editParameterMode.currentGlass filterType] ==IPCTopFilterTypeLens) {
        if ([self.editParameterMode queryLensStock:cartItem] > 0)
            isHasStock = YES;
    }else if ([self.editParameterMode.currentGlass filterType]== IPCTopFilterTypeReadingGlass){
        if ([self.editParameterMode queryReadingLensStock:cartItem] > 0)
            isHasStock = YES;
    }else if([self.editParameterMode.currentGlass filterType] == IPCTopFilterTypeContactLenses){
        if ([self.editParameterMode queryContactLensStock:cartItem] > 0 && cartItem.count < [self.editParameterMode queryContactLensStock:cartItem])
            isHasStock = YES;
    }else{
        if ([self.editParameterMode queryAccessoryStock:cartItem] > 0 && cartItem.count < [self.editParameterMode queryAccessoryStock:cartItem])
            isHasStock = YES;
    }
    [cell reloadAddButtonStatus:isHasStock];
    return cell;
}

#pragma mark //UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (([self.editParameterMode.currentGlass filterType] == IPCTopFilterTypeContactLenses && self.editParameterMode.currentGlass.stock > 0) || [self.editParameterMode.currentGlass filterType] == IPCTopFilterTypeAccessory)
        return 60;
    return 45;
}




@end
