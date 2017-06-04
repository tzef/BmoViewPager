//
//  DemoFromXibViewController.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/4/2.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import WebKit

class DemoFromXibViewController: UIViewController {

    let webView = WKWebView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(webView)
        webView.bmoVP.autoFit(self.view)
        
        webView.load(URLRequest.init(url: URL.init(string: "https://www.google.com")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
