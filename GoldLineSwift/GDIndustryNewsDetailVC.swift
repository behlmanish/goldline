//
//  GDIndustryNewsDetailVC.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 6/16/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class GDIndustryNewsDetailVC: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var webView: UIWebView!
    
   var str_URL: String?
   var str_Guid: String?
   var item: NSDictionary?
   var str_title: NSString?

    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        webView.loadRequest(NSURLRequest(url: NSURL(string: str_URL!)! as URL) as URLRequest)

    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
     MBProgressHUD.hide(for: self.view, animated: true)

    }

    @IBAction func callNowFunction(_ sender: Any) {
        let device = UIDevice.current
        if (device.model == "iPhone") {
            let stringURL: String = "telprompt://8003185505"
            UIApplication.shared.openURL(URL(string: stringURL)!)
        } else {
            UIAlertView(title: "", message: "Device not supporting calling functionality", delegate: nil, cancelButtonTitle: "", otherButtonTitles: "Ok").show()
        }
    }
}
