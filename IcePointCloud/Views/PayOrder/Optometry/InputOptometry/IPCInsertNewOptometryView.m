//
//  IPCInsertNewOptometryView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCInsertNewOptometryView.h"
#import "IPCEmployeListView.h"

@interface IPCInsertNewOptometryView()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView  * inputHeadView;
@property (weak, nonatomic) IBOutlet UIView          * inputInfoView;
@property (weak, nonatomic) IBOutlet UIView * inputMemoView;
@property (weak, nonatomic) IBOutlet UIView *editContentView;
@property (weak, nonatomic) IBOutlet UITextField *employeeTextField;
@property (weak, nonatomic) IBOutlet UIButton *farButton;
@property (weak, nonatomic) IBOutlet UIButton *nearButton;
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
@property (weak, nonatomic) IBOutlet UITextView *memoTextField;

@property (copy, nonatomic) void(^CompleteBlock)();
@property (nonatomic, strong) IPCOptometryMode * insertOptometry;///新建验光单

@end

@implementation IPCInsertNewOptometryView

- (instancetype)initWithFrame:(CGRect)frame Complete:(void(^)())complete
{
    self = [super initWithFrame:frame];
    if (self) {
        self.CompleteBlock = complete;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCInsertNewOptometryView" owner:self];
        [self addSubview:view];
    
        self.insertOptometry = [[IPCOptometryMode alloc]init];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.inputInfoView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField * textField = (UITextField *)obj;
            [textField addBottomLine];
        }
    }];
    
    [self.inputHeadView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            UITextField * textField = (UITextField *)obj;
            [textField addBottomLine];
        }
    }];
    
    [self.memoTextField addBorder:0 Width:1 Color:nil];
    
    [self.employeeTextField setRightButton:self Action:@selector(selectEmployeeAction) OnView:self.inputHeadView];
}

#pragma mark //Request Methods
- (void)saveNewOptometry
{
    [IPCCustomerRequestManager storeUserOptometryInfoWithCustomID:[IPCPayOrderManager sharedManager].currentCustomerId
                                                          SphLeft:self.insertOptometry.sphLeft
                                                         SphRight:self.insertOptometry.sphRight
                                                          CylLeft:self.insertOptometry.cylLeft
                                                         CylRight:self.insertOptometry.cylRight
                                                         AxisLeft:self.insertOptometry.axisLeft
                                                        AxisRight:self.insertOptometry.axisRight
                                                          AddLeft:self.insertOptometry.addLeft
                                                         AddRight:self.insertOptometry.addRight
                                              CorrectedVisionLeft:self.insertOptometry.correctedVisionLeft
                                             CorrectedVisionRight:self.insertOptometry.correctedVisionRight
                                                     DistanceLeft:self.insertOptometry.distanceLeft
                                                    DistanceRight:self.insertOptometry.distanceRight
                                                          Purpose:self.insertOptometry.purpose
                                                       EmployeeId:self.insertOptometry.employeeId
                                                     EmployeeName:self.insertOptometry.employeeName
                                                     SuccessBlock:^(id responseValue)
     {
         [IPCCurrentCustomer sharedManager].currentOpometry = [IPCOptometryMode mj_objectWithKeyValues:responseValue];
         [self removeFromSuperview];
         
         if (self.CompleteBlock) {
             self.CompleteBlock();
         }
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark //Clicked Events
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}


- (IBAction)saveAction:(id)sender {
    [self saveNewOptometry];
}

#pragma mark //Clicked Events
- (IBAction)rightInputAction:(id)sender {
    self.insertOptometry.sphRight = self.insertOptometry.sphLeft;
    self.insertOptometry.cylRight   = self.insertOptometry.cylLeft;
    self.insertOptometry.axisRight = self.insertOptometry.axisLeft;
    self.insertOptometry.addRight  = self.insertOptometry.addLeft;
    self.insertOptometry.correctedVisionRight = self.insertOptometry.correctedVisionLeft;
    self.insertOptometry.distanceRight = self.insertOptometry.distanceLeft;
    [self updateInsertOptometry];
}

- (IBAction)leftInputAction:(id)sender {
    self.insertOptometry.sphLeft = self.insertOptometry.sphRight;
    self.insertOptometry.cylLeft   = self.insertOptometry.cylRight;
    self.insertOptometry.axisLeft = self.insertOptometry.axisRight;
    self.insertOptometry.addLeft  = self.insertOptometry.addRight;
    self.insertOptometry.correctedVisionLeft = self.insertOptometry.correctedVisionRight;
    self.insertOptometry.distanceLeft = self.insertOptometry.distanceRight;
    [self updateInsertOptometry];
}

- (IBAction)farUseAction:(id)sender {
    [self.farButton setSelected:YES];
    [self.nearButton setSelected:NO];
    self.insertOptometry.purpose = @"FAR";
}


- (IBAction)nearUseAction:(id)sender {
    [self.farButton setSelected:NO];
    [self.nearButton setSelected:YES];
    self.insertOptometry.purpose = @"NEAR";
}

- (void)selectEmployeeAction
{
    IPCEmployeListView * listView = [[IPCEmployeListView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds
                                                                DismissBlock:^(IPCEmployee *employee)
                                     {
                                         self.insertOptometry.employeeId = employee.jobID;
                                         self.insertOptometry.employeeName = employee.name;
                                         [self updateInsertOptometry];
                                     }];
    [[UIApplication sharedApplication].keyWindow addSubview:listView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:listView];
}


- (void)updateInsertOptometry
{
    [self.leftSphTextField setText:self.insertOptometry.sphLeft];
    [self.leftCylTextField setText:self.insertOptometry.cylLeft];
    [self.leftAddTextField setText:self.insertOptometry.addLeft];
    [self.leftAxisTextField setText:self.insertOptometry.axisLeft];
    [self.leftDistanceTextField setText:self.insertOptometry.distanceLeft];
    [self.leftCorrectionTextField setText:self.insertOptometry.correctedVisionLeft];
    
    [self.rightSphTextField setText:self.insertOptometry.sphRight];
    [self.rightCylTextField setText:self.insertOptometry.cylRight];
    [self.rightAddTextField setText:self.insertOptometry.addRight];
    [self.rightAxisTextField setText:self.insertOptometry.axisRight];
    [self.rightDistanceTextField setText:self.insertOptometry.distanceRight];
    [self.rightCorrectionTextField setText:self.insertOptometry.correctedVisionRight];
    
    [self.employeeTextField setText:self.insertOptometry.employeeName];
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
            self.insertOptometry.sphLeft = textField.text;
            break;
        case 1:
            self.insertOptometry.sphRight = textField.text;
            break;
        case 2:
            self.insertOptometry.cylLeft =textField.text;
            break;
        case 3:
            self.insertOptometry.cylRight = textField.text;
            break;
        case 4:
            self.insertOptometry.axisLeft =textField.text;
            break;
        case 5:
            self.insertOptometry.axisRight = textField.text;
            break;
        case 6:
            self.insertOptometry.addLeft = textField.text;
            break;
        case 7:
            self.insertOptometry.addRight = textField.text;
            break;
        case 8:
            self.insertOptometry.correctedVisionLeft = textField.text;
            break;
        case 9:
            self.insertOptometry.correctedVisionRight = textField.text;
            break;
        case 10:
            self.insertOptometry.distanceLeft = textField.text;
            break;
        case 11:
            self.insertOptometry.distanceRight = textField.text;
            break;
        default:
            break;
    }
}

#pragma mark //UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.insertOptometry.remark =  [textView.text jk_trimmingWhitespace];
}


@end
