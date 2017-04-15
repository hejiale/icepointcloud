//
//  IPCOtherPayTypeView.h
//  IcePointCloud
//
//  Created by gerry on 2017/4/15.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCOtherPayTypeView : UIView

@property (weak, nonatomic) IBOutlet UIButton *selectStyleButton;
@property (weak, nonatomic) IBOutlet UITextField *payTypeNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *payAmountTextField;
@property (weak, nonatomic) IBOutlet UILabel *payAmountLabel;

@end
