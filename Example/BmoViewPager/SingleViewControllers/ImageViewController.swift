//
//  ImageViewController.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/6/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience init(image: UIImage?) {
        self.init(nibName: "ImageViewController", bundle: nil)
        self.image = image
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        imageView.layer.masksToBounds = true
    }
}
