//
//  GDSocialVC.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 6/16/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class GDSocialVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Flurry.logEvent("Social")
        let del:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        del.window!.bringSubview(toFront: del.btn_PlayOrPause!)
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
    
    @IBAction func btnSocialPressed(_ sender: UIButton) {
        var strUrl = ""
        switch sender.tag {
        case 101:
            strUrl = "https://www.facebook.com/goldline"
        case 102:
            strUrl = "https://www.twitter.com/goldline"
        case 103:
            strUrl = "https://plus.google.com/100959463383362836825/posts"
        case 104:
            strUrl = "https://www.linkedin.com/company/goldline-international-inc/"
        case 105:
            strUrl = "https://www.youtube.com/user/goldlineint"
        default:
            break
        }
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "GDSocialWebPageVC") as! GDSocialWebPageVC
        VC.strLink = strUrl
        self.navigationController!.pushViewController(VC, animated: true)
        
    }
    
}
