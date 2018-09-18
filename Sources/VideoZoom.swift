//
//  VideoZoom.swift
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

import AVFoundation
import UIKit

public class VideoZoom: MediaZoom {

    public var videoUrl: URL
    public var player: AVPlayer?
    public var playerLayer: AVPlayerLayer?

    public init(with image: UIImageView, url: URL, animationTime: Double, useBlur: Bool) {
        videoUrl = url
        super.init(with: image, animationTime: animationTime, useBlur: useBlur)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func showAnimationDidFinish() {
        player = AVPlayer(url: videoUrl)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = imageView.bounds
        playerLayer?.backgroundColor = imageView.backgroundColor?.cgColor
        playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill

        imageView.layer.needsDisplayOnBoundsChange = true
        guard let playerLayer = self.playerLayer else { return }
        imageView.layer.addSublayer(playerLayer)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(itemDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
        player?.play()
    }

    @objc public func itemDidFinishPlaying() {
        pauseVideoAndRemoveLayer()
    }

    public func pauseVideoAndRemoveLayer() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
    }

    override public func handleSingleTap(sender: UITapGestureRecognizer) {
        pauseVideoAndRemoveLayer()
        super.handleSingleTap(sender: sender)
    }

    override func deviceOrientationDidChange(notification: NSNotification) {
        super.deviceOrientationDidChange(notification: notification)
        playerLayer?.frame = imageView.bounds
    }
    
}
