//
//  IPCInsertNewOptometryView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCInsertNewOptometryView.h"
#import "IPCEmployeListView.h"
#import "IPCOptometryKeyboardView.h"
#import "IPCOptometryTextField.h"

@interface IPCInsertNewOptometryView()<IPCOptometryKeyboardViewDelegate,UITextFieldDelegate>
{
    BOOL         isRight;
    NSInteger   optometryIndex;
}

@property (weak, nonatomic) IBOutlet UIScrollView *optometryScrollView;
@property (weak, nonatomic) IBOutlet UIView *optometryScrollContentView;
@property (weak, nonatomic) IBOutlet UIView *keyBoardView;
@property (weak, nonatomic) IBOutlet UIView  * inputHeadView;
@property (weak, nonatomic) IBOutlet UIView  * inputInfoView;
@property (weak, nonatomic) IBOutlet UIView *editContentView;
@property (weak, nonatomic) IBOutlet UITextField *employeeTextField;
@property (weak, nonatomic) IBOutlet UIButton *farButton;
@property (weak, nonatomic) IBOutlet UIButton *nearButton;
@property (weak, nonatomic) IBOutlet UILabel *keyboardTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyboardValueLabel;
@property (weak, nonatomic) IBOutlet UITextField *memoTextField;
@property (nonatomic, strong) IPCOptometryKeyboardView * keyboard;
@property (nonatomic, strong) IPCOptometryMode * insertOptometry;///新建验光单
@property (nonatomic, copy) void(^CompleteBlock)(IPCOptometryMode *);
@property (nonatomic, copy) NSString  * customerId;
@property (nonatomic, strong) NSMutableArray<IPCOptometryTextField *> * allTextFields;


@end

@implementation IPCInsertNewOptometryView

- (instancetype)initWithFrame:(CGRect)frame CustomerId:(NSString *)customerId CompleteBlock:(void (^)(IPCOptometryMode * optometry))complete
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCInsertNewOptometryView" owner:self];
        [self addSubview:view];
        
        isRight = YES;
        optometryIndex = -1;
        self.CompleteBlock = complete;
        self.customerId = customerId;
        self.insertOptometry = [[IPCOptometryMode alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preTextFieldEnding) name:@"IPCOptometryPreTextFieldEndEditingNotification" object:nil];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    [self.optometryScrollContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[IPCOptometryTextField class]]) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            IPCOptometryTextField * textField = (IPCOptometryTextField *)obj;
            [textField addBottomLine];
            [textField setPlaceHolderText:@"请输入"];
            [strongSelf.allTextFields addObject:textField];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:strongSelf action:@selector(tapTextFieldAction:)];
            [textField addGestureRecognizer:tap];
        }
    }];
    
    [self.employeeTextField setRightButton:self Action:@selector(selectEmployeeAction) OnView:self.inputHeadView];
    [self.keyBoardView addSubview:self.keyboard];
}

- (NSMutableArray<IPCOptometryTextField *> *)allTextFields
{
    if (!_allTextFields) {
        _allTextFields = [[NSMutableArray alloc]init];
    }
    return _allTextFields;
}

#pragma mark //Set UI
- (IPCOptometryKeyboardView *)keyboard
{
    if (!_keyboard) {
        _keyboard = [[IPCOptometryKeyboardView alloc]initWithFrame:self.keyBoardView.bounds];
        _keyboard.delegate = self;
    }
    return _keyboard;
}

- (IPCOptometryTextField *)currentTextField
{
    return [self textField:optometryIndex];
}

- (IPCOptometryTextField *)textField:(NSInteger)index
{
    __block IPCOptometryTextField * textField = nil;
    
    if (index > -1) {
        [self.allTextFields enumerateObjectsUsingBlock:^(IPCOptometryTextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag == index) {
                textField = obj;
            }
        }];
    }
    
    return textField;
}

- (void)reloadKeyboardUI:(NSInteger)tag
{
    [self.optometryScrollContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel * label = (UILabel *)obj;
            if (label.tag == tag) {
                [self.keyboardTitleLabel setText:label.text];
            }
        }
    }];
}

