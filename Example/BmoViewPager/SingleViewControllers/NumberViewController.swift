//
//  NumberViewController.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/6/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class NumberViewController: UIViewController {
    @IBOutlet var numberLabel: UILabel!
    
    var numberText: String?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience init(number: Int) {
        self.init(nibName: "NumberViewController", bundle: nil)
        numberText = "\(number)"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        numberLabel.text = numberText
    }
}
