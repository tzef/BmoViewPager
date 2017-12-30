//
//  AboutViewController.swift
//  BmoViewPager_Example
//
//  Created by LEE ZHE YU on 2017/12/29.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import SafariServices

private let emptyIdentifier = "emptyCell"
private let reuseIdentifier = "reuseCell"
class AboutViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: emptyIdentifier)
    }
}

extension AboutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? AboutCell else {
            return tableView.dequeueReusableCell(withIdentifier: emptyIdentifier, for: indexPath)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}

extension AboutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            guard let url = URL(string: "https://github.com/tzef/BmoViewPager") else {
                return
            }
            if #available(iOS 9.0, *) {
                let vc = SFSafariViewController(url: url)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                UIApplication.shared.openURL(url)
            }
        default:
            break
        }
    }
}
