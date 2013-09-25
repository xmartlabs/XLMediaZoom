//
//  XLVideoZoom.h
//  XLKit
//
//  Created by Martin Barreto on 8/7/13.
//  Copyright (c) 2013 Xmartlabs. All rights reserved.
//

#import "XLMediaZoom.h"

@interface XLVideoZoom : XLMediaZoom

- (id)initWithAnimationTime:(NSNumber *)seconds
                      image:(UIImageView *)imageView
                   videoUrl:(NSURL *)videoUrl;

- (id)initWithAnimationTime:(NSNumber *)seconds
                      image:(UIImageView *)imageView
                   videoUrl:(NSURL *)videoUrl
                 blurEffect:(BOOL)useBlur;

@end
