//
//  VideoZoom.swift
//  MediaZoom
//
//  Created by Mauricio Cousillas on 2/20/17.
//  Copyright © 2017 Mauricio Cousillas. All rights reserved.
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
        playerLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill

        imageView.layer.needsDisplayOnBoundsChange = true
        guard let playerLayer = self.playerLayer else { return }
        imageView.layer.addSublayer(playerLayer)
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        player?.play()
    }

    public func itemDidFinishPlaying() {
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
