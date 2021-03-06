//
//  IPCUpdateCustomerView.m
//  IcePointCloud
//
//  Created by gerry on 2018/1/5.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCUpdateCustomerView.h"

@interface IPCUpdateCustomerView()

@property (weak, nonatomic) IBOutlet UITextField *customerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiel;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UITextField *customerTypeTextField;
@property (weak, nonatomic) IBOutlet UIView *editContentView;
@property (weak, nonatomic) IBOutlet UITextField *storeTextField;
@property (strong, nonatomic) IPCCustomerMode * customer;
@property (copy, nonatomic) void(^UpdateBlock)(IPCCustomerMode * customer);

@end

@implementation IPCUpdateCustomerView

- (instancetype)initWithFrame:(CGRect)frame DetailCustomer:(IPCCustomerMode*)customer UpdateBlock:(void (^)(IPCCustomerMode * customer))update
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.UpdateBlock = update;
        self.customer = customer;
        
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCUpdateCustomerView" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [self.editContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UITextField class]]) {
                UITextField * textFiedld = (UITextField *)obj;
                [textFiedld addBottomLine];
            }
        }];
        
        [self.birthdayTextField setRightButton:self Action:@selector(showDatePickerAction) OnView:self.editContentView];
        [self.customerTypeTextField setRightButton:self Action:@selector(selectCustomTypeAction) OnView:self.editContentView];
        [self.storeTextField setRightButton:self Action:@selector(selectStoreAction) OnView:self.editContentView];
        
        //更新客户显示信息
        [self updateCustomerInfo];
    }
    return self;
}

- (void)updateCustomerInfo
{
    [self.customerNameTextField setText:self.customer.customerName];
    [self.phoneTextFiel setText:self.customer.customerPhone];
    [self.ageTextField setText:self.customer.age];
    [self.birthdayTextField setText:self.customer.birthday];
    [self.customerTypeTextField setText:self.customer.customerType];

    if (self.customer.createStoreName.length) {
        [self.storeTextField setText:self.customer.createStoreName];
    }else{
        [self.storeTextField setText:@"无门店"];
    }
    
    if ([self.customer.gender isEqualToString:@"MALE"]) {
        [self.maleButton setSelected:YES];
        [self.femaleButton setSelected:NO];
    }else if ([self.customer.gender isEqualToString:@"FEMALE"]){
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
                                                      CustomPhone:self.phoneTextFiel.text
                                                           Gender:gender
                                                         Birthday:self.birthdayTextField.text
                                                   CustomerTypeId:[[IPCCustomerManager sharedManager]  customerTypeId:self.customerTypeTextField.text]
                                                          PhotoId:@([IPCHeadImage genderArcdom])
                                                              Age:self.ageTextField.text
                                                       CustomerId:self.customer.customerID
                                                          StoreId:[[IPCCustomerManager sharedManager] storeId:self.storeTextField.text]
                                                     SuccessBlock:^(id responseValue)
         {
             IPCCustomerMode * customer = [IPCCustomerMode mj_objectWithKeyValues:responseValue];
             
             if (self.UpdateBlock) {
                 self.UpdateBlock(customer);
             }
             [self removeFromSuperview];
             [IPCCommonUI showSuccess:@"保存客户信息成功!"];
         } FailureBlock:^(NSError *error) {
             if ([error code] != NSURLErrorCancelled) {
                 [IPCCommonUI showError:error.domain];
             }
             [self removeFromSuperview];
             
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


- (void)showDatePickerAction
{
    IPCDatePickViewController * datePickVC = [[IPCDatePickViewController alloc]initWithNibName:@"IPCDatePickViewController" bundle:nil];
    datePickVC.delegate = self;
    [datePickVC showWithPosition:CGPointMake(self.birthdayTextField.jk_width/2, self.birthdayTextField.jk_height) Size:CGSizeMake(self.birthdayTextField.jk_width-100, 150) Owner:self.birthdayTextField];
}

- (void)selectCustomTypeAction
{
    IPCParameterTableViewController * parameterTableVC = [[IPCParameterTableViewController alloc]initWithNibName:@"IPCParameterTableViewController" bundle:nil];
    [parameterTableVC setDataSource:self];
    [parameterTableVC setDelegate:self];
    [parameterTableVC showWithPosition:CGPointMake(self.customerTypeTextField.jk_width/2, self.customerTypeTextField.jk_height) Size:CGSizeMake(200, 150) Owner:self.customerTypeTextField Direction:UIPopoverArrowDirectionUp];
}

- (void)selectStoreAction
{
    IPCParameterTableViewController * parameterTableVC = [[IPCParameterTableViewController alloc]initWithNibName:@"IPCParameterTableViewController" bundle:nil];
    [parameterTableVC setDataSource:self];
    [parameterTableVC setDelegate:self];
    [parameterTableVC.view setTag:100];
    [parameterTableVC showWithPosition:CGPointMake(self.storeTextField.jk_width/2, self.storeTextField.jk_height) Size:CGSizeMake(200, 150) Owner:self.storeTextField Direction:UIPopoverArrowDirectionUp];
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
        [self.birthdayTextField setText:birthday];
    }
}

#pragma mark //IPCDatePickViewControllerDelegate
- (void)completeChooseDate:(NSString *)date
{
    NSString *  age = [NSString stringWithFormat:@"%d",[[NSDate jk_dateWithString:date format:@"yyyy-MM-dd"] jk_distanceYearsToDate:[NSDate date]]];
    
    [self.birthdayTextField setText:date];
    [self.ageTextField setText:age];
}

#pragma mark //IPCParameterTableViewDataSource
- (nonnull NSArray *)parameterDataInTableView:(IPCParameterTableViewController *)tableView
{
    if (tableView.view.tag == 100) {
        return [[IPCCustomerManager sharedManager] storeNameArray];
    }
    return [IPCCustomerManager sharedManager].customerTypeNameArray;
}

#pragma mark //IPCParameterTableViewDelegate
- (void)didSelectParameter:(NSString *)parameter InTableView:(IPCParameterTableViewController *)tableView
{
    if (tableView.view.tag == 100) {
        [self.storeTextField setText:parameter];
    }else{
        [self.customerTypeTextField setText:parameter];
    }
}


@end
