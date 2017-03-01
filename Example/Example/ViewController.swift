//
//  ViewController.swift
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

        imageView?.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(showImage(sender:))
            )
        )
        imageView.isUserInteractionEnabled = true
        videoView?.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(showVideo(sender:))
            )
        )
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
