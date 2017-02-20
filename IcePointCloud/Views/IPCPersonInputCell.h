//
//  PersonInputCell.h
//  IcePointCloud
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCPersonInputCellDelegate;
@interface IPCPersonInputCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (assign, nonatomic) id<IPCPersonInputCellDelegate>personDelegate;

@end

@protocol IPCPersonInputCellDelegate <NSObject>

- (void)textFieldEndEdit:(IPCPersonInputCell *)cell;

@end

