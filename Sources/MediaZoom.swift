//
//  MediaZoom.swift
//  MediaZoom (https://github.com/xmartlabs/XLMediaZoom)
//
//  Copyright (c) 2017 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

public class MediaZoom: UIView, UIScrollViewDelegate {

    public lazy var imageView: UIImageView = {
        let image = UIImageView(frame: self.mediaFrame())
        image.clipsToBounds = true
        image.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        image.contentMode = .scaleAspectFill
        return image
    }()

    public var maxAlpha: CGFloat = 1
    public var hideHandler: (() -> ())?
    public var useBlurEffect = false
    public var animationTime: Double
    public var originalImageView: UIImageView
    public var backgroundView: UIView
    public lazy var contentView: UIScrollView = {
        let contentView = UIScrollView(frame: MediaZoom.currentFrame())
        contentView.contentSize = self.mediaFrame().size
        contentView.backgroundColor = .clear
        contentView.maximumZoomScale = 1.5
        return contentView
    }()

    public init(with image: UIImageView, animationTime: Double, useBlur: Bool = false) {
        let frame = MediaZoom.currentFrame()
        self.animationTime = animationTime
        useBlurEffect = useBlur
        originalImageView = image
        backgroundView = MediaZoom.backgroundView(with: frame, useBlur: useBlur)
        super.init(frame: frame)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceOrientationDidChange(notification:)),
            name: .UIDeviceOrientationDidChange,
            object: nil
        )
        imageView.image = image.image
        addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(handleSingleTap(sender:))
            )
        )
        contentView.addSubview(imageView)
        contentView.delegate = self
        addSubview(backgroundView)
        addSubview(contentView)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func show(onHide callback: (() -> ())? = nil) {
        let frame = MediaZoom.currentFrame()
        self.frame = frame
        backgroundView.frame = frame
        imageView.frame = mediaFrame()
        hideHandler = callback
        UIView.animate(
            withDuration: animationTime,
            animations: { [weak self] in
                guard let `self` = self else { return }
                self.imageView.frame = self.imageFrame()
                self.backgroundView.alpha = self.maxAlpha
            },
            completion: { [weak self] finished in
                if finished {
                    self?.showAnimationDidFinish()
                }
            }
        )
    }

    private static func backgroundView(with frame: CGRect, useBlur: Bool) -> UIView {
        if useBlur {
            let blurView = UIVisualEffectView(frame: frame)
            blurView.effect = UIBlurEffect(style: .dark)
            blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            blurView.alpha = 0
            return blurView
        } else {
            let bgView = UIView(frame: frame)
            bgView.backgroundColor = .black
            bgView.alpha = 0
            return bgView
        }
    }

    private static func currentFrame() -> CGRect {
        let screenSize = UIScreen.main.bounds
        return CGRect(
            x: CGFloat(0),
            y: CGFloat(0),
            width: screenSize.width,
            height: screenSize.height
        )
    }

    private func imageFrame() -> CGRect {
        let size = bounds
        guard let imageSize = imageView.image?.size else { return CGRect.zero }
        let ratio = min(size.height / imageSize.height, size.width / imageSize.width)
        let imageWidth = imageSize.width * ratio
        let imageHeight = imageSize.height * ratio
        let imageX = (frame.size.width - imageWidth) * 0.5
        let imageY = (frame.size.height - imageHeight) * 0.5
        return CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
    }

    private func mediaFrame() -> CGRect {
        return originalImageView.frame
    }

    @objc func deviceOrientationDidChange(notification: NSNotification) {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .landscapeLeft, .landscapeRight, .portrait:
            let newFrame = MediaZoom.currentFrame()
            frame = newFrame
            backgroundView.frame = newFrame
            imageView.frame = imageFrame()
        default:
            break
        }
    }

    @objc public func handleSingleTap(sender: UITapGestureRecognizer) {
        willHandleSingleTap()
        UIView.animate(
            withDuration: animationTime,
            animations: { [weak self] in
                guard let `self` = self else { return }
                self.contentView.zoomScale = 1
                self.imageView.frame = self.mediaFrame()
                self.backgroundView.alpha = 0
            },
            completion: { [weak self] finished in
                if finished {
                    self?.removeFromSuperview()
                    self?.contentView.zoomScale = 1
                    self?.hideHandler?()
                }
            }
        )
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        let yOffset = (scrollView.frame.height - imageView.frame.height) / 2.0
        let xOffset = (scrollView.frame.width - imageView.frame.width) / 2.0
        let x = xOffset > 0 ? xOffset : scrollView.frame.origin.x
        let y = yOffset > 0 ? yOffset : scrollView.frame.origin.y
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.imageView.frame.origin = CGPoint(x: x, y: y)
        }
        return imageView
    }

    open func willHandleSingleTap() {

    }

    open func showAnimationDidFinish() {

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
