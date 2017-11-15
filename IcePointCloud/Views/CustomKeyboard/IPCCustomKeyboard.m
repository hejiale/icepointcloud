//
//  IPCCustomKeyboard.m
//  IcePointCloud
//
//  Created by gerry on 2017/11/14.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCustomKeyboard.h"

@interface IPCCustomKeyboard()

@property (nonatomic, strong) NSMutableArray<UIButton *> * buttons;
@property (nonatomic, strong) NSMutableString * appendString;

@end

@implementation IPCCustomKeyboard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCCustomKeyboard" owner:self];
        [view setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:view];
        
        [view addLeftLine];
        [view addTopLine];
        
        [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton * button = (UIButton *)obj;
                [button addBottomLine];
                [button addRightLine];
                [self.buttons addObject:button];
            }
        }];
        
        self.appendString = [[NSMutableString alloc]init];
    }
    return self;
}

- (NSMutableArray<UIButton *> *)buttons{
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc]init];
    }
    return _buttons;
}

- (IBAction)numberTapAction:(UIButton *)sender {
    if (sender.tag <=11)
    {
        NSInteger suffixLength = 0;
        NSString * suffixString = nil;
        
        if (self.appendString.length && [self.appendString containsString:@"."]) {
            NSRange rang = [self.appendString rangeOfString:@"."];
            suffixString = [self.appendString substringFromIndex:rang.location+1];
            suffixLength = suffixString.length;
            
            if (suffixLength == 2 ) {
                return;
            }
        }
        
        NSString * number = sender.titleLabel.text;
        if (sender.tag == 11) {
            if ([self.appendString containsString:@"."] || [self.appendString isEqualToString:@"0"] || self.appendString.length == 0) {
                return;
            }
        }
        if (sender.tag == 0 || sender.tag == 10) {
            if ([self.appendString isEqualToString:@"0"] || self.appendString.length == 0 ) {
                return;
            }
            if (sender.tag == 10) {
                if ([suffixString isEqualToString:@"0"] ) {
                    return;
                }
            }
        }
        [self.appendString appendString:number];
    }else if (sender.tag == 100){
        if (self.appendString.length) {
            [self.appendString deleteCharactersInRange:NSMakeRange(self.appendString.length-1, 1)];
        }
    }else if (sender.tag == 101){
        if ([self.delegate respondsToSelector:@selector(beginEditPrefixTextFieldForKeyboard:)]) {
            [self.delegate beginEditPrefixTextFieldForKeyboard:self];
        }
    }else if (sender.tag == 102){
        if ([self.delegate respondsToSelector:@selector(beginEditSuffixTextFieldForKeyboard:)]) {
            [self.delegate beginEditSuffixTextFieldForKeyboard:self];
        }
    }else if (sender.tag == 103){
        if ([self.delegate respondsToSelector:@selector(endEditingForKeyboard:Text:)]) {
            [self.delegate endEditingForKeyboard:self Text:self.appendString];
        }
    }
}



@end
