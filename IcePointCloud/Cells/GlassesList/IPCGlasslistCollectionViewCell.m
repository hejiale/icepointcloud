//
//  GlasslistCollectionViewCell.m
//  IcePointCloud
//
//  Created by mac on 16/6/27.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCGlasslistCollectionViewCell.h"

@implementation IPCGlasslistCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    __weak typeof(self) weakSelf = self;
    [self.productImageView addTapActionWithDelegate:nil Block:^(UIGestureRecognizer *gestureRecoginzer) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showDetailAction];
    }];
}


- (void)setGlasses:(IPCGlasses *)glasses{
    _glasses = glasses;
    
    if (_glasses)
    {
        //Reset Buy Icon Show Status
        [self resetBuyStatus];
        //Reload Product Image And Auto Fit
        IPCGlassesImage * glassImage = [self.glasses imageWithType:IPCGlassesImageTypeThumb];
        
        __block CGFloat scale = 0;
        if (glassImage.width > glassImage.height) {
            scale = glassImage.width/glassImage.height;
        }else{
            scale = glassImage.height/glassImage.width;
        }
        __block CGFloat width = 280;
        __block CGFloat height = width/scale;
        self.imageHeight.constant = MIN(height, 120);
        
        [self.productImageView setImageWithURL:[NSURL URLWithString:glassImage.imageURL] placeholder:[UIImage imageNamed:@"default_placeHolder"]];

        [self.priceLabel setText:[NSString stringWithFormat:@"￥%.f",_glasses.price]];
        [self.productNameLabel setSpaceWithText:_glasses.glassName LineSpace:10 WordSpace:0];
        //Get Name Text Height And Auto Fit
       CGFloat labelHeight = [self.productNameLabel.text jk_heightWithFont:self.productNameLabel.font constrainedToWidth:self.productNameLabel.jk_width];
        self.labelHeightConstraint.constant = labelHeight + 10;
        //Shopping cart whether to join the product
        __block NSInteger glassCount = [[IPCShoppingCart sharedCart]singleGlassesCount:_glasses];
        
        if (glassCount > 0) {
            [self.reduceButton setHidden:NO];
            [self.cartNumLabel setHidden:NO];
            self.reduceButtonLeading.constant = -70;
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
        //Glasses Try Icon And Stock Icon
        if (_glasses.isTryOn) {
            [self.defaultImageView setHidden:NO];
            self.tryWidth.constant = 39;
        }else{
            [self.defaultImageView setHidden:YES];
            self.tryWidth.constant = 0;
        }
        
        if (_glasses.stock > 0) {
            [self.noStockImageView setHidden:YES];
            self.noStockWidth.constant = 0;
        }else{
            [self.noStockImageView setHidden:NO];
            self.noStockWidth.constant = 39;
        }
        
        if (_glasses.isTryOn && _glasses.stock > 0) {
            self.tryLeft.constant = 0;
        }else{
            self.tryLeft.constant = 5;
        }
    }
}

#pragma mark //Clicked Events
- (IBAction)addCartAction:(id)sender {
    if (([self.glasses filterType] == IPCTopFilterTypeContactLenses || [self.glasses filterType] == IPCTopFilterTypeReadingGlass || [self.glasses filterType] == IPCTopFilterTypeLens) && self.glasses.isBatch)
    {
        if ([IPCPayOrderCurrentCustomer sharedManager].currentOpometry) {
            [self addBatchGlassesToCart];
        }else{
            if ([self.delegate respondsToSelector:@selector(chooseParameter:)]) {
                [self.delegate chooseParameter:self];
            }
        }
    }else{
        [self addCartAnimation];
    }
}

- (IBAction)reduceCartAction:(id)sender {
    if (([self.glasses filterType] == IPCTopFilterTypeContactLenses || [self.glasses filterType] == IPCTopFilterTypeReadingGlass || [self.glasses filterType] == IPCTopFilterTypeLens) && self.glasses.isBatch)
    {
        if ([self.delegate respondsToSelector:@selector(editBatchParameter:)]) {
            [self.delegate editBatchParameter:self];
        }
    }else{
        [self reduceCartAnimation];
    }
}


- (void)addCartAnimation{
    if (self.glasses) {
        [[IPCShoppingCart sharedCart] plusGlass:self.glasses];
        
        if ([self.delegate respondsToSelector:@selector(addShoppingCartAnimation:)])
            [self.delegate addShoppingCartAnimation:self];
    }
}


- (void)reduceCartAnimation{
    if (self.glasses) {
        [[IPCShoppingCart sharedCart] removeGlasses:self.glasses];
        
        if ([self.delegate respondsToSelector:@selector(reloadProductList:)]) {
            [self.delegate reloadProductList:self];
        }
    }
}

- (void)showDetailAction
{
    if ([self.delegate respondsToSelector:@selector(showProductDetail:)]) {
        [self.delegate showProductDetail:self];
    }
}

- (void)resetBuyStatus{
    [self.reduceButton setHidden:YES];
    [self.cartNumLabel setHidden:YES];
}

///按照已选客户验光单 新增镜片
- (void)addBatchGlassesToCart
{
    IPCOptometryMode * optometry = [IPCPayOrderCurrentCustomer sharedManager].currentOpometry;
    
    if ([_glasses filterType] == IPCTopFilterTypeReadingGlass) {
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [self querySuggestPriceWithSph:optometry.sphLeft.length ? optometry.sphLeft : @"0.00" Cyl:nil Complete:^{
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
        
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [self querySuggestPriceWithSph:optometry.sphRight.length ? optometry.sphRight : @"0.00" Cyl:nil Complete:^{
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [self reload];
        });
    }else{
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [self querySuggestPriceWithSph:optometry.sphLeft.length ? optometry.sphLeft : @"0.00" Cyl:optometry.cylLeft.length ? optometry.cylLeft : @"0.00" Complete:^{
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
        
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [self querySuggestPriceWithSph:optometry.sphRight.length ? optometry.sphRight : @"0.00" Cyl:optometry.cylRight.length ? optometry.cylRight : @"0.00" Complete:^{
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [self reload];
        });
    }
}

- (void)querySuggestPriceWithSph:(NSString *)sph Cyl:(NSString *)cyl Complete:(void(^)())complete
{
    if ([_glasses filterType] == IPCTopFilterTypeReadingGlass) {
        [IPCBatchRequestManager queryBatchLensPriceWithProductId:[self.glasses glassId]
                                                            Type:[self.glasses glassType]
                                                             Sph:sph
                                                             Cyl:@"0.00"
                                                    SuccessBlock:^(id responseValue){
                                                        [self reloadPrice:responseValue];
                                                        [self addLensToCartWithSph:sph Cyl:nil Complete:complete];
                                                    } FailureBlock: nil];
    }else{
        [IPCBatchRequestManager queryBatchLensPriceWithProductId:[self.glasses glassId]
                                                            Type:[self.glasses glassType]
                                                             Sph:sph
                                                             Cyl:cyl
                                                    SuccessBlock:^(id responseValue){
                                                        [self reloadPrice:responseValue];
                                                        [self addLensToCartWithSph:sph Cyl:cyl Complete:complete];
                                                    } FailureBlock: nil];
    }
}

- (void)reloadPrice:(id)responseValue
{
    IPCBatchGlassesConfig * config = [[IPCBatchGlassesConfig alloc] initWithResponseValue:responseValue];
    self.glasses.updatePrice = config.suggestPrice;
}

- (void)addLensToCartWithSph:(NSString *)sph Cyl:(NSString *)cyl Complete:(void(^)())complete
{
    if ([_glasses filterType] == IPCTopFilterTypeLens){
        [[IPCShoppingCart sharedCart] addLensWithGlasses:_glasses
                                                     Sph:sph
                                                     Cyl:cyl
                                                   Count:1];
    }else if([_glasses filterType] == IPCTopFilterTypeReadingGlass){
        [[IPCShoppingCart sharedCart] addReadingLensWithGlasses:_glasses
                                                  ReadingDegree:sph
                                                          Count:1];
    }else if([_glasses filterType] == IPCTopFilterTypeContactLenses){
        [[IPCShoppingCart sharedCart] addContactLensWithGlasses:_glasses
                                                            Sph:sph
                                                            Cyl:cyl
                                                          Count:1];
    }
    if (complete) {
        complete();
    }
}

- (void)reload
{
    if ([self.delegate respondsToSelector:@selector(reloadProductList:)]) {
        [self.delegate reloadProductList:self];
    }
    if ([self.delegate respondsToSelector:@selector(addShoppingCartAnimation:)])
        [self.delegate addShoppingCartAnimation:self];
}

@end
