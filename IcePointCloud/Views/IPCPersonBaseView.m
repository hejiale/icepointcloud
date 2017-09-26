//
//  PersonBaseView.m
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCPersonBaseView.h"
#import "IPCPersonHeadCell.h"
#import "IPCPersonTitleCell.h"
#import "IPCPersonQRCodeCell.h"
#import "IPCPersonMenuCell.h"

static NSString * const headIdentifier  = @"PersonHeadCellIdentifier";
static NSString * const titleIdentifier = @"PersonTitleCellIdentifier";
static NSString * const QRCodeIdentifier= @"PersonQRCodeCellIdentifier";
static NSString * const menuIdentifier  = @"PersonMenuCellIdentifier";

@interface IPCPersonBaseView()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *personTableView;
@property (weak, nonatomic) IBOutlet UIButton *logouOutButton;
@property (copy, nonatomic) void(^LogoutBlock)();
@property (copy, nonatomic) void(^UpdateBlock)();
@property (copy, nonatomic) void(^QRCodeBlock)();
@property (copy, nonatomic) void(^WareHouseBlock)();

@end

@implementation IPCPersonBaseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view  = [UIView jk_loadInstanceFromNibWithName:@"IPCPersonBaseView" owner:self];
        [self addSubview:view];
        
        [self.personTableView setTableHeaderView:[[UIView alloc]init]];
        [self.personTableView setTableFooterView:[[UIView alloc]init]];
        self.personTableView.estimatedSectionHeaderHeight = 0;
        self.personTableView.estimatedSectionFooterHeight = 0;
    }
    return self;
}

#pragma mark //Request Data
- (void)logoutRequest
{
    [IPCUserRequestManager userLogoutWithSuccessBlock:^(id responseValue) {
        [IPCCommonUI hiden];
        if (self.LogoutBlock)
            self.LogoutBlock();
    } FailureBlock:^(NSError *error) {
        [IPCCommonUI showError:@"用户退出登录失败"];
    }];
}

#pragma mark //Clicked Events
- (IBAction)logoutAction:(id)sender {
    [IPCCommonUI show];
    [self logoutRequest];
}

- (void)showWithLogout:(void(^)())logout UpdateBlock:(void (^)())update QRCodeBlock:(void (^)())qrcode WareHouseBlock:(void (^)())wareHouse
{
    self.LogoutBlock  = logout;
    self.UpdateBlock  = update;
    self.QRCodeBlock  = qrcode;
    self.WareHouseBlock = wareHouse;
    
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

- (void)reload
{
    [self.personTableView reloadData];
}


#pragma mark //UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 3)
        return 1;
    else if (section == 1) {
        return 3;
    }
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        IPCPersonHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:headIdentifier];
        if (!cell) {
            cell = [[UINib nibWithNibName:@"IPCPersonHeadCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
        }
        return cell;
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            IPCPersonTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPersonTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.companyTitleLabel setText:@"所属店铺"];
            [cell.companyNameLabel setText:[IPCAppManager sharedManager].profile.storeName];
            return cell;
        }
//        else if (indexPath.row == 1) {
//            IPCPersonMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:menuIdentifier];
//            if (!cell) {
//                cell = [[UINib nibWithNibName:@"IPCPersonMenuCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
//            }
//            [cell.menuTitleLabel setText:@"仓库"];
//            [cell.menuValueTitle setText:[IPCAppManager sharedManager].currentWareHouse.wareHouseName];
//            
//            return cell;
//        }
        else if (indexPath.row == 1) {
            IPCPersonTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPersonTitleCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            [cell.companyTitleLabel setText:@"公司"];
            [cell.companyNameLabel setText:[IPCAppManager sharedManager].profile.company];
            return cell;
        }else{
            IPCPersonQRCodeCell * cell = [tableView dequeueReusableCellWithIdentifier:QRCodeIdentifier];
            if (!cell) {
                cell = [[UINib nibWithNibName:@"IPCPersonQRCodeCell" bundle:nil]instantiateWithOwner:nil options:nil][0];
            }
            return cell;
        }
    }else if(indexPath.section == 2){
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
        [cell.menuTitleLabel setText:@"清除本地缓存"];
        return cell;
    }
}

#pragma mark //UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
        return 140;
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
    if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://icepointcloud.com/"]];
        }else{
            if (self.UpdateBlock)
                self.UpdateBlock();
        }
    }else if (indexPath.section == 1){
//        if (indexPath.row == 1) {
//            if (self.WareHouseBlock) {
//                self.WareHouseBlock();
//            }
//        }else
            if (indexPath.row == 2) {
            if (self.QRCodeBlock) {
                self.QRCodeBlock();
            }
        }
    }else if (indexPath.section == 3){
        [[IPCNetworkCache sharedCache] removeAllHttpCache];
        YYImageCache *cache = [YYWebImageManager sharedManager].cache;
        [cache.memoryCache removeAllObjects];
        [cache.diskCache removeAllObjects];
        [IPCCommonUI showSuccess:@"缓存清理成功"];
    }
}

@end
