//
//  ViewController.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 03/31/2017.
//  Copyright (c) 2017 LEE ZHE YU. All rights reserved.
//

import UIKit
import BmoViewPager

enum DemoViewControllerType {
    case fromStoryboard
    case tableView
    case fromXib
    case time
}
class ViewController: UIViewController, BmoViewPagerDataSource {
    @IBOutlet weak var viewPager: BmoViewPager!

    var demoTitles = ["Page 1", "Page 2", "Page 3", "Page 4", "Page 5"]
    var demoViewControllers: [DemoViewControllerType] = [.fromStoryboard, .tableView, .time, .fromXib, .time]
    var demoTableViewDataSource = DemoTableViewDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPager.dataSource = self
        viewPager.presentedPageIndex = 2
    }
    
    // MARK: - BmoViewPagerDataSource
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return demoViewControllers.count
    }
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        switch demoViewControllers[page] {
        case .fromStoryboard:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "DemoFromStoryboardViewController") as? DemoFromStoryboardViewController {
                return vc
            }
        case .tableView:
            let vc = UITableViewController(style: UITableViewStyle.grouped)
            vc.tableView.dataSource = demoTableViewDataSource
            vc.tableView.reloadData()
            return vc
        case .fromXib:
            return DemoFromXibViewController(nibName: "DemoFromXibViewController", bundle: nil)
        case .time:
            let vc = UIViewController()
            let indexLabel = UILabel()
            indexLabel.numberOfLines = 0
            indexLabel.textAlignment = .center
            indexLabel.text = "Created at \n\(Date())"
            vc.view.addSubview(indexLabel)
            vc.view.backgroundColor = .brown
            indexLabel.bmoVP.autoFit(vc.view)
            return vc
        }
        return UIViewController()
    }
    func bmoViewPagerDataSourceTitle(_ viewPager: BmoViewPager, forPageListAt page: Int) -> String? {
        return demoTitles[page]
    }
}

class DemoTableViewDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "reuseIdentifier")
        cell.textLabel?.text = "Cell \(indexPath)"
        return cell
    }
}
