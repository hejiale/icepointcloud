//
//  IPCPayOrderEditCustomerView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCPayOrderEditCustomerView.h"

@interface IPCPayOrderEditCustomerView()<UITextFieldDelegate,IPCDatePickViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *customerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthDayTextField;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *editContentView;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (copy, nonatomic) void(^UpdateBlock)(NSString *);

@end

@implementation IPCPayOrderEditCustomerView

- (instancetype)initWithFrame:(CGRect)frame UpdateBlock:(void(^)(NSString *))update
{
    self = [super initWithFrame:frame];
    if (self) {
        self.UpdateBlock = update;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCPayOrderEditCustomerView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [self.editContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UITextField class]]) {
                UITextField * textFiedld = (UITextField *)obj;
                [textFiedld addBottomLine];
            }
        }];
        
        [self.birthDayTextField setRightButton:self Action:@selector(showDatePickerAction) OnView:self.editContentView];
    }
    return self;
}

- (void)updateCustomerInfo
{
    [self.customerNameTextField setText:[IPCCurrentCustomer sharedManager].currentCustomer.customerName];
    [self.phoneTextField setText:[IPCCurrentCustomer sharedManager].currentCustomer.customerPhone];
    [self.ageTextField setText:[IPCCurrentCustomer sharedManager].currentCustomer.age];
    [self.birthDayTextField setText:[IPCCurrentCustomer sharedManager].currentCustomer.birthday];
    
    if ([[IPCCurrentCustomer sharedManager].currentCustomer.gender isEqualToString:@"MALE"]) {
        [self.maleButton setSelected:YES];
    }else if ([[IPCCurrentCustomer sharedManager].currentCustomer.gender isEqualToString:@"FEMALE"]){
        [self.femaleButton setSelected:YES];
    }
}

#pragma mark //Request Methods
- (void)saveCustomerRequest
{
    [IPCCustomerRequestManager saveCustomerInfoWithCustomName:[IPCPayOrderManager sharedManager].insertCustomer.customerName
                                                  CustomPhone:[IPCPayOrderManager sharedManager].insertCustomer.customerPhone
                                                       Gender:[IPCPayOrderManager sharedManager].insertCustomer.gender
                                                        Email:@""
                                                     Birthday:[IPCPayOrderManager sharedManager].insertCustomer.birthday
                                                       Remark:@""
                                                OptometryList:@""
                                                  ContactName:@""
                                                ContactGender:@""
                                                 ContactPhone:@""
                                               ContactAddress:@""
                                                 CustomerType:@""
                                               CustomerTypeId:@""
                                                   Occupation:@""
                                                  MemberLevel:@""
                                                MemberLevelId:@""
                                                    MemberNum:@""
                                                      PhotoId:@""
                                                 IntroducerId:@""
                                            IntroducerInteger:@""
                                                          Age:[IPCPayOrderManager sharedManager].insertCustomer.age
                                                 SuccessBlock:^(id responseValue)
     {
         if (self.UpdateBlock) {
             self.UpdateBlock(responseValue[@"id"]);
         }
         [self removeFromSuperview];
         
     } FailureBlock:^(NSError *error) {
         if ([error code] != NSURLErrorCancelled) {
             [IPCCommonUI showError:@"保存客户信息失败!"];
         }
         if (self.UpdateBlock) {
             self.UpdateBlock(nil);
         }
     }];
}

#pragma mark //Clicked Events
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)completeAction:(id)sender {
    [self saveCustomerRequest];
}

- (IBAction)selectMaleAction:(id)sender {
    [self.maleButton setSelected:YES];
    [self.femaleButton setSelected:NO];
    
    if ([self isCustomer]) {
        [IPCCurrentCustomer sharedManager].currentCustomer.gender = @"MALE";
    }else{
        [IPCPayOrderManager sharedManager].insertCustomer.gender = @"MALE";
    }
}

- (IBAction)selectFemaleAction:(id)sender {
    [self.maleButton setSelected:NO];
    [self.femaleButton setSelected:YES];
    
    if ([self isCustomer]) {
        [IPCCurrentCustomer sharedManager].currentCustomer.gender = @"FEMALE";
    }else{
        [IPCPayOrderManager sharedManager].insertCustomer.gender = @"FEMALE";
    }
}

- (void)showDatePickerAction
{
    IPCDatePickViewController * datePickVC = [[IPCDatePickViewController alloc]initWithNibName:@"IPCDatePickViewController" bundle:nil];
    datePickVC.delegate = self;
    [datePickVC showWithPosition:CGPointMake(self.birthDayTextField.jk_width/2, self.birthDayTextField.jk_height) Size:CGSizeMake(self.birthDayTextField.jk_width-100, 150) Owner:self.birthDayTextField];
}

#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.customerNameTextField]) {
        if ([self isCustomer]) {
            [IPCCurrentCustomer sharedManager].currentCustomer.customerName = [textField.text jk_trimmingWhitespace];
        }else{
            [IPCPayOrderManager sharedManager].insertCustomer.customerName = [textField.text jk_trimmingWhitespace];
        }
    }else if ([textField isEqual:self.phoneTextField]){
        if ([self isCustomer]) {
            [IPCCurrentCustomer sharedManager].currentCustomer.customerPhone = [textField.text jk_trimmingWhitespace];
        }else{
            [IPCPayOrderManager sharedManager].insertCustomer.customerPhone = [textField.text jk_trimmingWhitespace];
        }
    }else{
        NSString * birthday = [NSDate jk_stringWithDate:[[NSDate date] jk_dateBySubtractingYears:[textField.text integerValue]] format:@"yyyy-01-01"];
        
        if ([self isCustomer]) {
            [IPCCurrentCustomer sharedManager].currentCustomer.age = [textField.text jk_trimmingWhitespace];
            [IPCCurrentCustomer sharedManager].currentCustomer.birthday = birthday;
        }else{
            [IPCPayOrderManager sharedManager].insertCustomer.age = [textField.text jk_trimmingWhitespace];
            [IPCPayOrderManager sharedManager].insertCustomer.birthday = birthday;
        }
        [self.birthDayTextField setText:birthday];
    }
}

#pragma mark //IPCDatePickViewControllerDelegate
- (void)completeChooseDate:(NSString *)date
{
    NSString *  age = [NSString stringWithFormat:@"%d",[[NSDate jk_dateWithString:date format:@"yyyy-MM-dd"] jk_distanceYearsToDate:[NSDate date]]];
    
    [self.birthDayTextField setText:date];
    [self.ageTextField setText:age];
    
    if ([self isCustomer]) {
        [IPCCurrentCustomer sharedManager].currentCustomer.birthday = date;
        [IPCCurrentCustomer sharedManager].currentCustomer.age = age;
    }else{
        [IPCPayOrderManager sharedManager].insertCustomer.birthday = date;
        [IPCPayOrderManager sharedManager].insertCustomer.age = age;
    }
}

- (BOOL)isCustomer
{
    if ([IPCPayOrderManager sharedManager].currentCustomerId) {
        return YES;
    }
    return NO;
}

@end
