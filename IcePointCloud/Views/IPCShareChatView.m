//
//  ShareChatView.m
//  IcePointCloud
//
//  Created by mac on 16/9/19.
//  Copyright © 2016年 Doray. All rights reserved.
//

#import "IPCShareChatView.h"
#import "IPCImageTextButton.h"

@interface IPCShareChatView()

@property (strong, nonatomic) IBOutlet UIView *shareButtonView;
@property (weak, nonatomic) IBOutlet IPCImageTextButton *wechatButton;
@property (weak, nonatomic) IBOutlet IPCImageTextButton *chatLineButton;
@property (weak, nonatomic) IBOutlet IPCImageTextButton *chatMarkButton;

@property (nonatomic, copy) void(^ChatBlock)(void);
@property (nonatomic, copy) void(^LineBlock)(void);
@property (nonatomic, copy) void(^FavoriteBlock)(void);

@end

@implementation IPCShareChatView

- (instancetype)initWithFrame:(CGRect)frame Chat:(void(^)())chat Line:(void(^)())line Favorite:(void(^)())favorite
{
    self = [super initWithFrame:frame];
    if (self) {
        self.ChatBlock = chat;
        self.LineBlock  = line;
        self.FavoriteBlock = favorite;
        
        UIView * shareView = [UIView jk_loadInstanceFromNibWithName:@"IPCShareChatView" owner:self];
        [shareView setFrame:CGRectMake(0, -frame.size.height, frame.size.width, frame.size.height)];
        shareView.alpha = 0;
        [self addSubview:shareView];
        _shareButtonView = shareView;
        
        [self.wechatButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentDown];
        [self.chatLineButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentDown];
        [self.chatMarkButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentDown];
    }
    return self;
}


- (void)show{
    [UIView animateWithDuration:0.4f animations:^{
        CGRect frame = self.shareButtonView.frame;
        frame.origin.y += self.jk_height;
        self.shareButtonView.frame = frame;
        
        self.shareButtonView.alpha = 1;
    } completion:nil];
}


- (IBAction)chatAction:(id)sender {
    if (self.ChatBlock) {
        self.ChatBlock();
    }
}

- (IBAction)lineAction:(id)sender {
    if (self.LineBlock) {
        self.LineBlock();
    }
}

- (IBAction)favoriteAction:(id)sender {
    if (self.FavoriteBlock) {
        self.FavoriteBlock();
    }
}


@end
