//
//  WebviewController.swift
//  ParseDemo
//
//  Created by HuYu lun on 2016/1/13.
//  Copyright © 2016年 abearablecode. All rights reserved.
//import UIKit

import UIKit
class webViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var Indicator: UIActivityIndicatorView!
    
    @IBAction func Done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadFirstAid(){
        let requestFirstAidURL = NSURL (string: "http://www.zoo.gov.taipei/ct.asp?xItem=71113374&ctNode=70620&mp=104031")
        let requestFirstAid = NSURLRequest(URL: requestFirstAidURL!)
        myWebView.loadRequest(requestFirstAid)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myWebView.delegate=self
        loadFirstAid()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad (_ : UIWebView) {
        Indicator.startAnimating()
        print("start")
    }
    
    func webViewDidFinishLoad (_ : UIWebView) {
        Indicator.stopAnimating()
        print("finsh")
    }
}
