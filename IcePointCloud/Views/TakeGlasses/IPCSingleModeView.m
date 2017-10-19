//
//  IPCSingleModeView.m
//  IcePointCloud
//
//  Created by mac on 8/15/14.
//  Copyright (c) 2014 Doray. All rights reserved.
//

#import "IPCSingleModeView.h"

@interface IPCSingleModeView()

@property (nonatomic, weak)  IBOutlet UIImageView *modelView;

@end

@implementation IPCSingleModeView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.closeButton addTarget:self action:@selector(hidenGlassBgView) forControlEvents:UIControlEventTouchUpInside];
    [self resetGlassView];
}


- (void)setMatchItem:(IPCMatchItem *)matchItem
{
    _matchItem = matchItem;
    [self updateItem];
}

#pragma mark //Clicked Events
- (IBAction)handlePhotoPinch:(UIPinchGestureRecognizer *)recognizer
{
    CGFloat scale = recognizer.scale;
    
    self.modelView.transform = CGAffineTransformScale(self.modelView.transform, scale, scale);
    self.glassesView.transform = CGAffineTransformScale(self.glassesView.transform, scale, scale);
    
    recognizer.scale = 1;
}

- (IBAction)doubleTapPhotoAction:(UITapGestureRecognizer *)recognizer{
    [self updateItem];
}

- (void)resetGlassView
{
    [super resetGlassView];
    
    self.modelView.transform = CGAffineTransformIdentity;
    self.glassesView.transform = CGAffineTransformIdentity;
    [self.glassImageView setImage:nil];
}

- (IBAction)tapModelViewAction:(id)sender {
    [self hidenCloseCover];
}

- (void)hidenGlassBgView
{
    self.matchItem.glass = nil;
    [self updateItem];
    [self deleteModel];
}

- (void)deleteModel
{
}

#pragma mark //Update Model Photo And Glasses
//Update the model picture
- (void)updateModelPhoto
{
    [super updateModelPhoto];
    
    self.modelView.transform = CGAffineTransformIdentity;
    
    UIImage *img;
    switch (self.matchItem.photoType) {
        case IPCPhotoTypeModel:
            img = [IPCAppManager modelPhotoWithType:self.matchItem.modelType usage:IPCModelUsageSingleMode];
            break;
        case IPCPhotoTypeFrontial:
            img = self.matchItem.frontialPhoto;
            break;
        default:
            break;
    }
    self.modelView.image = img;
}

/**
 *  Updated photo like glasses
 */
- (void)updateFaceUI:(CGPoint)point :(CGSize)size
{
    [super updateFaceUI:point :size];
    
    self.cameraEyePoint = point;
    self.cameraEyeSize = size;
    
    [self updateGlassFrame];
}


/**
 *  Update the position of the glasses
 */
- (void)updateGlassFrame{
    CGRect frame           = self.glassesView.frame;
    frame.size.width       = self.cameraEyeSize.width;
    self.glassesView.frame = frame;
    
    [self updateItem];
}

//Place the glasses
- (void)updateItem{
    [super updateItem];
    
    self.modelView.transform = CGAffineTransformIdentity;
    self.glassesView.transform = CGAffineTransformIdentity;
    
    [self updateGlassesPositionWithMatchItem:self.matchItem];
}

@end
