//
//  GDAboutVC.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 6/16/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK


class GDAboutVC: UIViewController, UIWebViewDelegate {
       var home: URL!
    var del: AppDelegate!
    var soundManage: AFSoundManager!
    var isLoaded = false
    var finishCount = 0
    var isAlt = false

    @IBOutlet weak var browser: UIWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Flurry.logEvent("About Goldline")
        browser.scalesPageToFit = true
        browser.autoresizesSubviews = true
       self.browser.contentMode = .scaleAspectFit
        
        let link = "https://www.goldline.com/iphone/about-goldline.html?w=960&h=620"
        print(link)
        self.home = URL(string: link.addingPercentEscapes(using: String.Encoding.ascii)!)!
        self.go(to: home)
        
        del = UIApplication.shared.delegate! as! AppDelegate
        soundManage = AFSoundManager.shared()
             NotificationCenter.default.addObserver(self, selector: #selector(self.youTubeStarted), name: NSNotification.Name(rawValue: "UIMoviePlayerControllerDidEnterFullscreenNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.youTubFinished(_:)), name: NSNotification.Name(rawValue: "UIMoviePlayerControllerDidExitFullscreenNotification"), object: nil)
        
  self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let del:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
        del.window!.bringSubview(toFront: del.btn_PlayOrPause!)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
      
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "UIMoviePlayerControllerDidEnterFullscreenNotification"), object: nil);
        
        
    }

    func youTubeStarted(_ notification: Notification)
    {
        del.btn_PlayOrPause?.isHidden = true
        soundManage.pause()
    }
    
    func youTubFinished(_ notification: Notification)
    {
        if del.isAudioPlaying == false
        {
            del.btn_PlayOrPause?.isHidden = true
        }
        else
        {
         del.btn_PlayOrPause?.isHidden = false
            soundManage.resume()
        }
    }
    
    
    func clear()
    {
        print("clear")
        self.browser.loadHTMLString("<html></html>", baseURL: nil)
        
    }
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func go(to url: URL)
    {
        let req:NSURLRequest = URLRequest(url: url) as NSURLRequest
        self.browser.loadRequest(req as URLRequest)
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    @IBAction func goBack(_ sender: Any)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        browser.goBack()
    }
    
    @IBAction func goForward(_ sender: Any)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        browser.goForward()
    }


    //#pragma mark -Setting Data into WebView.

    

    func webViewDidFinishLoad(_ webView: UIWebView){
        isLoaded = true
        var yourHTMLSourceCodeString = webView.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")!
        yourHTMLSourceCodeString = "<span style=\"font-family: \("GothamRounded-Bold"); font-size: \(44)\">\(yourHTMLSourceCodeString)</span>"
        if finishCount == 0{
           webView.loadHTMLString(yourHTMLSourceCodeString, baseURL: webView.request!.url!)
        }
        else
        if finishCount == 2{
            self.browser.isHidden = false
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated:true)

    }
        finishCount += 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
