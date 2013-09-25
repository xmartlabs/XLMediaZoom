XLMediaZoom
========

XLMediaZoom is a tool for iPhone (iOS 5+) to display images and reproduce videos in fullscreen like Instagram does. It's fully tested on iOS 7 and has blur capability depending on your iPhone device.

Installation
--------

The easy way to integrate XLMediaZoom in your projects is via [CocoaPods](http://cocoapods.org).

`pod 'XLMediaZoom'`

If you prefer, you can install XLMediaZoom manually by doing:
1. Drag and drop the folder XLMediaZoom/XL to your project
2. In files where you think you will use this utility import `XLMediaZoom.h` for images and `XLVideoZoom.h` for videos.

Example
--------

See `XLViewController` in the example project for details on how to use this component. In short, though:

```objc
UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 120)];
// Declare an image zoom view associated with the previous UIImageView
XLMediaZoom *imageZoom = [[XLMediaZoom alloc] initWithAnimationTime:@(0.5) image:imageView blurEffect:YES];

//..

// On image touch do (you could use a UITapGestureRecognizer):
[self.view addSubview:imageZoom];
[imageZoom show];
```

To go out of fullscreen, simply tap the image or video.

<P ALIGN="CENTER">
<IMG SRC="https://f.cloud.github.com/assets/4791678/963911/8609b3ea-050b-11e3-9dd0-417862a724cf.gif" ALT="XLMediaZoom preview"/>
</P>

XLMediaZoom available classes
--------

1. `XLMediaZoom` defined in `XLMediaZoom.h`. This base class is used to fullscreen an image taking an UIImageView for that.
2. `XLVideoZoom` defined in `XLMediaZoom.h`. This class inherits from XLMediaZoom and takes a UIImageView (video's preview) and a NSURL (video's URL).
Use this class is similar as you use XLMediaZoom.

License
--------
XLMediaZoom is distributed under MIT license, please feel free to use it and contribute.

Contact
--------

If you are using XLMediaZoom in your project and have any suggestion or any question:

Martin Barreto, <martin@xmartlabs.com>

Miguel Revetria, <miguel@xmartlabs.com>

[@Xmartlabs](http://www.xmartlabs.com)
