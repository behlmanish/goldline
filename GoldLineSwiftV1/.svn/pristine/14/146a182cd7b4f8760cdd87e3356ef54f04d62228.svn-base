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
    var itemDetail: NSDictionary?
    var data: NSMutableData?
    var str_Guid: String?
    var item: NSDictionary?
    var str_title: NSString?
    var str_Web: String?
    var finishCount: Int = 0
    var del: AppDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        Flurry.logEvent("Recent Industry News")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headingLabel.font = UIFont(name: "OpenSans-SemiBold", size: 18)
        del = UIApplication.shared.delegate as! AppDelegate?
        webView.delegate = self
        
//        _str_URL = [_str_URL stringByReplacingOccurrencesOfString:@"src=\"//www" withString:@"src=\"https://www"];
//        _str_URL = [_str_URL stringByReplacingOccurrencesOfString:@"width=\"560\"" withString:@"width=\"100%\""];
//        [self loadURL:[NSString stringWithFormat:@"https://www.goldline.com/iphone/news-detail.xml?nid=%@&w=302&h=280",self.str_Guid]];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeFinished:) name:@"UIMoviePlayerControllerWillExitFullscreenNotification" object:nil];
//        del.className = [NSString stringWithFormat:@"Industry News %@",self.str_title];
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setItem(i: [AnyHashable: Any])
    {
        item = i as NSDictionary!
        let link: String = (item!["curl"] as! String)
        _ = self.makeCloudRequest(link)
    }
    
    func makeCloudRequest(_ link: String) -> NSURLConnection {
        var connection: NSURLConnection!
        return connection
    } 
    
    func loadURL(_ strURL: String) {
        _ = TBXML(url: URL(string: strURL)!, success: { (tbxmlDocument) in
            if (tbxmlDocument?.rootXMLElement != nil) {
                self.traverseElement((tbxmlDocument?.rootXMLElement)!)
            } }, failure: { (tbxmlDocument, error) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: false)
                }
                print("XML Error \(error?.localizedDescription)")
        })
    }
    func traverseElement(_ element : UnsafeMutablePointer<TBXMLElement>) {
        TBXML.iterateElements(forQuery: "item", from: element) { (_ anElement) in
            var elem = anElement?.pointee.firstChild
            repeat {
                let name = String(cString: (elem?.pointee.text)!, encoding: .utf8)
                if name == "content" {
                    self.str_Web = String(cString: (elem?.pointee.text)!, encoding: .utf8)
                }
                elem = elem?.pointee.nextSibling
            } while (elem != nil)
        }
        webView.loadHTMLString(str_Web!, baseURL: nil)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func youTubeStarted(notification: NSNotification) {
        del?.btn_PlayOrPause.isHidden = true
        AFSoundManager.shared().pause()
    }
    
    func youTubeFinished(notification: NSNotification) {
        if !(del?.isAudioPlaying)! {
            del?.btn_PlayOrPause.isHidden = true
        } else {
            del?.btn_PlayOrPause.isHidden = false
            AFSoundManager.shared().resume()
        }
    }
    
//    func conn
//    
//    - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    
//    }
//    
//    - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
//    [self.data appendData: d];
//    }
//    
//    - (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    }
//    
//    - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//    {
//    
//    }
//    
//    #pragma mark Fire a request to the internet, checking for reachability first.
//    
//    -(NSURLConnection *) makeCloudRequest:(NSString *) link {
//    NSURLConnection *connection = nil;
//    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
//    [[[UIAlertView alloc] initWithTitle: @"Network Unreachable"
//    message: @"Network is not reachable. Please try again later."
//    delegate: nil
//    cancelButtonTitle: @"OK"
//    otherButtonTitles: nil] show];
//    else
//    {
//    self.data = [NSMutableData dataWithCapacity: 1024];
//    NSURL *url = [NSURL URLWithString: [link stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]];
//    NSURLRequest *req = [NSURLRequest requestWithURL: url];
//    connection = [NSURLConnection connectionWithRequest: req delegate: self];
//    }
//    return connection;
//    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        MBProgressHUD.hide(for: self.view, animated: true)
        var yourHTMLSourceCodeString = webView.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML")
        if finishCount == 0 {
            yourHTMLSourceCodeString = yourHTMLSourceCodeString?.replacingOccurrences(of: "]]&gt;", with: "")
            yourHTMLSourceCodeString = yourHTMLSourceCodeString?.replacingOccurrences(of: "width=\"420\"", with: "width=\"302\"")
            webView.loadHTMLString(yourHTMLSourceCodeString!, baseURL: webView.request?.url)
        }
        finishCount += 1
    }

}
