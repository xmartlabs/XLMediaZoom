//
//  XLMediaZoom.m
//  XLKit
//
//  Created by Miguel Revetria on 06/08/13.
//  Copyright (c) 2013 Xmartlabs. All rights reserved.
//

#import "XLMediaZoom.h"

@interface XLMediaZoom()

@property               	NSNumber    * animationTime;
@property (nonatomic)       UIView      * backgroundView;
@property (nonatomic)       UIImageView * imageView;
@property (weak, nonatomic) UIImageView * originalImageView;

@end

@implementation XLMediaZoom
{
    BOOL _useBlurEffect;
}

@synthesize animationTime   = _animationTime;
@synthesize backgroundView  = _backgroundView;
@synthesize imageView       = _imageView;
@synthesize hideHandler     = _hideHandler;
@synthesize maxAlpha        = _maxAlpha;

#pragma mark -
#pragma mark - Views controls

- (UIView *)backgroundView
{
    if (_backgroundView) return _backgroundView;
    
    if (_useBlurEffect) {
        UINavigationBar *blurView = [[UINavigationBar alloc] initWithFrame:self.frame];
        blurView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        blurView.barTintColor = [UIColor blackColor];
        blurView.alpha = 0.0;
        _backgroundView = blurView;
    } else {
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        [_backgroundView setBackgroundColor:[UIColor blackColor]];
        [_backgroundView setAlpha:0.0];
    }
    
    return _backgroundView;
}

- (UIImageView *)imageView
{
    if (_imageView) return _imageView;
    
    _imageView = [[UIImageView alloc] initWithFrame:self.initMediaFrame];
    _imageView.clipsToBounds = YES;
    [_imageView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    
    return _imageView;
}

- (CGRect)initMediaFrame
{
    CGPoint location = [self convertPoint:CGPointMake(0, 0) fromView:self.originalImageView];
    CGRect frame = CGRectMake(location.x, location.y, self.originalImageView.bounds.size.width, self.originalImageView.bounds.size.height);
    return frame;
}


#pragma mark - Lifecycle

- (id)initWithAnimationTime:(NSNumber *)seconds
                      image:(UIImageView *)imageView
{
    return [self initWithAnimationTime:seconds image:imageView blurEffect:NO];
}

- (id)initWithAnimationTime:(NSNumber *)seconds
                      image:(UIImageView *)imageView
                 blurEffect:(BOOL)useBlur
{
    self = [super initWithFrame:[self currentFrame:[[UIApplication sharedApplication] statusBarOrientation]]];
    if (self) {
        _useBlurEffect = useBlur && !SYSTEM_VERSION_iOS_6;
        
        self.animationTime = seconds;
        self.originalImageView = imageView;
        self.maxAlpha = 1.0;
        [self.imageView setImage:imageView.image];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)]];
        [self addSubview:self.backgroundView];
        [self addSubview:self.imageView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setImage:(UIImage *)image
{
    [self.imageView setImage:image];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (SYSTEM_VERSION_iOS_6) {
        self.backgroundView.backgroundColor = backgroundColor;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    } else {
        ((UINavigationBar *) self.backgroundView).barTintColor = backgroundColor;
#endif
    }
}

- (void)show
{
    [self show:nil];
}

- (void)show:(void(^)(void))callback
{
    self.frame = [self currentFrame:[[UIApplication sharedApplication] statusBarOrientation]];
    self.backgroundView.frame = [self currentFrame:[[UIApplication sharedApplication] statusBarOrientation]];
    self.imageView.frame = [self initMediaFrame];
    self.hideHandler = [callback copy];
    
    XLMediaZoom * __weak weakSelf = self;
    [UIView animateWithDuration:[self.animationTime doubleValue]
                     animations:^{
                         weakSelf.imageView.frame = [weakSelf imageFrame];
                         [weakSelf.backgroundView setAlpha:weakSelf.maxAlpha];
                     }
                     completion:^(BOOL finished) {
                         if (finished){
                             [self showAnimationDidFinish];
                         }
                     }
     ];
}

-(void)showAnimationDidFinish
{
    // do something in the base class
}

-(void)willHandleSingleTap
{
    // do something in the base class
}

#pragma mark - Auxiliary functions

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    [self willHandleSingleTap];
    XLMediaZoom * __weak weakSelf = self;
    
    [UIView animateWithDuration:[self.animationTime doubleValue]
                     animations:^{
                         // Resize the image view to fill the view frame
                         weakSelf.imageView.frame = weakSelf.initMediaFrame;
                         [weakSelf.backgroundView setAlpha:0.0];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self removeFromSuperview];
                             if (self.hideHandler) {
                                 self.hideHandler();
                             }
                         }
                     }
     ];
}

- (CGRect)currentFrame:(UIInterfaceOrientation)orientation
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    float statusBarHeight = 0;
    
    if (SYSTEM_VERSION_iOS_6 && ![UIApplication sharedApplication].statusBarHidden) {
        statusBarHeight = 20;
    }
    if (UIInterfaceOrientationIsLandscape(orientation)){
        return CGRectMake(0, 0, screenSize.height, screenSize.width - statusBarHeight);
    }
    return CGRectMake(0, 0, screenSize.width, screenSize.height - statusBarHeight);
}

- (CGRect)imageFrame
{
    CGSize size = self.bounds.size;
    CGSize imageSize = self.imageView.image.size;
    float ratio = fminf(size.height / imageSize.height, size.width / imageSize.width);
    
    float imageViewWidth = imageSize.width * ratio;
    float imageViewHeight = imageSize.height * ratio;
    
    return CGRectMake((self.frame.size.width - imageViewWidth) * 0.5f, (self.frame.size.height - imageViewHeight) * 0.5f, imageViewWidth, imageViewHeight);
}

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight || orientation == UIDeviceOrientationPortrait) {
        self.frame = [self currentFrame:(UIInterfaceOrientation)orientation];
        self.backgroundView.frame = [self currentFrame:(UIInterfaceOrientation)orientation];
        self.imageView.frame = [self imageFrame];
    }
}

@end
