//
//  IPCOrderDetailPayRecordCell.h
//  IcePointCloud
//
//  Created by gerry on 2017/6/6.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPCCustomDetailOrderPayRecordView.h"

@interface IPCOrderDetailPayRecordCell : UITableViewCell

@property (nonatomic, copy, readwrite) NSArray<IPCPayRecord *> * recordList;

@end
