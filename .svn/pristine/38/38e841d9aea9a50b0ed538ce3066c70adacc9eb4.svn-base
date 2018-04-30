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
        //        self.navigationController!.setNavigationBarHidden(true, animated: false)
    }
    
    
    @IBAction func btnSocialPressed(_ sender: UIButton)
        
    {
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
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let VC: GDSocialWebPageVC = storyboard.instantiateViewCont   roller(withIdentifier: "GDSocialWebPageVC") as! GDSocialWebPageVC
        //        VC.strLink = strUrl
        //        self.present(VC, animated: true, completion: nil)
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let VC = storyboard?.instantiateViewController(withIdentifier: "GDSocialWebPageVC") as! GDSocialWebPageVC
        VC.strLink = strUrl
        self.navigationController!.pushViewController(VC, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
