//
//  GDPressReleaseDetailVC.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 6/16/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class GDPressReleaseDetailVC: UIViewController {
    var str_Guid:String!

    override func viewDidLoad() {
        super.viewDidLoad()
      Flurry.logEvent("Press Center")
        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}