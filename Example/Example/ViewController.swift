//
//  ViewController.swift
//  Example
//
//  Copyright © 2016 Xmartlabs SRL. All rights reserved.
//

import UIKit
import XLMediaZoom

class ViewController: UIViewController {

    @IBOutlet weak var videoView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!

    var videoZoom: VideoZoom?
    var mediaZoom: MediaZoom?

    override func viewDidLoad() {
        super.viewDidLoad()
        mediaZoom = MediaZoom(with: imageView, animationTime: 1, useBlur: true)
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType: "mov")!)
        videoZoom = VideoZoom(with: videoView, url: url, animationTime: 1, useBlur: true)

        imageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImage(sender:))))
        imageView.isUserInteractionEnabled = true
        videoView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showVideo(sender:))))
        videoView.isUserInteractionEnabled = true
    }

    func showImage(sender: UITapGestureRecognizer) {
        view.addSubview(mediaZoom!)
        mediaZoom?.show()
    }

    func showVideo(sender: UITapGestureRecognizer) {
        view.addSubview(videoZoom!)
        videoZoom?.show()
    }

}

