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
@property (copy, nonatomic) void(^DismissBlock)();
@property (strong, nonatomic) IPCGlasses * currentGlass;

@end

@implementation IPCEditBatchParameterView

- (instancetype)initWithFrame:(CGRect)frame Glasses:(IPCGlasses *)glasses  Dismiss:(void(^)())dismiss
{
    self = [super initWithFrame:frame];
    if (self) {
        self.DismissBlock = dismiss;
        self.currentGlass = glasses;
     
        UIView * parameterBgView = [UIView jk_loadInstanceFromNibWithName:@"IPCEditBatchParameterView" owner:self];
        [parameterBgView setFrame:frame];
        [self addSubview:parameterBgView];
        
        [self.glassImageView setImageWithURL:[NSURL URLWithString:glasses.thumbImage.imageURL] placeholder:[UIImage imageNamed:@"default_placeHolder"]];
        [self.glassNameLabel setText:glasses.glassName];
        [self.glassPriceLabel setText:[NSString stringWithFormat:@"￥%.f",glasses.price]];
    
        if (glasses){
            CGAffineTransform transform = CGAffineTransformScale(self.editParameterView.transform, 0.2, 0.2);
            [self.editParameterView setTransform:transform];
        }
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self.editParameterView addBorder:8 Width:0 Color:nil];
    [self.glassImageView addBorder:5 Width:0.5 Color:nil];
    [self.parameterTableView setTableFooterView:[[UIView alloc]init]];
}

#pragma mark //Clicked Events
- (void)show{
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGAffineTransform newTransform =  CGAffineTransformConcat(self.editParameterView.transform,  CGAffineTransformInvert(self.editParameterView.transform));
        [self.editParameterView setTransform:newTransform];
        self.editParameterView.alpha = 1.0;
    } completion:nil];
}


- (IBAction)closeAction:(id)sender {
    [self removeCover];
}

- (void)removeCover{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        CGAffineTransform transform = CGAffineTransformScale(strongSelf.editParameterView.transform, 0.3, 0.3);
        [strongSelf.editParameterView setTransform:transform];
        strongSelf.editParameterView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [weakSelf removeFromSuperview];
            
            if (self.DismissBlock)
                self.DismissBlock();
        }
    }];
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

    IPCShoppingCartItem * cartItem = [[IPCShoppingCart sharedCart] batchParameterList:self.currentGlass][indexPath.row];
    [cell setCartItem:cartItem Reload:^{
        [self.parameterTableView reloadData];
    }];
    return cell;
}

#pragma mark //UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

@end
