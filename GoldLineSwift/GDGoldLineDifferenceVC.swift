//
//  GDGoldLineDifferenceVC.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 6/16/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class GDGoldLineDifferenceVC: UIViewController {
    
    @IBOutlet weak var scroll_Background: UIScrollView!
    @IBOutlet weak var browser: UIWebView!
    @IBOutlet weak var img_Coins: UIImageView!
    var soundManage: AFSoundManager!
    var home: URL!
    var finishCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Flurry.logEvent("Goldline Difference")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let del:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
        del.window!.bringSubview(toFront: del.btn_PlayOrPause!)
        
        scroll_Background.contentSize = CGSize(width: CGFloat(320), height: CGFloat(1960))
        self.browser.scalesPageToFit = true
        self.browser.contentMode = .scaleAspectFit
        self.browser.frame = CGRect(x: 0, y: 228, width: 320, height: 5000)
        self.img_Coins.frame = CGRect(x: 0, y: 0, width: 320, height: 225)
        
        let link = "https://www.goldline.com/iphone/goldline-difference.html"
        self.home = URL(string: link)
        self.go(to: home)
        soundManage = AFSoundManager.shared()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func clear() {
        print("clear")
        self.browser.loadHTMLString("<html></html>", baseURL: nil)
    }
    
    func go(to url: URL) {
        let req = URLRequest(url: url)
        self.browser.loadRequest(req)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //WebView Start accepet the request data.
        if navigationType == .linkClicked {
            print("\(request)")
        }
        return true
    }
    
    @IBAction func goBack(sender: Any)
    {
        browser.goBack()
    }
    @IBAction func goForward(sender: Any)
    {
        browser.goForward()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        var yourHTMLSourceCodeString = webView.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")
        
        yourHTMLSourceCodeString = yourHTMLSourceCodeString?.replacingOccurrences(of: "<body>", with: "<body style='font-family: \("System-Bold"); font-size: \(48); padding-right:20px; padding-left: 20px; text-align: justify;'>")
        
        if finishCount == 0 {
            yourHTMLSourceCodeString = yourHTMLSourceCodeString?.replacingOccurrences(of: ".GLDiff LI {margin:15px 0px;}", with: ".GLDiff LI {margin:30px 30px;}")
            webView.loadHTMLString(yourHTMLSourceCodeString!, baseURL: webView.request!.url!)
        } else if finishCount == 1 {
            img_Coins.isHidden = false
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        finishCount += 1
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
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
