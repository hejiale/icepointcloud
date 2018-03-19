//
//  IPCOptometryKeyboardView.m
//  IcePointCloud
//
//  Created by gerry on 2018/3/19.
//  Copyright © 2018年 Doray. All rights reserved.
//

#import "IPCOptometryKeyboardView.h"

#define PositiveKeyboardType     101
#define NegativeKeyboardType    102
#define PointKeboardType           100
#define ClearKeyboardType         103
#define SureKeyboardType          104

@interface IPCOptometryKeyboardView()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) NSMutableArray<UIButton *> * buttons;
@property (nonatomic, strong) NSMutableString * appendString;

@end

@implementation IPCOptometryKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.appendString = [[NSMutableString alloc]init];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView * view = [UIView jk_loadInstanceFromNibWithName:@"IPCOptometryKeyboardView" owner:self];
    [view setFrame:self.bounds];
    [self addSubview:view];
    
    [view addLeftLine];
    [view addTopLine];
    
    __weak typeof(self) weakSelf = self;
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            UIButton * button = (UIButton *)obj;
            [button addBottomLine];
            [button addRightLine];
            [button setBackgroundImage:[UIImage jk_imageWithColor:[UIColor jk_colorWithHexString:@"#999999"]] forState:UIControlStateHighlighted];
            [strongSelf.buttons addObject:button];
        }
    }];
}

- (NSMutableArray<UIButton *> *)buttons{
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc]init];
    }
    return _buttons;
}

- (void)inputValue:(NSString *)text
{
    [self clearString];
    
    if (text.length) {
        [self.appendString appendString:text];
    }
}

- (IBAction)numberTapAction:(UIButton *)sender
{
    if (!self.isEdit)return;
    
    if (sender.tag <= PointKeboardType)
    {
        NSInteger suffixLength = 0;
        NSString * suffixString = nil;
        
        if (self.appendString.length && [self.appendString containsString:@"."]) {
            NSRange rang = [self.appendString rangeOfString:@"."];
            suffixString = [self.appendString substringFromIndex:rang.location+1];
            suffixLength = suffixString.length;
        }
        
        NSString * number = sender.titleLabel.text;
        
        if (sender.tag == PointKeboardType) {
            if ([self.appendString containsString:@"."] || self.appendString.length == 0) {
                return;
            }
            number = @".";
        }
        if (sender.tag == 0) {
            if ([self.appendString isEqualToString:@"0"] || self.appendString.length == 0) {
                self.appendString = [[NSMutableString alloc]init];
                number = @"0";
            }
        }
        [self.appendString appendString:number];
        
        if (self.index == 5 || self.index == 12) {
            if ([self.appendString containsString:@"mm"]) {
                NSRange rang = [self.appendString rangeOfString:@"mm"];
                [self.appendString deleteCharactersInRange:NSMakeRange(rang.location, 2)];
            }
            [self.appendString appendString:@"mm"];
        }
        
        if ([self.delegate respondsToSelector:@selector(keyboardChangeEditing:Keyboard:)]) {
            [self.delegate keyboardChangeEditing:self.appendString Keyboard:self];
        }
    }else if (sender.tag == PositiveKeyboardType && (self.index == 0 || self.index == 1 || self.index == 3)){
        if (![self.appendString containsString:@"+"]) {
            if ([self.appendString containsString:@"-"]) {
                [self.appendString deleteCharactersInRange:NSMakeRange(0, 1)];
            }
            [self.appendString insertString:@"+" atIndex:0];
            
            if ([self.delegate respondsToSelector:@selector(keyboardChangeEditing:Keyboard:)]) {
                [self.delegate keyboardChangeEditing:self.appendString Keyboard:self];
            }
        }
    }else if (sender.tag == NegativeKeyboardType && (self.index == 0 || self.index == 1 || self.index == 3)){
        if (![self.appendString containsString:@"-"]) {
            if ([self.appendString containsString:@"+"]) {
                [self.appendString deleteCharactersInRange:NSMakeRange(0, 1)];
            }
            [self.appendString insertString:@"-" atIndex:0];
            
            if ([self.delegate respondsToSelector:@selector(keyboardChangeEditing:Keyboard:)]) {
                [self.delegate keyboardChangeEditing:self.appendString Keyboard:self];
            }
        }
    } else if (sender.tag == ClearKeyboardType){
        if (self.appendString.length) {
            if (self.index == 5 || self.index == 12) {
                if ([self.appendString containsString:@"mm"]) {
                    NSRange rang = [self.appendString rangeOfString:@"mm"];
                    [self.appendString deleteCharactersInRange:NSMakeRange(rang.location, 2)];
                }
                
                [self.appendString deleteCharactersInRange:NSMakeRange(self.appendString.length-1, 1)];
                
                if (self.appendString.length) {
                    [self.appendString appendString:@"mm"];
                }
            }else{
                [self.appendString deleteCharactersInRange:NSMakeRange(self.appendString.length-1, 1)];
            }
        }else{
            [self clearString];
        }
        if ([self.delegate respondsToSelector:@selector(keyboardChangeEditing:Keyboard:)]) {
            [self.delegate keyboardChangeEditing:self.appendString Keyboard:self];
        }
    }else if (sender.tag == SureKeyboardType){
        if ([self.delegate respondsToSelector:@selector(keyboardEndEditing:Keyboard:)]) {
            [self.delegate keyboardEndEditing:self.appendString Keyboard:self];
        }
        [self clearString];
    }
}

- (void)clearString
{
    ///清空
    self.appendString = [[NSMutableString alloc]init];
}

@end
