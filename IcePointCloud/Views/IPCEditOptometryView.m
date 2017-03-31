//
//  EditOptometryView.m
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCEditOptometryView.h"

@implementation IPCEditOptometryView

- (instancetype)initWithFrame:(CGRect)frame
               LensViewHeight:(CGFloat)lensViewHeight
                    ItemWidth:(CGFloat)itemWidth
                   OrignSpace:(CGFloat)orignSpace
                     Spaceing:(CGFloat)spacing
                OptometryInfo:(NSArray *)optometryInfo
                    IsCanEdit:(BOOL)isCanEdit
{
    self = [super initWithFrame:frame];
    if (self) {
        self.allOptometryInfo = optometryInfo;
        
        NSArray *lensItems = @[@"球镜/SPH", @"柱镜/CYL", @"轴位/AXIS", @"下加光/ADD", @"矫正视力/VA",@"双眼瞳距/PD"];
        
        for (int i = 0; i < 3; i++) {
            UIView *lensView = [[UIView alloc] initWithFrame:CGRectMake(0, (lensViewHeight+orignSpace) * i, self.jk_width, lensViewHeight)];
            [self addSubview:lensView];
            
            UIImageView *imgView = nil;
            if (i != 2) {
                imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(i==1 ? @"icon_left" : @"icon_right")]];
                imgView.contentMode = UIViewContentModeScaleAspectFit;
                CGRect frame   = imgView.frame;
                frame.origin.y = (lensViewHeight - frame.size.height) / 2;
                imgView.frame  = frame;
                [lensView addSubview:imgView];
            }
            
            if ( i != 2) {
                for (int j = 0; j < lensItems.count-1; j++) {
                    [lensView addSubview:[self createLensView:CGRectMake(28 + 30 + (itemWidth + spacing) * j, 0, itemWidth, lensView.jk_height) Label:lensItems[j] Enabled:isCanEdit Tag:i*5 + j InputText:self.allOptometryInfo.count ? self.allOptometryInfo[i*5 + j] : @""]];
                }
            }else{
                [lensView addSubview:[self createLensView:CGRectMake(28 + 30, 0, itemWidth + 100, lensView.jk_height) Label:[lensItems lastObject] Enabled:isCanEdit Tag:10 InputText:self.allOptometryInfo.count ? self.allOptometryInfo[10] : @""]];
            }
            [IPCCustomUI clearAutoCorrection:lensView];
        }
    }
    return self;
}


- (UIView *)createLensView:(CGRect)rect Label:(NSString *)label Enabled:(BOOL)enable Tag:(NSInteger)tag InputText:(NSString *)text
{
    UIView *itemView = [[UIView alloc] initWithFrame:rect];
    [itemView addBorder:5 Width:0.7];
    
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, itemView.jk_height)];
    lbl.textColor = [UIColor lightGrayColor];
    lbl.text = label;
    lbl.font = [UIFont systemFontOfSize:13 weight:UIFontWeightThin];
    lbl.backgroundColor = [UIColor clearColor];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, itemView.jk_width-10, itemView.jk_height)];
    tf.textColor = [UIColor lightGrayColor];
    tf.delegate  = self;
    tf.font = [UIFont systemFontOfSize:13 weight:UIFontWeightThin];
    tf.textAlignment = NSTextAlignmentRight;
    tf.tag = tag;
    tf.returnKeyType = UIReturnKeyDone;
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.userInteractionEnabled = enable;
    tf.text = text;
    [tf setLeftView:lbl];
    [tf setLeftViewMode:UITextFieldViewModeAlways];
    [itemView addSubview:tf];
    
    [self.allTextFields addObject:tf];
    
    return itemView;
}

- (NSMutableArray<UITextField *> *)allTextFields{
    if (!_allTextFields)
        _allTextFields = [[NSMutableArray alloc]init];
    return _allTextFields;
}


- (NSString *)subString:(NSInteger)tag{
    __block NSString * text = @"";
    
    [self.allTextFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == tag){
            if (obj.text.length) {
                text = obj.text;
            }else if (tag == 0 || tag == 1 || tag == 5 || tag == 6){
                text = @"+0.00";
            }
        }
    }];
    return text;
}

- (UITextField *)subTextField:(NSInteger)tag{
    return (UITextField *)self.allTextFields[tag];
}

#pragma mark //UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![IPCCommon judgeIsNumber:string])
        return NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * str = [textField.text jk_trimmingWhitespace];
    
    //axis   0 － 180 Not a plus sign
    //correct  unlimited
    
    if (str.length > 0) {
        if (textField.tag != 10) {
            if (textField.tag == 2 || textField.tag == 7)
            {
                if ([str doubleValue] >= 0 && [str doubleValue] <= 180) {
                    [textField setText:[NSString stringWithFormat:@"%.f",[str doubleValue]]];
                }else{
                    [textField setText:@""];
                }
            }else if (textField.tag != 4 && textField.tag != 9){
                if (![str hasPrefix:@"-"]) {
                    [textField setText:[NSString stringWithFormat:@"+%.2f",[str doubleValue]]];
                }else{
                    [textField setText:[NSString stringWithFormat:@"%.2f",[str doubleValue]]];
                }
            }
        }else{
            [textField setText:[NSString stringWithFormat:@"%.f mm",[str doubleValue]]];
        }
    }else if (textField.tag == 0 || textField.tag == 1 || textField.tag == 5 || textField.tag == 6){
        [textField setText:@"+0.00"];
    }
}


@end
