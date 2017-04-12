//
//  IPCOptometryView.m
//  IcePointCloud
//
//  Created by gerry on 2017/4/10.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCOptometryView.h"

@interface IPCOptometryView()<UITextFieldDelegate,IPCParameterTableViewDelegate,IPCParameterTableViewDataSource>
{
    NSInteger  functionTag;//用途
    NSInteger  optometristTag;//验光师
}

@property (nonatomic, strong) IPCEmployeList * employeList;
@property (nonatomic, strong) NSMutableArray<UITextField *> * allTextFields;
@property (nonatomic, strong) NSMutableArray * employeeNameArray;

@end

@implementation IPCOptometryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self queryEmploye];
        [self createOptometryView:frame];
        self.insertOptometry = [[IPCOptometryMode alloc]init];
    }
    return self;
}

#pragma mark //Set UI
- (void)createOptometryView:(CGRect)frame{
    NSArray *lensItems = @[@"球镜/SPH", @"柱镜/CYL", @"轴位/AXIS", @"矫正视力/VA",@"单眼瞳距/PD", @"下加光/ADD",@"验光师"];
    
    CGFloat  spaceWidth   = 10;
    CGFloat  spaceHeight  = 15;
    CGFloat  itemWidth = (frame.size.width - 42 - 30 - spaceWidth*6)/6;
    
    for (int i = 0; i < 4; i++) {
        UIView *lensView = [[UIView alloc] initWithFrame:CGRectMake(0, (25 + spaceHeight) * i, self.jk_width, 25)];
        [self addSubview:lensView];
        
        UIImageView *imgView = nil;
        if ( i < 3) {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (lensView.jk_height - 24) / 2, 42, 24)];
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
                [lensView addSubview:[self createLensView:CGRectMake(42 + 30 + (itemWidth + spaceWidth) * j, 0, itemWidth, lensView.jk_height) Label:lensItems[j]  Tag:j + 1 + (i-1)*6 InputText: @""]];
            }
        }else if(i == 3){
            optometristTag = 13;
            [lensView addSubview:[self createLensView:CGRectMake(42 + 30, 0, itemWidth, lensView.jk_height) Label:[lensItems lastObject] Tag:optometristTag InputText:@""]];
        }else if (i == 0){
            functionTag = 0;
            [lensView addSubview:[self createFunctionView:CGRectMake(42 + 30, 0, itemWidth, lensView.jk_height)]];
        }
        [IPCCustomUI clearAutoCorrection:lensView];
    }
}

- (UIView *)createLensView:(CGRect)rect Label:(NSString *)label Tag:(NSInteger)tag InputText:(NSString *)text
{
    UIView *itemView = [[UIView alloc] initWithFrame:rect];
    [itemView addBorder:3 Width:0.7];
    
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    lbl.textColor = [UIColor lightGrayColor];
    lbl.text = label;
    lbl.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    lbl.backgroundColor = [UIColor clearColor];
    CGFloat width = [lbl.text jk_sizeWithFont:lbl.font constrainedToHeight:itemView.jk_height].width;
    [lbl setFrame:CGRectMake(0, 0, width, itemView.jk_height)];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, itemView.jk_width-5, itemView.jk_height)];
    tf.textColor = [UIColor lightGrayColor];
    tf.delegate  = self;
    tf.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    tf.tag = tag;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.returnKeyType = UIReturnKeyDone;
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.text = text;
    [tf setLeftView:lbl];
    [tf setLeftViewMode:UITextFieldViewModeAlways];
    if (tag == optometristTag)[tf setRightButton:self Action:@selector(onSelectEmployeeAction) OnView:itemView];
    [itemView addSubview:tf];
    [self.allTextFields addObject:tf];
    
    return itemView;
}

- (UIView *)createFunctionView:(CGRect)rect
{
    UIView *itemView = [[UIView alloc] initWithFrame:rect];
    [itemView addBorder:3 Width:0.7];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, itemView.jk_width-10, itemView.jk_height)];
    tf.textColor = [UIColor lightGrayColor];
    tf.delegate  = self;
    tf.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    tf.tag = functionTag;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.returnKeyType = UIReturnKeyDone;
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
    [parameterTableVC showWithPosition:CGPointMake(sender.jk_right, [[sender superview]superview].jk_bottom + self.jk_top) Size:CGSizeMake(sender.jk_width, height) Owner:self Direction:UIPopoverArrowDirectionDown];
}

#pragma mark //Request Method
- (void)queryEmploye{
    [IPCPayOrderRequestManager queryEmployeWithKeyword:@"" SuccessBlock:^(id responseValue)
     {
         _employeList = [[IPCEmployeList alloc] initWithResponseObject:responseValue];
         [_employeList.employeArray enumerateObjectsUsingBlock:^(IPCEmploye * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [self.employeeNameArray addObject:obj.name];
         }];
     } FailureBlock:^(NSError *error) {
         [IPCCustomUI showError:error.domain];
     }];
}


#pragma mark //Init Data
- (NSMutableArray<UITextField *> *)allTextFields{
    if (!_allTextFields)
        _allTextFields = [[NSMutableArray alloc]init];
    return _allTextFields;
}


- (NSMutableArray *)employeeNameArray{
    if (!_employeeNameArray) {
        _employeeNameArray = [[NSMutableArray alloc]init];
    }
    return _employeeNameArray;
}

- (UITextField *)subTextField:(NSInteger)tag{
    return (UITextField *)self.allTextFields[tag];
}

#pragma mark //Clicked Events
- (void)onSelectEmployeeAction{
    [self showParameterTableView:[self subTextField:optometristTag] Height:280 Tag:optometristTag];
}

- (void)onSelectFunctionAction{
    [self showParameterTableView:[self subTextField:functionTag] Height:150 Tag:functionTag];
}

- (void)insertOptometryInfo{
    self.insertOptometry.purpose = [self subTextField:0].text;
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
 
    [self.employeList.employeArray enumerateObjectsUsingBlock:^(IPCEmploye * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:self.insertOptometry.employeeName]) {
            self.insertOptometry.employeeId = obj.jobID;
        }
    }];
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
    
    if (str.length > 0) {
        if (textField.tag > 0 && textField.tag != optometristTag) {
            if (textField.tag == 3 || textField.tag == 9)
            {
                if ([str doubleValue] >= 0 && [str doubleValue] <= 180) {
                    [textField setText:[NSString stringWithFormat:@"%.f",[str doubleValue]]];
                }else{
                    [textField setText:@""];
                }
            }else if (textField.tag != 5 && textField.tag != 11){
                if (![str hasPrefix:@"-"]) {
                    [textField setText:[NSString stringWithFormat:@"+%.2f",[str doubleValue]]];
                }else{
                    [textField setText:[NSString stringWithFormat:@"%.2f",[str doubleValue]]];
                }
            }
        }else{
            [textField setText:[NSString stringWithFormat:@"%.f mm",[str doubleValue]]];
        }
    }
    [self insertOptometryInfo];
}

#pragma mark //IPCParameterTableViewDataSource
- (nonnull NSArray *)parameterDataInTableView:(IPCParameterTableViewController *)tableView{
    if (tableView.view.tag == optometristTag)
        return self.employeeNameArray;
    return @[@"远用",@"近用"];
}


#pragma mark /IPCParameterTableViewDelegate
- (void)didSelectParameter:(NSString *)parameter InTableView:(IPCParameterTableViewController *)tableView{
    [[self subTextField:tableView.view.tag] setText:parameter];
    [self insertOptometryInfo];
}


@end
