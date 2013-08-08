//
//  XLMediaZoom.h
//  XLKit
//
//  Created by Miguel Revetria on 06/08/13.
//  Copyright (c) 2013 Xmartlabs. All rights reserved.
//

@class XLMediaZoom;

@interface XLMediaZoom : UIView

- (id)initWithAnimationTime:(NSNumber *)seconds
                      image:(UIImageView *)imageView;

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
