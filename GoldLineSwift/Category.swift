//
//  Category.swift
//  GoldLineSwift
//
//  Created by Arvind Durgam on 12/15/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import Foundation
extension UIViewController {
    @IBAction func btnSliderPressed(_ sender: AnyObject){
        let btn = (sender as! UIButton)
        self.view.endEditing(true)
        
        if btn.isSelected == false {
            let del:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
            del.btn_PlayOrPause?.isHidden = true
        }else{
            btn.isSelected = true
            let del:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
            if del.isAudioPlaying == false{
                del.btn_PlayOrPause?.isHidden = true
            }
            else{
                del.btn_PlayOrPause?.isHidden = false
            }
        }
        AppDelegate.globalDelegate().toggleLeftDrawer(self, animated: true)
    }
    
    func drawerAnimator() -> JVFloatingDrawerSpringAnimator{
        return AppDelegate.globalDelegate().drawerAnimater
    }
    
    @IBAction func callNow(_ sender: UIButton) {
        let nuber = "8003185505"
        
        if let url = NSURL(string: "tel://\(nuber)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)

        }
    }
    @IBAction func backButton(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
