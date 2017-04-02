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
    
    var demoViewControllers: [DemoViewControllerType] = [.fromStoryboard, .tableView, .time, .fromXib, .time]
    var demoTableViewDataSource = DemoTableViewDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPager.dataSource = self
    }
    
    // MARK: - BmoViewPagerDataSource
    func bmoViewPagerNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return demoViewControllers.count
    }
    func bmoViewPager(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
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
            indexLabel.layout.autoFit(vc.view)
            return vc
        }
        return UITableViewController()
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
