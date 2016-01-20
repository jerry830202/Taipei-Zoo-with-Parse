//
//  FirstViewController.swift
//  finalproject
//
//  Created by HuYu lun on 2016/1/1.
//  Copyright © 2016年 HuYu lun. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.zoo.gov.taipei/")!))
    }
    @IBOutlet weak var webView: UIWebView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

