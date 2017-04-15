//
//  IPCPayOrderTypeTopView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderTypeTopView.h"

@interface IPCPayOrderTypeTopView()


@property (weak, nonatomic) IBOutlet UIView *payStyleContentView;
@property (weak, nonatomic) IBOutlet UILabel *payTotalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectStoreValueButton;
@property (weak, nonatomic) IBOutlet UILabel *storeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerStoreValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectPayStyleButton;
@property (weak, nonatomic) IBOutlet UILabel *payAmountLabel;


@end

@implementation IPCPayOrderTypeTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderTypeTopView" owner:self];
        [self addSubview:view];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];

    [self.payStyleContentView addBorder:1 Width:1];
}

- (IBAction)closeAction:(id)sender {
}


- (IBAction)selectStoreValueAction:(id)sender {
}

- (IBAction)selectPayStyleAction:(id)sender {
}

@end
