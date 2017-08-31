//
//  IPCOptometryView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/10.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCOptometryView.h"

typedef void(^UpdateBlock)(void);

@interface IPCOptometryView()<UITextFieldDelegate,IPCParameterTableViewDelegate,IPCParameterTableViewDataSource>
{
    NSInteger  functionTag;//用途
    NSInteger  optometristTag;//验光师
}

@property (nonatomic, strong) NSMutableArray<UITextField *> * allTextFields;
@property (nonatomic, copy) UpdateBlock updateBlock;

@end

@implementation IPCOptometryView

- (instancetype)initWithFrame:(CGRect)frame Update:(void(^)())update
{
    self = [super initWithFrame:frame];
    if (self) {
        self.updateBlock = update;
        
        [self createOptometryView:frame];
        self.insertOptometry = [[IPCOptometryMode alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark //Set UI
- (void)createOptometryView:(CGRect)frame{
    NSArray *lensItems = @[@"球镜/SPH", @"柱镜/CYL", @"轴位/AXIS", @"矫正视力/VA",@"瞳距/PD", @"下加光/ADD",@"验光师"];
    
    CGFloat  spaceWidth   = 10;
    CGFloat  spaceHeight  = 15;
    CGFloat  itemWidth = (frame.size.width - 34 - 30 - spaceWidth*6)/6;
    
    for (int i = 0; i < 4; i++) {
        UIView *lensView = [[UIView alloc] initWithFrame:CGRectMake(0, (25 + spaceHeight) * i, self.jk_width, 25)];
        [self addSubview:lensView];
        
        UIImageView *imgView = nil;
        if ( i < 3) {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (lensView.jk_height - 20) / 2, 34, 20)];
            if (i == 0) {
                [imgView setImage:[UIImage imageNamed:@"icon_optometry_function"]];
            }else if (i == 1){
                [imgView setImage:[UIImage imageNamed:@"icon_right_optometry"]];
            }else{
                [imgView setImage:[UIImage imageNamed:@"icon_left_optometry"]];
            }
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            [lensView addSubview:imgView];
        }
        
        if ( i >0 && i < 3) {
            for (int j = 0; j < lensItems.count-1; j++) {
                [lensView addSubview:[self createLensView:CGRectMake(34 + 30 + (itemWidth + spaceWidth) * j, 0, itemWidth, lensView.jk_height) Label:lensItems[j]  Tag:j + 1 + (i-1)*6 InputText: @""]];
            }
        }else if(i == 3){
            optometristTag = 13;
            [lensView addSubview:[self createLensView:CGRectMake(34 + 30, 0, itemWidth, lensView.jk_height) Label:[lensItems lastObject] Tag:optometristTag InputText:@""]];
        }else if (i == 0){
            functionTag = 0;
            [lensView addSubview:[self createFunctionView:CGRectMake(34 + 30, 0, itemWidth, lensView.jk_height)]];
        }
        [IPCCommonUI clearAutoCorrection:lensView];
    }
}

- (UIView *)createLensView:(CGRect)rect Label:(NSString *)label Tag:(NSInteger)tag InputText:(NSString *)text
{
    UIView *itemView = [[UIView alloc] initWithFrame:rect];
    [itemView addBorder:3 Width:0.5 Color:nil];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, itemView.jk_width-5, itemView.jk_height)];
    tf.textColor = [UIColor darkGrayColor];
    tf.delegate  = self;
    tf.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    tf.tag = tag;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.returnKeyType = UIReturnKeyNext;
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.text = text;
    tf.clearsOnBeginEditing = YES;
    [tf setLeftText:label];
    if (tag == optometristTag)[tf setRightButton:self Action:@selector(onSelectEmployeeAction) OnView:itemView];
    [itemView addSubview:tf];
    [self.allTextFields addObject:tf];
    
    return itemView;
}

- (UIView *)createFunctionView:(CGRect)rect
{
    UIView *itemView = [[UIView alloc] initWithFrame:rect];
    [itemView addBorder:3 Width:0.5 Color:nil];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, itemView.jk_width-10, itemView.jk_height)];
    tf.textColor = [UIColor darkGrayColor];
    tf.delegate  = self;
    tf.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    tf.tag = functionTag;
    [tf setRightButton:self Action:@selector(onSelectFunctionAction) OnView:itemView];
    [itemView addSubview:tf];
    [self.allTextFields addObject:tf];
    
    return itemView;
}

