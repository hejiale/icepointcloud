//
//  UserBaseInfoCell.h
//  IcePointCloud
//
//  Created by mac on 16/7/21.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserBaseInfoCellDelegate;

@interface IPCInsertCustomerBaseCell : UITableViewCell<IPCDatePickViewControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *customerImageView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *memberNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *handlersTextField;//经手人
@property (weak, nonatomic) IBOutlet UITextField *memberLevelTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
//展开页面
@property (weak, nonatomic) IBOutlet UIView *packUpView;
@property (weak, nonatomic) IBOutlet UITextField *customerCategoryTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *jobTextField;
@property (weak, nonatomic) IBOutlet UITextField *memoTextField;
@property (weak, nonatomic) IBOutlet UIButton *packUpButton;
@property (weak, nonatomic) IBOutlet UIButton *packDownButton;
@property (weak, nonatomic) IBOutlet UIView *introducerView;
@property (weak, nonatomic) IBOutlet UITextField *introducerTextField;
@property (weak, nonatomic) IBOutlet UITextField *introducerInteger;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceTop;


@property (weak, nonatomic) id<UserBaseInfoCellDelegate>delegate;

- (void)updatePackUpUI:(BOOL)isPackUp;

@end

@protocol UserBaseInfoCellDelegate <NSObject>

- (void)updatePackUpStatus:(BOOL)isPackUp;
- (void)reloadInsertCustomUI;
- (void)judgePhone:(NSString *)phone;

@end
