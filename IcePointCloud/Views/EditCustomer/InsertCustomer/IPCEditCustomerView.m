//
//  IPCPayOrderEditCustomerView.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/20.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCEditCustomerView.h"

@interface IPCEditCustomerView()<UITextFieldDelegate,IPCDatePickViewControllerDelegate,IPCParameterTableViewDelegate,IPCParameterTableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *customerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthDayTextField;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *editContentView;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UILabel *customerStyleLabel;
@property (weak, nonatomic) IBOutlet UITextField *customStyleTextField;
@property (weak, nonatomic) IBOutlet UISwitch *upgradeSwitch;
@property (weak, nonatomic) IBOutlet UIView *upgradeMemberView;
@property (weak, nonatomic) IBOutlet UITextField *encryptedPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *growthValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *pointValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *storeValueTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;

@property (strong, nonatomic) IPCDetailCustomer * detailCustomer;
@property (copy, nonatomic) void(^UpdateBlock)(NSString *);

@end

@implementation IPCEditCustomerView

- (instancetype)initWithFrame:(CGRect)frame DetailCustomer:(IPCDetailCustomer *)customer UpdateBlock:(void (^)(NSString *))update
{
    self = [super initWithFrame:frame];
    if (self) {
        self.UpdateBlock = update;
        self.detailCustomer = customer;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCEditCustomerView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [self.editContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UITextField class]]) {
                UITextField * textFiedld = (UITextField *)obj;
                [textFiedld addBottomLine];
            }
        }];
        
        [self.upgradeMemberView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UITextField class]]) {
                UITextField * textFiedld = (UITextField *)obj;
                [textFiedld addBottomLine];
            }
        }];
        
        [self.birthDayTextField setRightButton:self Action:@selector(showDatePickerAction) OnView:self.editContentView];
        [self.customStyleTextField setRightButton:self Action:@selector(selectCustomTypeAction) OnView:self.editContentView];
        
        if (self.detailCustomer) {
            [self updateCustomerInfo];
        }else{
            [[IPCCustomerManager sharedManager] queryCustomerType];
            [self.customStyleTextField setText: @"自然进店"];
        }
        
        self.contentHeightConstraint.constant = 520;
    }
    return self;
}

- (void)updateCustomerInfo
{
    [self.customerNameTextField setText:self.detailCustomer.customerName];
    [self.phoneTextField setText:self.detailCustomer.customerPhone];
    [self.ageTextField setText:self.detailCustomer.age];
    [self.birthDayTextField setText:self.detailCustomer.birthday];
    [self.customStyleTextField setText:self.detailCustomer.customerType];
    
    if ([self.detailCustomer.gender isEqualToString:@"MALE"]) {
        [self.maleButton setSelected:YES];
        [self.femaleButton setSelected:NO];
    }else if ([self.detailCustomer.gender isEqualToString:@"FEMALE"]){
        [self.femaleButton setSelected:YES];
        [self.maleButton setSelected:NO];
    }
}

#pragma mark //Request Methods
- (void)saveCustomerRequest
{
    if (self.customerNameTextField.text.length)
    {
        NSString * gender = nil;
        
        if (self.maleButton.selected) {
            gender = @"MALE";
        }else{
            gender = @"FEMALE";
        }
        
        [IPCCustomerRequestManager saveCustomerInfoWithCustomName:self.customerNameTextField.text
                                                      CustomPhone:self.phoneTextField.text
                                                           Gender:gender
                                                         Birthday:self.birthDayTextField.text
                                                   CustomerTypeId:[[IPCCustomerManager sharedManager]  customerTypeId:self.customStyleTextField.text]
                                                          PhotoId:@([IPCHeadImage genderArcdom])
                                                              Age:self.ageTextField.text
                                                       CustomerId:(self.detailCustomer.customerID ?  : @"")
                                                     SuccessBlock:^(id responseValue)
         {
             if (self.UpdateBlock) {
                 self.UpdateBlock(responseValue[@"id"]);
             }
             [IPCCommonUI showSuccess:@"保存客户信息成功!"];
         } FailureBlock:^(NSError *error) {
             if ([error code] != NSURLErrorCancelled) {
                 [IPCCommonUI showError:@"保存客户信息失败!"];
             }
             if (self.UpdateBlock) {
                 self.UpdateBlock(nil);
             }
         }];
    }
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
}

- (IBAction)selectFemaleAction:(id)sender {
    [self.maleButton setSelected:NO];
    [self.femaleButton setSelected:YES];
}
- (IBAction)switchMemberAction:(UISwitch *)sender {
    if (sender.isOn) {
        self.contentHeightConstraint.constant = 720;
        [self.upgradeMemberView setHidden:NO];
    }else{
        self.contentHeightConstraint.constant = 520;
        [self.upgradeMemberView setHidden:YES];
    }
}

- (void)showDatePickerAction
{
    IPCDatePickViewController * datePickVC = [[IPCDatePickViewController alloc]initWithNibName:@"IPCDatePickViewController" bundle:nil];
    datePickVC.delegate = self;
    [datePickVC showWithPosition:CGPointMake(self.birthDayTextField.jk_width/2, self.birthDayTextField.jk_height) Size:CGSizeMake(self.birthDayTextField.jk_width-100, 150) Owner:self.birthDayTextField];
}

- (void)selectCustomTypeAction
{
    IPCParameterTableViewController * parameterTableVC = [[IPCParameterTableViewController alloc]initWithNibName:@"IPCParameterTableViewController" bundle:nil];
    [parameterTableVC setDataSource:self];
    [parameterTableVC setDelegate:self];
    [parameterTableVC showWithPosition:CGPointMake(self.customStyleTextField.jk_width/2, self.customStyleTextField.jk_height) Size:CGSizeMake(200, 150) Owner:self.customStyleTextField Direction:UIPopoverArrowDirectionUp];
}

#pragma mark //UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField isEqual:self.ageTextField]){
        NSString * birthday = [NSDate jk_stringWithDate:[[NSDate date] jk_dateBySubtractingYears:[textField.text integerValue]] format:@"yyyy-01-01"];
        [self.birthDayTextField setText:birthday];
    }
}

#pragma mark //IPCDatePickViewControllerDelegate
- (void)completeChooseDate:(NSString *)date
{
    NSString *  age = [NSString stringWithFormat:@"%d",[[NSDate jk_dateWithString:date format:@"yyyy-MM-dd"] jk_distanceYearsToDate:[NSDate date]]];
    
    [self.birthDayTextField setText:date];
    [self.ageTextField setText:age];
}

#pragma mark //IPCParameterTableViewDataSource
- (nonnull NSArray *)parameterDataInTableView:(IPCParameterTableViewController *)tableView
{
    return [IPCCustomerManager sharedManager].customerTypeNameArray;
}

#pragma mark //IPCParameterTableViewDelegate
- (void)didSelectParameter:(NSString *)parameter InTableView:(IPCParameterTableViewController *)tableView
{
    [self.customStyleTextField setText:parameter];
}

@end
