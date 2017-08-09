//
//  IPCCollectionViewIndex.m
//  IcePointCloud
//
//  Created by gerry on 2017/8/8.
//  Copyright © 2017年 Doray. All rights reserved.
//

#import "IPCCollectionViewIndex.h"

#define RGB(r,g,b,a)  [UIColor colorWithRed:(double)r/255.0f green:(double)g/255.0f blue:(double)b/255.0f alpha:a]

@interface IPCCollectionViewIndex()
{
    BOOL _isLayedOut;
    CAShapeLayer *_shapeLayer;
    CGFloat _letterHeight;
}

@property (strong, nonatomic) NSMutableArray<CATextLayer *> * textLayers;

@end

@implementation IPCCollectionViewIndex


-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (NSMutableArray<CATextLayer *> *)textLayers
{
    if (!_textLayers) {
        _textLayers = [[NSMutableArray alloc]init];
    }
    return _textLayers;
}

-(void)setCollectionDelegate:(id<IPCCollectionViewIndexDelegate>)collectionDelegate{
    
    _collectionDelegate = collectionDelegate;
    _isLayedOut = NO;  //如果为yes就是超过此layer的部分都裁剪掉，使用圆角的时候常用到
    [self layoutSubviews];
}

//UIView的setNeedsLayout时会执行此方法
-(void)layoutSubviews{
    
    [super layoutSubviews];
    [self setup];
    
    if (!_isLayedOut) {
        [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        
        /*----绘制边框线部分----*/
        _shapeLayer.frame = CGRectMake(CGPointZero.x, CGPointZero.y, self.layer.frame.size.width, self.layer.frame.size.height);
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointZero];
        [bezierPath addLineToPoint:CGPointMake(0, self.frame.size.height)];
        
        /*-----绘制文字部分------*/
        _letterHeight = 16;
        CGFloat fontSize = 12;
        [self.titleIndexes enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            CGFloat originY = idx * _letterHeight;
            CATextLayer *ctl = [self textLayerWithSize:fontSize
                                                string:obj
                                              andFrame:CGRectMake(0, originY, self.frame.size.width, _letterHeight)];
            
            [self.layer addSublayer:ctl];
            [self.textLayers addObject:ctl];
            
            [bezierPath moveToPoint:CGPointMake(0, originY)];
            [bezierPath addLineToPoint:CGPointMake(ctl.frame.size.width, originY)];
        }];
        
        _shapeLayer.path = bezierPath.CGPath;
        
        if(_isFrameLayer){
            [self.layer addSublayer:_shapeLayer];
        }
        
        _isLayedOut = YES;
    }
}

#pragma mark- 私有方法

//绘制边框线
-(void)setup{
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineWidth = 1.0f;
    _shapeLayer.fillColor = [UIColor blackColor].CGColor;
    _shapeLayer.lineJoin = kCALineCapSquare;
    _shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
    _shapeLayer.strokeEnd = 1.0f;
    
    self.layer.masksToBounds = NO;
}

//绘制字体
- (CATextLayer*)textLayerWithSize:(CGFloat)size string:(NSString*)string andFrame:(CGRect)frame{
    CATextLayer *tl = [CATextLayer layer];
    [tl setFont:@"ArialMT"];
    [tl setFontSize:size];
    [tl setFrame:frame];
    [tl setAlignmentMode:kCAAlignmentCenter];
    [tl setContentsScale:[[UIScreen mainScreen] scale]];
    [tl setForegroundColor:RGB(168, 168, 168, 1).CGColor];
    [tl setString:string];
    return tl;
}


//根据触摸事件的触摸点来算出点击的是第几个section
- (void)sendEventToDelegate:(UIEvent*)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    
    NSInteger indx = ((NSInteger) floorf(point.y) / _letterHeight);
    
    if (indx< 0 || indx > self.titleIndexes.count - 1) {
        return;
    }
    
    [self.textLayers enumerateObjectsUsingBlock:^(CATextLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == indx) {
            [obj setForegroundColor:COLOR_RGB_BLUE.CGColor];
        }else{
            [obj setForegroundColor:RGB(168, 168, 168, 1).CGColor];
        }
    }];
    
    [self.collectionDelegate collectionViewIndex:self didselectionAtIndex:indx withTitle:self.titleIndexes[indx] Point:point];
}
#pragma mark- response事件

//开始触摸
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self sendEventToDelegate:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    [self sendEventToDelegate:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.collectionDelegate collectionViewIndexTouchesEnd:self];
}



@end
