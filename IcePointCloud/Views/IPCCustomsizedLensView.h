//
//  IPCCustomsizedLensView.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/21.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCCustomsizedLensView : UIView

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *sphTextField;
@property (weak, nonatomic) IBOutlet UITextField *cylTextField;
@property (weak, nonatomic) IBOutlet UITextField *axisTextField;
@property (weak, nonatomic) IBOutlet UITextField *distanceTextField;
@property (weak, nonatomic) IBOutlet UITextField *addTextField;
@property (weak, nonatomic) IBOutlet UITextField *channalTextField;
@property (weak, nonatomic) IBOutlet UITextField *addLayerTextField;
@property (weak, nonatomic) IBOutlet UITextField *dyeingTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic)  IBOutlet  UIView *otherContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherContentHeight;
@property (assign, nonatomic) BOOL isRight;

- (instancetype)initWithFrame:(CGRect)frame Update:(void(^)())update;
- (void)reloadUI;

@end
