//
//  IPCPayOrderInputOptometryView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/17.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderInputOptometryView.h"

@interface IPCPayOrderInputOptometryView()

@property (weak, nonatomic) IBOutlet UITextField *leftSphTextField;
@property (weak, nonatomic) IBOutlet UITextField *leftCylTextField;
@property (weak, nonatomic) IBOutlet UITextField *leftAxisTextField;
@property (weak, nonatomic) IBOutlet UITextField *leftAddTextField;
@property (weak, nonatomic) IBOutlet UITextField *leftCorrectionTextField;
@property (weak, nonatomic) IBOutlet UITextField *leftDistanceTextField;
@property (weak, nonatomic) IBOutlet UITextField *rightSphTextField;
@property (weak, nonatomic) IBOutlet UITextField *rightCylTextField;
@property (weak, nonatomic) IBOutlet UITextField *rightAxisTextField;
@property (weak, nonatomic) IBOutlet UITextField *rightAddTextField;
@property (weak, nonatomic) IBOutlet UITextField *rightCorrectionTextField;
@property (weak, nonatomic) IBOutlet UITextField *rightDistanceTextField;

@end

@implementation IPCPayOrderInputOptometryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderInputOptometryView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UITextField class]]) {
                UITextField * textField = (UITextField *)obj;
                [textField addBottomLine];
            }
        }];
    }
    return self;
}

#pragma mark //Clicked Events
- (IBAction)rightInputAction:(id)sender {
    [IPCPayOrderManager sharedManager].insertOptometry.sphRight = [IPCPayOrderManager sharedManager].insertOptometry.sphLeft;
    [IPCPayOrderManager sharedManager].insertOptometry.cylRight   = [IPCPayOrderManager sharedManager].insertOptometry.cylLeft;
    [IPCPayOrderManager sharedManager].insertOptometry.axisRight = [IPCPayOrderManager sharedManager].insertOptometry.axisLeft;
    [IPCPayOrderManager sharedManager].insertOptometry.addRight  = [IPCPayOrderManager sharedManager].insertOptometry.addLeft;
    [IPCPayOrderManager sharedManager].insertOptometry.correctedVisionRight = [IPCPayOrderManager sharedManager].insertOptometry.correctedVisionLeft;
    [IPCPayOrderManager sharedManager].insertOptometry.distanceRight = [IPCPayOrderManager sharedManager].insertOptometry.distanceLeft;
    [self updateInsertOptometry];
}

- (IBAction)leftInputAction:(id)sender {
    [IPCPayOrderManager sharedManager].insertOptometry.sphLeft = [IPCPayOrderManager sharedManager].insertOptometry.sphRight;
    [IPCPayOrderManager sharedManager].insertOptometry.cylLeft   = [IPCPayOrderManager sharedManager].insertOptometry.cylRight;
    [IPCPayOrderManager sharedManager].insertOptometry.axisLeft = [IPCPayOrderManager sharedManager].insertOptometry.axisRight;
    [IPCPayOrderManager sharedManager].insertOptometry.addLeft  = [IPCPayOrderManager sharedManager].insertOptometry.addRight;
    [IPCPayOrderManager sharedManager].insertOptometry.correctedVisionLeft = [IPCPayOrderManager sharedManager].insertOptometry.correctedVisionRight;
    [IPCPayOrderManager sharedManager].insertOptometry.distanceLeft = [IPCPayOrderManager sharedManager].insertOptometry.distanceRight;
    [self updateInsertOptometry];
}

- (void)updateInsertOptometry
{
    [self.leftSphTextField setText:[IPCPayOrderManager sharedManager].insertOptometry.sphLeft];
    [self.leftCylTextField setText:[IPCPayOrderManager sharedManager].insertOptometry.cylLeft];
    [self.leftAddTextField setText:[IPCPayOrderManager sharedManager].insertOptometry.addLeft];
    [self.leftAxisTextField setText:[IPCPayOrderManager sharedManager].insertOptometry.axisLeft];
    [self.leftDistanceTextField setText:[IPCPayOrderManager sharedManager].insertOptometry.distanceLeft];
    [self.leftCorrectionTextField setText:[IPCPayOrderManager sharedManager].insertOptometry.correctedVisionLeft];
    
    [self.rightSphTextField setText:[IPCPayOrderManager sharedManager].insertOptometry.sphRight];
    [self.rightCylTextField setText:[IPCPayOrderManager sharedManager].insertOptometry.cylRight];
    [self.rightAddTextField setText:[IPCPayOrderManager sharedManager].insertOptometry.addRight];
    [self.rightAxisTextField setText:[IPCPayOrderManager sharedManager].insertOptometry.axisRight];
    [self.rightDistanceTextField setText:[IPCPayOrderManager sharedManager].insertOptometry.distanceRight];
    [self.rightCorrectionTextField setText:[IPCPayOrderManager sharedManager].insertOptometry.correctedVisionRight];
}

#pragma mark //UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![IPCCommon judgeIsNumber:string])
        return NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 11) {
        [textField resignFirstResponder];
    }else{
        UITextField * nextTextField = (UITextField *)[self viewWithTag:textField.tag+1];
        [nextTextField becomeFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString * str = [textField.text jk_trimmingWhitespace];
    
    if (str.length > 0) {
        if (textField.tag != 8 && textField.tag != 9) {
            if (textField.tag == 4 || textField.tag == 5)
            {
                if ([str doubleValue] >= 0 && [str doubleValue] <= 180) {
                    [textField setText:[NSString stringWithFormat:@"%.f",[str doubleValue]]];
                }else{
                    [textField setText:@""];
                }
            }else if (textField.tag == 10 || textField.tag == 11){
                [textField setText:[NSString stringWithFormat:@"%.2f mm",[str doubleValue]]];
            }else{
                if (![str hasPrefix:@"-"]) {
                    [textField setText:[NSString stringWithFormat:@"+%.2f",[str doubleValue]]];
                }else{
                    [textField setText:[NSString stringWithFormat:@"%.2f",[str doubleValue]]];
                }
            }
        }
    }else{
        if (textField.tag < 4) {
            [textField setText:@"+0.00"];
        }
    }

    switch (textField.tag) {
        case 0:
            [IPCPayOrderManager sharedManager].insertOptometry.sphLeft = textField.text;
            break;
        case 1:
            [IPCPayOrderManager sharedManager].insertOptometry.sphRight = textField.text;
            break;
        case 2:
            [IPCPayOrderManager sharedManager].insertOptometry.cylLeft =textField.text;
            break;
        case 3:
            [IPCPayOrderManager sharedManager].insertOptometry.cylRight = textField.text;
            break;
        case 4:
            [IPCPayOrderManager sharedManager].insertOptometry.axisLeft =textField.text;
            break;
        case 5:
            [IPCPayOrderManager sharedManager].insertOptometry.axisRight = textField.text;
            break;
        case 6:
            [IPCPayOrderManager sharedManager].insertOptometry.addLeft = textField.text;
            break;
        case 7:
            [IPCPayOrderManager sharedManager].insertOptometry.addRight = textField.text;
            break;
        case 8:
            [IPCPayOrderManager sharedManager].insertOptometry.correctedVisionLeft = textField.text;
            break;
        case 9:
            [IPCPayOrderManager sharedManager].insertOptometry.correctedVisionRight = textField.text;
            break;
        case 10:
            [IPCPayOrderManager sharedManager].insertOptometry.distanceLeft = textField.text;
            break;
        case 11:
            [IPCPayOrderManager sharedManager].insertOptometry.distanceRight = textField.text;
            break;
        default:
            break;
    }
}

@end
