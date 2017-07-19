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

@property (weak, nonatomic) IBOutlet UIView *editParameterView;
@property (weak, nonatomic) IBOutlet UITableView *parameterTableView;
@property (weak, nonatomic) IBOutlet UIImageView *glassImageView;
@property (weak, nonatomic) IBOutlet UILabel *glassNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *glassPriceLabel;
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
        [self.glassNameLabel setText:glasses.glassName];
        [self.glassPriceLabel setText:[NSString stringWithFormat:@"￥%.f",glasses.price]];
    
        if (glasses){
            if ([glasses filterType] ==IPCTopFilterTypeLens) {
                [self.editParameterMode queryBatchStockRequest];
            }else if([glasses filterType] ==IPCTopFilterTypeReadingGlass){
                [self.editParameterMode queryBatchReadingDegreeRequest];
            }else{
                [self.parameterTableView reloadData];
            }
//            else if([glasses filterType] == IPCTopFilterTypeContactLenses){
//                [self.editParameterMode  getContactLensSpecification];
//            }else{
//                [self.editParameterMode queryAccessoryStock];
//            }
            
            CGAffineTransform transform = CGAffineTransformScale(self.editParameterView.transform, 0.2, 0.2);
            [self.editParameterView setTransform:transform];
        }
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self.editParameterView addBorder:8 Width:0];
    [self.glassImageView addBorder:5 Width:0.5];
    [self.parameterTableView setTableFooterView:[[UIView alloc]init]];
}

#pragma mark //Clicked Events
- (void)show{
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGAffineTransform newTransform =  CGAffineTransformConcat(self.editParameterView.transform,  CGAffineTransformInvert(self.editParameterView.transform));
        [self.editParameterView setTransform:newTransform];
        self.editParameterView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}


- (IBAction)closeAction:(id)sender {
    [self removeCover];
}

- (void)removeCover{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGAffineTransform transform = CGAffineTransformScale(self.editParameterView.transform, 0.3, 0.3);
        [self.editParameterView setTransform:transform];
        self.editParameterView.alpha = 0;
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
    }
//    else if([self.editParameterMode.currentGlass filterType] == IPCTopFilterTypeContactLenses){
//        if ([self.editParameterMode queryContactLensStock:cartItem] > 0 && cartItem.glassCount < [self.editParameterMode queryContactLensStock:cartItem])
//            isHasStock = YES;
//    }else{
//        if ([self.editParameterMode queryAccessoryStock:cartItem] > 0 && cartItem.glassCount < [self.editParameterMode queryAccessoryStock:cartItem])
//            isHasStock = YES;
//    }
    [cell reloadAddButtonStatus:isHasStock];
    return cell;
}

#pragma mark //UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (([self.editParameterMode.currentGlass filterType] == IPCTopFilterTypeContactLenses && self.editParameterMode.currentGlass.stock > 0) || [self.editParameterMode.currentGlass filterType] == IPCTopFilterTypeAccessory)
//        return 60;
    return 45;
}




@end
