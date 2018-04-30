//
//  GDBrochureDetailViewController.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 6/16/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit

class GDBrochureDetailViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var lbl_title: UILabel?
    @IBOutlet weak var mWebView: UIWebView?
    
    var str_title: String = String()
    var str_selectedLink: String = String()
    var hud = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mWebView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbl_title?.text = str_title
        let urlRequest = URLRequest(url: URL(string: str_selectedLink)!)
        mWebView?.loadRequest(urlRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
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
