//
//  XLVideoZoom.m
//  XLKit
//
//  Created by Martin Barreto on 8/7/13.
//  Copyright (c) 2013 Xmartlabs. All rights reserved.
//

#import "XLVideoZoom.h"

#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"

@interface XLVideoZoom()
{
    AVPlayer      *  _player;
    AVPlayerLayer *  _playerLayer;
}

@property NSURL * url;

@end

@implementation XLVideoZoom

@synthesize url = _url;


- (id)initWithAnimationTime:(NSNumber *)seconds
                      image:(UIImageView *)imageView
                   videoUrl:(NSURL *)videoUrl
{
    return [self initWithAnimationTime:seconds image:imageView videoUrl:videoUrl blurEffect:NO];
}

- (id)initWithAnimationTime:(NSNumber *)seconds
                      image:(UIImageView *)imageView
                   videoUrl:(NSURL *)videoUrl
                 blurEffect:(BOOL)useBlur
{
    self = [super initWithAnimationTime:seconds image:imageView blurEffect:useBlur];
    if (self)
    {
        self.url = videoUrl;
    }
    return self;
}

-(void)showAnimationDidFinish
{
    _player = [AVPlayer playerWithURL:self.url];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    [_playerLayer setFrame:self.imageView.bounds];
    [_playerLayer setBackgroundColor:self.imageView.backgroundColor.CGColor];
    [_playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [self.imageView.layer setNeedsDisplayOnBoundsChange:YES];
    
    
    [self.imageView.layer addSublayer:_playerLayer];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    
    [_player play];
}

-(void)itemDidFinishPlaying
{
    [self pauseVideoAndRemoveLayer];
}

-(void)pauseVideoAndRemoveLayer
{
    [_player pause];
    [_playerLayer removeFromSuperlayer];
}

-(void)willHandleSingleTap
{
    [self pauseVideoAndRemoveLayer];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    [super deviceOrientationDidChange:notification];
    [_playerLayer setFrame:self.imageView.bounds];
}



@end
