//
//  IPCPayOrderEditPayCashRecordCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/11/24.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPCPayOrderEditPayCashRecordCellDelegate;

@interface IPCPayOrderEditPayCashRecordCell : UITableViewCell<IPCCustomTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UIView *payAmountView;

@property (strong, nonatomic)  IPCCustomTextField * payAmountTextField;
@property (nonatomic, copy) IPCPayRecord * payRecord;
@property (nonatomic, assign) id<IPCPayOrderEditPayCashRecordCellDelegate>delegate;

@end

@protocol IPCPayOrderEditPayCashRecordCellDelegate <NSObject>

- (void)reloadRecord:(IPCPayOrderEditPayCashRecordCell *)cell;

@end