#pragma mark //Request Methods
- (void)saveNewOptometry
{
    [IPCCustomerRequestManager storeUserOptometryInfoWithCustomID:self.customerId
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
                                                     EmployeeName:self.employeeTextField.text
                                                    Comprehensive:self.insertOptometry.comprehensive
                                                           Remark:self.memoTextField.text
                                                     SuccessBlock:^(id responseValue)
     {
         IPCOptometryMode * optometry = [IPCOptometryMode mj_objectWithKeyValues:responseValue];
         if (self.CompleteBlock) {
             self.CompleteBlock(optometry);
         }
         
         [self removeFromSuperview];
         [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IPCOptometryPreTextFieldEndEditingNotification" object:nil];
     } FailureBlock:^(NSError *error) {
         [self removeFromSuperview];
         
         if (self.CompleteBlock) {
             self.CompleteBlock(nil);
         }
     }];
}

#pragma mark //Clicked Events
- (IBAction)cancelAction:(id)sender
{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IPCOptometryPreTextFieldEndEditingNotification" object:nil];
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


- (IBAction)leftOrRightChangeAction:(UISegmentedControl *)sender
{
    isRight = (sender.selectedSegmentIndex == 0 ? YES : NO);
    
    [self endEditing];
    [self reloadInfo];
}

- (void)reloadInfo
{
    if (isRight) {
        [[self textField:0] setText:self.insertOptometry.sphRight];
        [[self textField:1] setText:self.insertOptometry.cylRight];
        [[self textField:2] setText:self.insertOptometry.axisRight];
        [[self textField:3] setText:self.insertOptometry.addRight];
        [[self textField:4] setText:self.insertOptometry.correctedVisionRight];
        [[self textField:5] setText:self.insertOptometry.distanceRight];
    }else{
        [[self textField:0] setText:self.insertOptometry.sphLeft];
        [[self textField:1] setText:self.insertOptometry.cylLeft];
        [[self textField:2] setText:self.insertOptometry.axisLeft];
        [[self textField:3] setText:self.insertOptometry.addLeft];
        [[self textField:4] setText:self.insertOptometry.correctedVisionLeft];
        [[self textField:5] setText:self.insertOptometry.distanceLeft];
    }
}

- (void)tapTextFieldAction:(UITapGestureRecognizer *)sender
{
    if ([self currentTextField]) {
        [[self currentTextField] endEditing];
    }
    
    optometryIndex = [sender.view tag];
    
    [self.allTextFields enumerateObjectsUsingBlock:^(IPCOptometryTextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == [sender view].tag) {
            [obj addBorder:0 Width:1 Color:COLOR_RGB_BLUE];
        }
    }];
    
    [self reloadKeyboardUI:[sender view].tag];
    [self.keyboardValueLabel setText:[self currentTextField].text];
    self.keyboard.isEdit = YES;
    [self.keyboard inputValue:[self currentTextField].text];
    [self.keyboard setIndex:optometryIndex];
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
    __weak typeof(self) weakSelf = self;
    IPCEmployeListView * listView = [[IPCEmployeListView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds
                                                                DismissBlock:^(IPCEmployee *employee)
                                     {
                                         __strong typeof(weakSelf) strongSelf = weakSelf;
                                         strongSelf.insertOptometry.employeeId = employee.jobID;
                                         [strongSelf.employeeTextField setText:employee.name];
                                     }];
    [[UIApplication sharedApplication].keyWindow addSubview:listView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:listView];
}

#pragma mark //IPCOptometryKeyboardViewDelegate
- (void)keyboardChangeEditing:(NSString *)text Keyboard:(IPCOptometryKeyboardView *)keyboard
{
    [self.keyboardValueLabel setText:text];
    [[self currentTextField] setText:text];
    [self inputOptometryInfo];
}

- (void)keyboardEndEditing:(NSString *)text Keyboard:(IPCOptometryKeyboardView *)keyboard
{
    [self endEditing];
    [self reloadInfo];
}

#pragma mark //Input Optometry Info
- (void)inputOptometryInfo
{
    switch (optometryIndex) {
        case 0:
            if (isRight) {
                self.insertOptometry.sphRight = [self appendSuffix];
            }else{
                self.insertOptometry.sphLeft = [self appendSuffix];
            }
            break;
        case 1:
            if (isRight) {
                self.insertOptometry.cylRight = [self appendSuffix];
            }else{
                self.insertOptometry.cylLeft = [self appendSuffix];
            }
            break;
        case 2:
            if (isRight) {
                self.insertOptometry.axisRight = [self appendSuffix];
            }else{
                self.insertOptometry.axisLeft = [self appendSuffix];
            }
            break;
        case 3:
            if (isRight) {
                self.insertOptometry.addRight = [self appendSuffix];
            }else{
                self.insertOptometry.addLeft = [self appendSuffix];
            }
            break;
        case 4:
            if (isRight) {
                self.insertOptometry.correctedVisionRight = [self appendSuffix];
            }else{
                self.insertOptometry.correctedVisionLeft = [self appendSuffix];
            }
            break;
        case 5:
            if (isRight) {
                self.insertOptometry.distanceRight = [self appendPdSuffix];
            }else{
                self.insertOptometry.distanceLeft = [self appendPdSuffix];
            }
            [self updateOptometryDistance];
            break;
        case 12:
            self.insertOptometry.comprehensive = [self appendPdSuffix];
            [self updateOptometryDistance];
            break;
        default:
            break;
    }
}

///添加后缀 ".00"
- (NSString *)appendSuffix
{
    if (![self currentTextField].text.length) {
        return @"";
    }
    if ([[self currentTextField].text containsString:@"+"] || [[self currentTextField].text containsString:@"-"]) {
        NSString * number = [[self currentTextField].text substringFromIndex:1];
        if ([IPCCommon judgeIsIntNumber:number]) {
            return [NSString stringWithFormat:@"%@%.2f", [[self currentTextField].text substringWithRange:NSMakeRange(0, 1)], [number doubleValue]];
        }
        return [self currentTextField].text;
    }
    return [NSString stringWithFormat:@"%.2f", [[self currentTextField].text doubleValue]];
}

- (NSString *)appendPdSuffix
{
    if (![self currentTextField].text.length) {
        return @"";
    }
    NSRange rang = [[self currentTextField].text rangeOfString:@"mm"];
    NSString * number = [[self currentTextField].text substringToIndex:rang.location];
    
    return [NSString stringWithFormat:@"%.2fmm", [number doubleValue]];
}

- (void)endEditing
{
    [self.keyboardTitleLabel setText:@""];
    [self.keyboardValueLabel setText:@""];
    [self.keyboard clearString];
    self.keyboard.isEdit = NO;
    [[self currentTextField] addBorder:0 Width:0 Color:nil];
    optometryIndex = -1;
}

/////修改瞳距
- (void)updateOptometryDistance
{
    double leftDistance = 0;
    double rightDistance = 0;
    
    if (optometryIndex == 5){
        if (isRight) {
            if (self.insertOptometry.distanceLeft.length) {
                leftDistance = [[self.insertOptometry.distanceLeft substringToIndex:self.insertOptometry.distanceLeft.length - 2] doubleValue];
            }
            if ([self currentTextField].text.length) {
                rightDistance = [[[self currentTextField].text substringToIndex:[self currentTextField].text.length - 2] doubleValue];
            }else{
                rightDistance = 0;
            }
        }else{
            if (self.insertOptometry.distanceRight.length) {
                rightDistance = [[self.insertOptometry.distanceRight substringToIndex:self.insertOptometry.distanceRight.length - 2] doubleValue];
            }
            if ([self currentTextField].text.length) {
                leftDistance = [[[self currentTextField].text substringToIndex:[self currentTextField].text.length - 2] doubleValue];
            }else{
                leftDistance = 0;
            }
        }
        if (rightDistance + leftDistance == 0) {
            [self textField:12].text = @"";
        }else{
            [self textField:12].text = [NSString stringWithFormat:@"%.2fmm", rightDistance + leftDistance];
        }
        self.insertOptometry.comprehensive = [self textField:12].text;
    }else if(optometryIndex == 12)
    {
        double comprehensive = 0;
        
        if ([self currentTextField].text.length) {
            comprehensive = [[[self currentTextField].text substringToIndex:[self currentTextField].text.length -2 ]doubleValue];
        }
        
        if (comprehensive > 0) {
            self.insertOptometry.distanceLeft   = [NSString stringWithFormat:@"%.2fmm", comprehensive/2];
            self.insertOptometry.distanceRight = [NSString stringWithFormat:@"%.2fmm", comprehensive/2];
        }else{
            self.insertOptometry.distanceLeft   = @"";
            self.insertOptometry.distanceRight = @"";
        }
        
        if (isRight) {
            [[self textField:5] setText:self.insertOptometry.distanceRight];
        }else{
            [[self textField:5] setText:self.insertOptometry.distanceLeft];
        }
    }
}

#pragma mark //UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self endEditing];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

#pragma mark //NSNotification method
- (void)preTextFieldEnding
{
    [self inputOptometryInfo];
    [self reloadInfo];
    [self endEditing];
}


@end
