//
//  ShoppingCartView.m
//  IcePointCloud
//
//  Created by mac on 2017/2/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "ShoppingCartView.h"

typedef  void(^DismissBlock)();

@interface ShoppingCartView ()

@property (weak, nonatomic) IBOutlet UIView *cartContentView;
@property (copy, nonatomic) DismissBlock dismissBlock;


@end

@implementation ShoppingCartView

- (void)show
{
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.frame;
        frame.origin.x -= self.jk_width;
        self.frame = frame;
    } completion:nil];
}

- (IBAction)onBgClicked:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    
}

@end
