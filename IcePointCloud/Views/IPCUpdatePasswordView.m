//
//  UpdatePwView.m
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCUpdatePasswordView.h"
#import "IPCPersonInputCell.h"

static NSString * const inputIdentifier = @"PersonInputCellIdentifier";

@interface IPCUpdatePasswordView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *updateTableView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (copy, nonatomic) void(^CloseBlock)(void);

@end

@implementation IPCUpdatePasswordView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCUpdatePasswordView" owner:self];
        [self addSubview:view];
        
        [self.updateTableView setTableHeaderView:[[UIView alloc]init]];
        [self.updateTableView setTableFooterView:[[UIView alloc]init]];
        self.updateTableView.estimatedSectionHeaderHeight = 0;
        self.updateTableView.estimatedSectionFooterHeight = 0;
    }
    return self;
}

- (void)showWithClose:(void (^)())closeBlock
{
    self.CloseBlock = closeBlock;

    [self.updateTableView setTableFooterView:[[UIView alloc]init]];

    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.frame;
        frame.origin.x -= self.jk_width;
        self.frame = frame;
    } completion:nil];
}

- (IBAction)backAction:(id)sender {
    [UIView animateWithDuration:0.5f animations:^{
        CGRect frame = self.frame;
        frame.origin.x += self.jk_width;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.CloseBlock) {
                self.CloseBlock();
            }
        }
    }];
    
}

- (IBAction)saveAction:(id)sender {
    [self updateNewPassword];
}

#pragma mark //Request Data
- (void)updateNewPassword{
    __block NSString *oldPwd = [[self inputText:0].text jk_trimmingWhitespace];
    __block NSString *pwd     = [[self inputText:1].text jk_trimmingWhitespace];
    __block NSString *cofirmpwd   = [[self inputText:2].text jk_trimmingWhitespace];
    
    if (oldPwd.length && pwd.length && cofirmpwd.length) {
        if ([pwd isEqualToString:cofirmpwd]) {
            [IPCCommonUI show];
            [IPCUserRequestManager updatePasswordWithOldPassword:oldPwd
                                                  UpdatePassword:cofirmpwd
                                                    SuccessBlock:^(id responseValue)
             {
                 [IPCCommonUI hiden];
                 self.CloseBlock();
             } FailureBlock:^(NSError *error) {
                 [IPCCommonUI showError:@"修改用户密码失败!"];
             }];
        }else{
            [IPCCommonUI showError:@"两次输入新密码不一致!"];
        }
    }
}

#pragma mark //UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IPCPersonInputCell * cell = [tableView dequeueReusableCellWithIdentifier:inputIdentifier];
    if (!cell) {
        cell = [[UINib nibWithNibName:@"IPCPersonInputCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        [cell.inputTextField setSecureTextEntry:YES];
        [cell.inputTextField setTextAlignment:NSTextAlignmentCenter];
    }
    if (indexPath.row == 0) {
        [cell.classNameLabel setText:@"原密码"];
    }else if (indexPath.row == 1){
        [cell.classNameLabel setText:@"新密码"];
    }else{
        [cell.classNameLabel setText:@"确认新密码"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.jk_width, 5)];
    [headView setBackgroundColor:[UIColor clearColor]];
    return headView;
}

- (UITextField *)inputText:(NSInteger)row{
    IPCPersonInputCell * cell = (IPCPersonInputCell *)[self.updateTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    return cell.inputTextField;
}


@end
