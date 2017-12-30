//
//  AboutCell.swift
//  BmoViewPager_Example
//
//  Created by LEE ZHE YU on 2017/12/30.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class AboutCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 5.0
        self.containerView.layer.masksToBounds = true
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.containerView.backgroundColor = UIColor.groupTableViewBackground.darkerColor()
        } else {
            self.containerView.backgroundColor = UIColor.groupTableViewBackground
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
