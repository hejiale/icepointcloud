//
//  PersonBaseView.m
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPersonBaseView.h"
#import "IPCPersonHeadCell.h"
#import "IPCPersonInputCell.h"
#import "IPCPersonTitleCell.h"
#import "IPCPersonQRCodeCell.h"
#import "IPCPersonMenuCell.h"

static NSString * const headIdentifier  = @"PersonHeadCellIdentifier";
static NSString * const inputIdentifier = @"PersonInputCellIdentifier";
static NSString * const titleIdentifier = @"PersonTitleCellIdentifier";
static NSString * const QRCodeIdentifier= @"PersonQRCodeCellIdentifier";
static NSString * const menuIdentifier  = @"PersonMenuCellIdentifier";

@interface IPCPersonBaseView()<IPCPersonInputCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *personTableView;
@property (weak, nonatomic) IBOutlet UIButton *logouOutButton;
@property (copy, nonatomic) void(^LogoutBlock)();
@property (copy, nonatomic) void(^UpdateBlock)();
@property (copy, nonatomic) void(^QRCodeBlock)();
@property (copy, nonatomic) void(^HelpBlock)();

@end

@implementation IPCPersonBaseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view  = [UIView jk_loadInstanceFromNibWithName:@"IPCPersonBaseView" owner:self];
        [self addSubview:view];
    }
    return self;
}

#pragma mark //Request Data
- (void)updateUserInfo:(NSString *)userName Mobile:(NSString *)mobile
{
    [IPCUserRequestManager updatePersonInfoWithUserName:userName ? : [IPCAppManager sharedManager].profile.user.contactName
                                                  Phone:mobile ? : [IPCAppManager sharedManager].profile.user.contactMobilePhone
                                           SuccessBlock:^(id responseValue){
                                               [[IPCAppManager sharedManager].profile.user setContactName:userName];
                                               [[IPCAppManager sharedManager].profile.user setContactMobilePhone:mobile];
                                               [self.personTableView reloadData];
                                           }FailureBlock:^(NSError *error) {
                                               [IPCCustomUI showError:error.userInfo[kIPCNetworkErrorMessage]];
                                           }];
}


- (void)logoutRequest
{
    [IPCUserRequestManager userLogoutWithSuccessBlock:^(id responseValue) {
        [IPCCustomUI hiden];
        if (self.LogoutBlock)
            self.LogoutBlock();
    } FailureBlock:^(NSError *error) {
        [IPCCustomUI showError:error.userInfo[kIPCNetworkErrorMessage]];
    }];
}

#pragma mark //Clicked Events
- (IBAction)logoutAction:(id)sender {
    [IPCCustomUI show];
    [self logoutRequest];
}

- (void)showWithLogout:(void(^)())logout UpdateBlock:(void (^)())update QRCodeBlock:(void (^)())qrcode HelpBlock:(void (^)())help
{
    self.LogoutBlock  = logout;
    self.UpdateBlock  = update;
    self.QRCodeBlock  = qrcode;
    self.HelpBlock    = help;
    
    [self.logouOutButton setBackgroundColor:COLOR_RGB_BLUE];
    [self.personTableView setTableFooterView:[[UIView alloc]init]];
    
    [UIView animateKeyframesWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.frame;
        frame.origin.x -= self.jk_width;
        self.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss:(void(^)())complete
{
    [UIView animateKeyframesWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.frame;
        frame.origin.x += self.jk_width;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            if (complete) {
                complete();
            }
        }
    }];
}

- (void)updateUserInfo:(NSIndexPath *)indexPath Cell:(IPCPersonInputCell *)cell{
    NSString * inputNameText  = [cell.inputTextField.text jk_trimmingWhitespace];
    NSString * inputPhoneText = [cell.inputTextField.text jk_trimmingWhitespace];
    
    if (indexPath.row == 0) {
        [self updateUserInfo:inputNameText ?  : [IPCAppManager sharedManager].profile.user.contactName
                      Mobile:[IPCAppManager sharedManager].profile.user.contactMobilePhone];
    }else{
        [self updateUserInfo:[IPCAppManager sharedManager].profile.user.contactName
                      Mobile:inputPhoneText ?  : [IPCAppManager sharedManager].profile.user.contactMobilePhone];
    }
}

#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return 1;
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        IPCPersonHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:headIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPersonHeadCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        [cell.headImageView setImageURL:[NSURL URLWithString:[IPCAppManager sharedManager].profile.headImageURL]];
        return cell;
    }else if(indexPath.section == 1){
        IPCPersonInputCell * cell = [tableView dequeueReusableCellWithIdentifier:inputIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPersonInputCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            cell.personDelegate = self;
        }
        if (indexPath.row == 0) {
            [cell.classNameLabel setText:@"姓名"];
            [cell.inputTextField setText:[IPCAppManager sharedManager].profile.user.contactName];
        }else{
            [cell.classNameLabel setText:@"手机"];
            [cell.inputTextField setText:[IPCAppManager sharedManager].profile.user.contactMobilePhone];
        }
        return cell;
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            IPCPersonTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPersonTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.companyNameLabel setText:[IPCAppManager sharedManager].profile.company];
            return cell;
        }else{
            IPCPersonQRCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:QRCodeIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPersonQRCodeCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            return cell;
        }
    }else if(indexPath.section == 3){
        IPCPersonMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:menuIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPersonMenuCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        if (indexPath.row == 0) {
            [cell.menuTitleLabel setText:@"我的冰点云"];
        }else{
            [cell.menuTitleLabel setText:@"修改密码"];
        }
        return cell;
    }else{
        IPCPersonMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:menuIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPersonMenuCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        if (indexPath.row == 0) {
            [cell.menuTitleLabel setText:@"帮助"];
        }else{
            [cell.menuTitleLabel setText:@"清除本地缓存"];
        }
        return cell;
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
        return 85;
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://icepointcloud.com/"]];
        }else{
            if (self.UpdateBlock)
                self.UpdateBlock();
        }
    }else if (indexPath.section == 2 && indexPath.row == 1){
        if (self.QRCodeBlock) {
            self.QRCodeBlock();
        }
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            if (self.HelpBlock) {
                self.HelpBlock();
            }
        }else{
            [[IPCNetworkCache sharedCache] removeAllHttpCache];
            YYImageCache *cache = [YYWebImageManager sharedManager].cache;
            [cache.memoryCache removeAllObjects];
            [cache.diskCache removeAllObjects];
            [IPCCustomUI showSuccess:@"缓存清理成功"];
        }
    }
}

#pragma mark //IPCPersonInputCellDelegate
- (void)textFieldEndEdit:(IPCPersonInputCell *)cell{
    NSIndexPath * indexPath = [self.personTableView indexPathForCell:cell];
    [self updateUserInfo:indexPath Cell:cell];
}

@end
