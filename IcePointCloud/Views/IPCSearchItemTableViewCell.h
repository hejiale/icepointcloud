//
//  SearchItemCell.h
//  IcePointCloud
//
//  Created by mac on 8/14/15.
//  Copyright (c) 2015 Doray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPCSearchItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *seachTitleLabel;
@property (copy, nonatomic) void(^CompleteBlock)();

- (void)inputText:(NSString *)text Complete:(void(^)())complete;

@end
