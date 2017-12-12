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
{
    NSString * currentCustomerId;
}
@property (weak, nonatomic) IBOutlet UIView  * inputHeadView;
@property (weak, nonatomic) IBOutlet UIView  * inputInfoView;
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
@property (weak, nonatomic) IBOutlet UITextField *comprehensiveDistanceTextField;
@property (weak, nonatomic) IBOutlet UITextView *memoTextField;

@property (nonatomic, strong) IPCOptometryMode * insertOptometry;///新建验光单
@property (nonatomic, copy) void(^CompleteBlock)(IPCOptometryMode *);

@end

@implementation IPCInsertNewOptometryView

- (instancetype)initWithFrame:(CGRect)frame CustomerId:(NSString *)customerId CompleteBlock:(void (^)(IPCOptometryMode * optometry))complete
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCInsertNewOptometryView" owner:self];
        [self addSubview:view];
        
        self.CompleteBlock = complete;
        currentCustomerId = customerId;
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
    [IPCCustomerRequestManager storeUserOptometryInfoWithCustomID:currentCustomerId
                                                          SphLeft:self.leftSphTextField.text
                                                         SphRight:self.rightSphTextField.text
                                                          CylLeft:self.leftCylTextField.text
                                                         CylRight:self.rightCylTextField.text
                                                         AxisLeft:self.leftAxisTextField.text
                                                        AxisRight:self.rightAxisTextField.text
                                                          AddLeft:self.leftAddTextField.text
                                                         AddRight:self.rightAddTextField.text
                                              CorrectedVisionLeft:self.leftCorrectionTextField.text
                                             CorrectedVisionRight:self.rightCorrectionTextField.text
                                                     DistanceLeft:self.leftDistanceTextField.text
                                                    DistanceRight:self.rightDistanceTextField.text
                                                          Purpose:self.insertOptometry.purpose
                                                       EmployeeId:self.insertOptometry.employeeId
                                                     EmployeeName:self.employeeTextField.text
                                                    Comprehensive:self.comprehensiveDistanceTextField.text
                                                           Remark:self.memoTextField.text
                                                     SuccessBlock:^(id responseValue)
     {
         IPCOptometryMode * optometry = [IPCOptometryMode mj_objectWithKeyValues:responseValue];
         
         if (self.CompleteBlock) {
             self.CompleteBlock(optometry);
         }
     } FailureBlock:^(NSError *error) {
         if (self.CompleteBlock) {
             self.CompleteBlock(nil);
         }
     }];
}

#pragma mark //Clicked Events
- (IBAction)cancelAction:(id)sender {
    if (self.CompleteBlock) {
        self.CompleteBlock(nil);
    }
}


- (IBAction)saveAction:(id)sender {
    if (!self.insertOptometry.purpose.length) {
        self.insertOptometry.purpose = @"FAR";
    }
    if (!self.employeeTextField.text.length){
        [IPCCommonUI showError:@"请选择验光师"];
    }else{
        [self saveNewOptometry];
    }
}

#pragma mark //Clicked Events
- (IBAction)rightInputAction:(id)sender {
    [self.rightSphTextField setText:self.leftSphTextField.text];
    [self.rightCylTextField setText:self.leftCylTextField.text];
    [self.rightAddTextField setText:self.leftAddTextField.text];
    [self.rightAxisTextField setText:self.leftAxisTextField.text];
    [self.rightDistanceTextField setText:self.leftDistanceTextField.text];
    [self.rightCorrectionTextField setText:self.leftCorrectionTextField.text];
}

- (IBAction)leftInputAction:(id)sender {
    [self.leftSphTextField setText:self.rightSphTextField.text];
    [self.leftCylTextField setText:self.rightCylTextField.text];
    [self.leftAddTextField setText:self.rightAddTextField.text];
    [self.leftAxisTextField setText:self.rightAxisTextField.text];
    [self.leftDistanceTextField setText:self.rightDistanceTextField.text];
    [self.leftCorrectionTextField setText:self.rightCorrectionTextField.text];
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
                                         [self.employeeTextField setText:employee.name];
                                     }];
    [[UIApplication sharedApplication].keyWindow addSubview:listView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:listView];
}

#pragma mark //UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![IPCCommon judgeIsNumber:string])
        return NO;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 12) {
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
            }else if (textField.tag == 10 || textField.tag == 11 || textField.tag == 12){
                [self updateOptometryDistance:textField Text:str];
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

///修改瞳距
- (void)updateOptometryDistance:(UITextField *)textField Text:(NSString *)text
{
    if (textField.tag == 10 )
    {
        double leftDistance = 0;
        if (self.insertOptometry.distanceLeft.length) {
            leftDistance = [[self.leftDistanceTextField.text substringToIndex:self.leftDistanceTextField.text.length - 3] doubleValue];
        }
        
        textField.text = [NSString stringWithFormat:@"%.2f mm",[text doubleValue]];
        self.comprehensiveDistanceTextField.text = [NSString stringWithFormat:@"%.2f mm", [text doubleValue] + leftDistance];
        
    }else if (textField.tag == 11){
        double rightDistance = 0;
        if (self.insertOptometry.distanceRight) {
            rightDistance = [[self.rightDistanceTextField.text substringToIndex:self.rightDistanceTextField.text.length - 3] doubleValue];
        }
        
        textField.text = [NSString stringWithFormat:@"%.2f mm",[text doubleValue]];
        self.comprehensiveDistanceTextField.text = [NSString stringWithFormat:@"%.2f mm", [text doubleValue] + rightDistance];
    }else{
        textField.text = [NSString stringWithFormat:@"%.2f mm",[text doubleValue]];
        
        self.leftDistanceTextField.text   = [NSString stringWithFormat:@"%.2f mm",[text doubleValue]/2];
        self.rightDistanceTextField.text = [NSString stringWithFormat:@"%.2f mm",[text doubleValue]/2];
    }
}


@end