- (void)showParameterTableView:(UITextField *)sender Height:(CGFloat)height Tag:(NSInteger)tag
{
    IPCParameterTableViewController * parameterTableVC = [[IPCParameterTableViewController alloc]initWithNibName:@"IPCParameterTableViewController" bundle:nil];
    parameterTableVC.view.tag = tag;
    [parameterTableVC setDataSource:self];
    [parameterTableVC setDelegate:self];
    [parameterTableVC showWithPosition:CGPointMake(sender.jk_right, [[sender superview]superview].jk_top + self.jk_top) Size:CGSizeMake(sender.jk_width, height) Owner:self Direction:UIPopoverArrowDirectionDown];
}

#pragma mark //Init Data
- (NSMutableArray<UITextField *> *)allTextFields{
    if (!_allTextFields)
        _allTextFields = [[NSMutableArray alloc]init];
    return _allTextFields;
}

- (UITextField *)subTextField:(NSInteger)tag{
    return (UITextField *)self.allTextFields[tag];
}

#pragma mark //Clicked Events
- (void)onSelectEmployeeAction{
    [self endEditing:YES];
    [self showParameterTableView:[self subTextField:optometristTag] Height:280 Tag:optometristTag];
}

- (void)onSelectFunctionAction{
    [self endEditing:YES];
    [self showParameterTableView:[self subTextField:functionTag] Height:150 Tag:functionTag];
}


- (void)insertOptometryInfo{
    self.insertOptometry.purpose = [IPCCommon purpose:[self subTextField:0].text];
    
    if ([self subTextField:1].text.length) {
        self.insertOptometry.sphRight = [self subTextField:1].text;
    }
    if ([self subTextField:2].text.length) {
        self.insertOptometry.cylRight = [self subTextField:2].text;
    }
    self.insertOptometry.axisRight = [self subTextField:3].text;
    self.insertOptometry.correctedVisionRight = [self subTextField:4].text;
    self.insertOptometry.distanceRight = [self subTextField:5].text;
    self.insertOptometry.addRight = [self subTextField:6].text;
    if ([self  subTextField:7].text.length) {
        self.insertOptometry.sphLeft = [self subTextField:7].text;
    }
    if ([self subTextField:8].text.length) {
        self.insertOptometry.cylLeft = [self subTextField:8].text;
    }
    self.insertOptometry.axisLeft = [self subTextField:9].text;
    self.insertOptometry.correctedVisionLeft = [self subTextField:10].text;
    self.insertOptometry.distanceLeft = [self subTextField:11].text;
    self.insertOptometry.addLeft = [self subTextField:12].text;
    self.insertOptometry.employeeName = [self subTextField:13].text;
    self.insertOptometry.employeeId = [[IPCEmployeeeManager sharedManager] employeeId:self.insertOptometry.employeeName];
    
    if (self.updateBlock) {
        self.updateBlock();
    }
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
        UITextField * nextTextField = (UITextField *)self.allTextFields[textField.tag + 1];
        [nextTextField becomeFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * str = [textField.text jk_trimmingWhitespace];
    
    if (str.length > 0) {
        if (textField.tag != 4 && textField.tag != 10) {
            if (textField.tag > 0 && textField.tag != optometristTag) {
                if (textField.tag == 3 || textField.tag == 9)
                {
                    if ([str doubleValue] >= 0 && [str doubleValue] <= 180) {
                        [textField setText:[NSString stringWithFormat:@"%.f",[str doubleValue]]];
                    }else{
                        [textField setText:@""];
                    }
                }else if (textField.tag == 5 || textField.tag == 11){
                    [textField setText:[NSString stringWithFormat:@"%.2f mm",[str doubleValue]]];
                }else{
                    if (![str hasPrefix:@"-"]) {
                        [textField setText:[NSString stringWithFormat:@"+%.2f",[str doubleValue]]];
                    }else{
                        [textField setText:[NSString stringWithFormat:@"%.2f",[str doubleValue]]];
                    }
                }
            }
        }
    }else{
        if (textField.tag == 1 || textField.tag == 2 || textField.tag == 7 || textField.tag == 8) {
            [textField setText:@"+0.00"];
        }
    }
}

#pragma mark //IPCParameterTableViewDataSource
- (nonnull NSArray *)parameterDataInTableView:(IPCParameterTableViewController *)tableView{
    if (tableView.view.tag == optometristTag)
        return [[IPCEmployeeeManager sharedManager] employeeNameArray];
    return @[@"远用",@"近用"];
}


#pragma mark /IPCParameterTableViewDelegate
- (void)didSelectParameter:(NSString *)parameter InTableView:(IPCParameterTableViewController *)tableView{
    [[self subTextField:tableView.view.tag] setText:parameter];
    [self insertOptometryInfo];
}


#pragma mark //UIKeyboard Hiden Notification
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self insertOptometryInfo];
}


@end
