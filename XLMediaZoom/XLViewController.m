//
//  XLViewController.m
//  XLMediaZoom
//
//  Created by Miguel Revetria on 08/08/13.
//  Copyright (c) 2013 Xmartlabs. All rights reserved.
//

#import "XLViewController.h"

#import "XLMediaZoom.h"
#import "XLVideoZoom.h"


@interface XLViewController ()

@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) XLMediaZoom *imageZoomView;
@property (strong, nonatomic) UIImageView *videoImageView;
@property (strong, nonatomic) XLVideoZoom *videoZoomView;

@end

@implementation XLViewController

@synthesize backgroundView  = _backgroundView;
@synthesize imageView       = _imageView;
@synthesize imageZoomView   = _imageZoomView;
@synthesize videoImageView  = _videoImageView;
@synthesize videoZoomView   = _videoZoomView;

- (UIImageView *)backgroundView
{
    if (_backgroundView) return _backgroundView;
    
    _backgroundView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [_backgroundView setImage:[UIImage imageNamed:@"background" ]];
    
    return _backgroundView;
}

- (UIImageView *)imageView
{
    if (_imageView) return _imageView;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 120)];
    _imageView.center = CGPointMake(self.view.frame.size.width / 2, 100);
    
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidTouch:)]];
    [_imageView setImage:[UIImage imageNamed:@"galaxy"]];
    [_imageView setUserInteractionEnabled:YES];

    return _imageView;
}

- (XLMediaZoom *)imageZoomView
{
    if (_imageZoomView) return _imageZoomView;
    
    _imageZoomView = [[XLMediaZoom alloc] initWithAnimationTime:@(0.5) image:self.imageView blurEffect:YES];
    _imageZoomView.tag = 1;
    _imageZoomView.backgroundColor = [UIColor colorWithRed:0.0 green:0.05 blue:0.3 alpha:1.0];
    
    return _imageZoomView;
}

- (UIImageView *)videoImageView
{
    if (_videoImageView) return _videoImageView;
    
    _videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 120)];
    _videoImageView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 100);
    
    [_videoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoDidTouch:)]];
    [_videoImageView setImage:[UIImage imageNamed:@"video_image"]];
    [_videoImageView setUserInteractionEnabled:YES];
    
    return _videoImageView;
}

- (XLVideoZoom *)videoZoomView
{
    if (_videoZoomView) return _videoZoomView;
    
    _videoZoomView = [[XLVideoZoom alloc] initWithAnimationTime:@(0.5) image:self.videoImageView videoUrl:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mov"]]];
    _videoZoomView.tag = 2;
    _videoZoomView.maxAlpha = 0.85;

    return _videoZoomView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.videoImageView];
    
    [self.view sendSubviewToBack:self.backgroundView];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    XLViewController * __weak weakSelf = self;
    [UIView animateWithDuration:0.15 animations:^{
        if (UIInterfaceOrientationIsLandscape(fromInterfaceOrientation)) {
            self.imageView.center = CGPointMake(self.view.frame.size.width / 2, 100);
            self.videoImageView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 100);
        } else {
            self.imageView.center = CGPointMake(self.view.frame.size.height / 2, 80);
            self.videoImageView.center = CGPointMake(self.view.frame.size.height / 2, self.view.frame.size.width - 80);
        }
    } completion:^(BOOL finished) {
        NSLog(@"%@", weakSelf.view);
    }];
}

- (void)imageDidTouch:(UIGestureRecognizer *)recognizer
{
    [self.view addSubview:self.imageZoomView];
    [self.imageZoomView show];
}

- (void)videoDidTouch:(UIGestureRecognizer *)recognizer
{
    [self.view addSubview:self.videoZoomView];
    [self.videoZoomView show:^{
        // TODO: do anything what you want here
    }];
}

@end
