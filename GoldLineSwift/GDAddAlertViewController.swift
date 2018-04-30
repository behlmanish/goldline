//
//  GDAddAlertViewController.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 6/16/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit

class GDAddAlertViewController: UIViewController,UITextFieldDelegate {
    var currentField: UITextField?
    var Str_metalName:String = ""
    
    @IBOutlet weak var lbl_metalName: UILabel!
    @IBOutlet weak var lbl_metalPrice: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var mView_bg: UIView!
    @IBOutlet weak var btn_spikeUp: UIButton!
    @IBOutlet weak var btn_spikeDown: UIButton!
    @IBOutlet weak var txt_spikeUp: UITextField!
    @IBOutlet weak var txt_spikeDown: UITextField!
    @IBOutlet weak var btn_dailyGain: UIButton!
    @IBOutlet weak var txt_dailyGain: UITextField!
    @IBOutlet weak var btn_dailyLoss: UIButton!
    @IBOutlet weak var txt_dailyLoss: UITextField!
    @IBOutlet weak var btn_priceLimit: UIButton!
    @IBOutlet weak var txt_priceLimit: UITextField!
    
    var str_alertName:String = ""
    var str_percentage:String = ""
    var str_trackAct: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let mview = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(40)))
        mview.backgroundColor = UIColor.gray
        let btn_done = UIButton(type:.custom)
        btn_done.frame = CGRect(x:CGFloat(self.view.frame.size.width-70), y: CGFloat(2), width:CGFloat(50), height: CGFloat(35))
        btn_done.setTitle("Done", for: .normal)
        btn_done.addTarget(self, action:#selector(self.confirmvalue), for: .touchUpInside)
        mview.addSubview(btn_done)
        self.txt_spikeUp.inputAccessoryView = mview
        self.txt_spikeDown.inputAccessoryView = mview
        self.txt_dailyGain.inputAccessoryView = mview
        self.txt_dailyLoss.inputAccessoryView = mview
        self.txt_priceLimit.inputAccessoryView = mview
        self.btn_spikeUp.setImage(UIImage(named: "dot_btn_usl.png"), for: .normal)
        self.btn_spikeUp.setImage(UIImage(named: "dot_btn_sl.png"), for: .selected)
        self.btn_spikeDown.setImage(UIImage(named: "dot_btn_usl.png"), for: .normal)
        self.btn_spikeDown.setImage(UIImage(named: "dot_btn_sl.png"), for: .selected)
        self.btn_dailyGain.setImage(UIImage(named: "dot_btn_usl.png"), for: .normal)
        self.btn_dailyGain.setImage(UIImage(named: "dot_btn_sl.png"), for: .selected)
        self.btn_dailyLoss.setImage(UIImage(named: "dot_btn_usl.png"), for: .normal)
        self.btn_dailyLoss.setImage(UIImage(named: "dot_btn_sl.png"), for: .selected)
        self.btn_priceLimit.setImage(UIImage(named: "dot_btn_usl.png"), for: .normal)
        self.btn_priceLimit.setImage(UIImage(named: "dot_btn_sl.png"), for: .selected)
        self.btn_spikeUp.isSelected = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.str_alertName = "spike_up"
        self.str_percentage = self.txt_spikeUp.text!
        
        let metalDict = UserDefaults.standard.object(forKey: "MetalDetails")  as! NSDictionary
        
        if (self.Str_metalName == "gold")
        {
            self.str_trackAct = "Add Gold Alert"
            print()
            self.lbl_metalPrice.text = "\(metalDict["Goldvalue"] as! String) / oz"
            self.lbl_metalName.text = "Current Gold Price"
            self.lbl_title.text = "Gold Alerts"
        }
        else if (self.Str_metalName == "silver")
        {
            self.str_trackAct = "Add Silver Alert"
            self.lbl_metalPrice.text = "\(metalDict["Silvervalue"] as! String) / oz"
            self.lbl_metalName.text = "Current Sliver Price"
            self.lbl_title.text = "Silver Alerts"
            
        }
        else if (self.Str_metalName == "platinum")
        {
            self.str_trackAct = "Add Platinum Alert"
            self.lbl_metalPrice.text = "\(metalDict["Palladiumvalue"] as! String) / oz"
            self.lbl_metalName.text = "Current Platinum Price"
            self.lbl_title.text = "Platinum Alerts"
            
        }
        else
            if (self.Str_metalName == "palladium")
            {
                self.str_trackAct = "Add Palladium Alert"
                self.lbl_metalPrice.text = "\(metalDict["Palladiumvalue"] as! String) / oz"
                self.lbl_metalName.text = "Current Palladium Price"
                self.lbl_title.text = "Palladium Alerts"
                
        }
        self.txt_spikeUp.isUserInteractionEnabled = true
        self.txt_spikeDown.isUserInteractionEnabled = false
        self.txt_dailyGain.isUserInteractionEnabled = false
        self.txt_dailyLoss.isUserInteractionEnabled = false
        self.txt_priceLimit.isUserInteractionEnabled = false
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        currentField?.resignFirstResponder()
    }
    
    @IBAction func confirmvalue(_ sender: UIButton)
    {
        currentField?.resignFirstResponder()
        self.setPercentage()
    }
    
    func setPercentage() {
        
        if (currentField == self.txt_spikeUp) {
            self.str_percentage = self.txt_spikeUp.text!
        } else if (currentField == self.txt_spikeDown) {
            self.str_percentage = self.txt_spikeDown.text!
        } else if (currentField == self.txt_dailyGain) {
            self.str_percentage = self.txt_dailyGain.text!
        } else if (currentField == self.txt_dailyLoss) {
            self.str_percentage = self.txt_dailyLoss.text!
        } else if (currentField == self.txt_priceLimit) {
            self.str_percentage = self.txt_priceLimit.text!
        }
    }
    
    @IBAction func ButtonSelectionAction(_ sender: UIButton)
    {
        currentField?.resignFirstResponder()
        self.txt_spikeUp.isUserInteractionEnabled = false
        self.txt_spikeDown.isUserInteractionEnabled = false
        self.txt_dailyGain.isUserInteractionEnabled = false
        self.txt_dailyLoss.isUserInteractionEnabled = false
        self.txt_priceLimit.isUserInteractionEnabled = false
        self.btn_spikeUp.isSelected = false
        self.btn_spikeDown.isSelected = false
        self.btn_dailyGain.isSelected = false
        self.btn_dailyLoss.isSelected = false
        self.btn_priceLimit.isSelected = false
        
        if (sender.tag == 1) {
            //spike up
            self.btn_spikeUp.isSelected = true
            self.txt_spikeUp.isUserInteractionEnabled = true
            self.txt_spikeUp.becomeFirstResponder()
            self.str_alertName = "spike_up"
        } else if (sender.tag == 2) {
            //spike down
            self.btn_spikeDown.isSelected = true
            self.txt_spikeDown.isUserInteractionEnabled = true
            self.txt_spikeDown.becomeFirstResponder()
            self.str_alertName = "spike_down"
        } else if (sender.tag == 3) {
            //daily gain
            self.btn_dailyGain.isSelected = true
            self.txt_dailyGain.isUserInteractionEnabled = true
            self.txt_dailyGain.becomeFirstResponder()
            self.str_alertName = "day_gain"
        } else if (sender.tag == 4) {
            //daily loss
            self.btn_dailyLoss.isSelected = true
            self.txt_dailyLoss.isUserInteractionEnabled = true
            self.txt_dailyLoss.becomeFirstResponder()
            self.str_alertName = "day_loss"
        } else if (sender.tag == 5) {
            self.btn_priceLimit.isSelected = true
            self.txt_priceLimit.isUserInteractionEnabled = true
            self.txt_priceLimit.becomeFirstResponder()
            self.str_alertName = "price_limit"
        } else if (sender.tag == 6) {
            self.str_alertName = "spike_up"
            self.str_percentage = self.txt_spikeUp.text!
            self.btn_spikeUp.isSelected = true
            self.txt_spikeUp.text = "0.1"
            self.txt_spikeUp.isUserInteractionEnabled = true
        } else if (sender.tag == 7) {
            //submit
            if (self.str_alertName == "") {
                let alertController = UIAlertController(title: "Alert", message: "Please select alert type first.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okButton)
                self.present(alertController, animated: true)
            } else {
                self.setPercentage()
                self.AddAlert(self.str_alertName, AlertRatio: self.str_percentage)
            }
        } else if (sender.tag == 8) {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        self.txt_spikeUp.text = ""
        self.txt_spikeDown.text = ""
        self.txt_dailyGain.text = ""
        self.txt_dailyLoss.text = ""
        self.txt_priceLimit.text = ""
    }
    
    //call service to addentries
    func AddAlert(_ AlertName: String, AlertRatio: String)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let srt_saveToken = "https://www.goldline.com/iphone/api/services/index.php?action=NotificationType"
        let strupload = String(format:"uid=\(UserDefaults.standard.object(forKey: "UserID") as!  String)&metal=\(self.Str_metalName)&notification_type=\(AlertName)&notification_value=\(AlertRatio)&interval=\("immediate")&sound=\("default")&status=\("1")")
        let struploadData = strupload.replacingOccurrences(of: "Optional(", with: "", options: NSString.CompareOptions.literal, range:nil)
        let struploadValue = struploadData.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range:nil)
        let struploadValue2 = struploadValue.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil)
        WebServiceManger.requestUrl(srt_saveToken, withPostStr: struploadValue2, completion: {(result, response, error) -> (Void)
            in
            
            if  (error  == nil)
            {
                self.str_alertName = ""
                self.str_percentage = ""
                print("Device ID \(result)")
                let deviceData = result?.object(forKey: "message") as AnyObject
                
                if (deviceData as! String == "Success") {
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        _ =  self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        let alertController = UIAlertController(title: "Alert", message: "Some error occured. Please try again.", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "OK", style: .default)
                        alertController.addAction(okButton)
                        self.present(alertController, animated: true)
                    }
                }
            }
        })
    }
    
    //MARK - animate view
    func animate(_ textField: UITextField, up: Bool) {
        let movementDistance: Int = 60
        let movementDuration: Float = 0.3
        
        let movement: Int = (up ? -movementDistance : movementDistance)
        
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        UIView.setAnimationDuration(TimeInterval(movementDuration))
        self.mView_bg.frame = self.mView_bg.frame.offsetBy(dx: CGFloat(0), dy: CGFloat(movement))
        UIView.commitAnimations()
    }
    
    
    //MARK: - UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currentField = textField
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentField = textField
        
        if (textField == self.txt_dailyGain || textField == self.txt_dailyLoss || textField == txt_priceLimit) {
            self.animate(textField, up: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.txt_dailyGain || textField == self.txt_dailyGain || textField == txt_priceLimit) {
            self.animate(textField, up: false)
        }
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