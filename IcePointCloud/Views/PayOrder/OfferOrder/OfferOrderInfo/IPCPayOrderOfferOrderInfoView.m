//
//  IPCPayOrderOfferOrderInfoView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderOfferOrderInfoView.h"

@interface IPCPayOrderOfferOrderInfoView()

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountAmountLabel;
@property (weak, nonatomic) IBOutlet UITextField *discountAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *payAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *employeeNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;

@end

@implementation IPCPayOrderOfferOrderInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderOfferOrderInfoView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
       
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.discountAmountTextField addBottomLine];
    [self.payAmountTextField addBottomLine];
    
}


#pragma mark //Clicked Events
- (IBAction)selectEmployeeAction:(id)sender {
    
}

@end
