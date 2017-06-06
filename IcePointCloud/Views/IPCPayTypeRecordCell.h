//
//  IPCPayTypeRecordCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/6/5.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCSwipeView.h"
#import "IPCPayTypeRecordView.h"
#import "IPCPayOrderSubViewDelegate.h"

@interface IPCPayTypeRecordCell : UITableViewCell<UITextFieldDelegate,IPCParameterTableViewDelegate,IPCParameterTableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *payRecordContentView;
@property (weak, nonatomic) IBOutlet UIView *insertRecordView;
@property (weak, nonatomic) IBOutlet UITextField *payTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *payAmountTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payRecordHeight;

@property (strong, nonatomic) NSMutableArray<IPCSwipeView *> * recordViews;
@property (nonatomic, assign) id<IPCPayOrderSubViewDelegate>delegate;

@end

