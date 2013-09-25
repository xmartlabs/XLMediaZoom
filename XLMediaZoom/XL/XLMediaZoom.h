//
//  XLMediaZoom.h
//  XLKit
//
//  Created by Miguel Revetria on 06/08/13.
//  Copyright (c) 2013 Xmartlabs. All rights reserved.
//

@class XLMediaZoom;

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_iOS_6 (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)

@interface XLMediaZoom : UIView

- (id)initWithAnimationTime:(NSNumber *)seconds
                      image:(UIImageView *)imageView;

- (id)initWithAnimationTime:(NSNumber *)seconds
                      image:(UIImageView *)imageView
                 blurEffect:(BOOL)useBlur;

@property (readonly, nonatomic)  UIImageView * imageView;
@property CGFloat maxAlpha;
@property (copy) void (^hideHandler)(void);

- (void)setImage:(UIImage *)image;

- (void)show;
- (void)show:(void(^)(void))callback;

@end

/////////////////////////////////////////////////////////
// Protected functions

@interface XLMediaZoom()

- (void)showAnimationDidFinish;
- (void)willHandleSingleTap;
- (void)deviceOrientationDidChange:(NSNotification *)notification;

@end

/////////////////////////////////////////////////////////
