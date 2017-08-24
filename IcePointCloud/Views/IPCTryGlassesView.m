//
//  IPCTryGlassesView.m
//  IcePointCloud
//
//  Created by gerry on 2017/8/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCTryGlassesView.h"

@interface IPCTryGlassesView()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addCartButton;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UILabel *cartNumLabel;

@property (copy, nonatomic) void(^ChooseBlock)();
@property (copy, nonatomic) void(^EditBlock)();
@property (copy, nonatomic) void(^AddCartBlock)();
@property (copy, nonatomic) void(^ReduceCartBlock)();
@property (copy, nonatomic) void(^TryGlassesBlock)();

@end

@implementation IPCTryGlassesView

- (instancetype)initWithFrame:(CGRect)frame ChooseParameter:(void (^)())choose EditParameter:(void (^)())edit AddCart:(void (^)())addCart ReduceCart:(void (^)())reduceCart TryGlasses:(void (^)())tryGlasses
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCTryGlassesView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        self.ChooseBlock = choose;
        self.EditBlock = edit;
        self.AddCartBlock = addCart;
        self.ReduceCartBlock = reduceCart;
        self.TryGlassesBlock = tryGlasses;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    [self.productImageView jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.TryGlassesBlock) {
            strongSelf.TryGlassesBlock();
        }
    }];
}

- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses) {
        [self resetBuyStatus];
        
        IPCGlassesImage * glassImage = [self.glasses imageWithType:IPCGlassesImageTypeThumb];
        [self.productImageView setImageURL:[NSURL URLWithString:glassImage.imageURL]];
        [self.priceLabel setText:[NSString stringWithFormat:@"￥%.f",_glasses.price]];
        [self.productNameLabel setText:_glasses.glassName];
        
        //Shopping cart whether to join the product
        __block NSInteger glassCount = [[IPCShoppingCart sharedCart]singleGlassesCount:_glasses];
        
        if (glassCount > 0) {
            [self.reduceButton setHidden:NO];
            [self.cartNumLabel setHidden:NO];
            [self.cartNumLabel setText:[[NSNumber numberWithInteger:glassCount]stringValue]];
            
            //Judge Cart Count
            __block NSInteger cartCount = [[IPCShoppingCart sharedCart] singleGlassesCount:_glasses];
            
            if (([_glasses filterType] == IPCTopFilterTypeContactLenses || [_glasses filterType] == IPCTopFilterTypeReadingGlass || [_glasses filterType] == IPCTopFilterTypeLens) && _glasses.isBatch)
            {
                [self.reduceButton setImage:[UIImage imageNamed:@"icon_cart_edit"] forState:UIControlStateNormal];
            }else{
                [self.reduceButton setImage:[UIImage imageNamed:@"icon_subtract"] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark //Clicked Events
- (IBAction)addCartAction:(id)sender {
    if (([self.glasses filterType] == IPCTopFilterTypeContactLenses || [self.glasses filterType] == IPCTopFilterTypeReadingGlass || [self.glasses filterType] == IPCTopFilterTypeLens) && self.glasses.isBatch)
    {
        if (self.ChooseBlock) {
            self.ChooseBlock();
        }
    }else{
        [self addCartAnimation];
    }
}

- (IBAction)reduceCartAction:(id)sender {
    if (([self.glasses filterType] == IPCTopFilterTypeContactLenses || [self.glasses filterType] == IPCTopFilterTypeReadingGlass || [self.glasses filterType] == IPCTopFilterTypeLens) && self.glasses.isBatch)
    {
        if (self.EditBlock) {
            self.EditBlock();
        }
    }else{
        [self reduceCartAnimation];
    }
}


- (void)addCartAnimation{
    if (self.glasses) {
        [[IPCShoppingCart sharedCart] plusGlass:self.glasses];
        
        if (self.AddCartBlock) {
            self.AddCartBlock();
        }
    }
}


- (void)reduceCartAnimation{
    if (self.glasses) {
        [[IPCShoppingCart sharedCart] removeGlasses:self.glasses];
        
        if (self.ReduceCartBlock) {
            self.ReduceCartBlock();
        }
    }
}

- (void)resetBuyStatus{
    [self.reduceButton setHidden:YES];
    [self.cartNumLabel setHidden:YES];
}


@end
