//
//  GDSettingsViewController.swift
//  GoldLineSwift
//
//  Created by Gaurav Singh Rawat on 05/06/17.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit

class GDSettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var dict_alertName = [AnyHashable: Any]()
    var str_titleName: String = ""
    
    @IBOutlet weak var tableview_Settings: UITableView!
    @IBOutlet weak var mview_alert: UIView!
    @IBOutlet weak var btn_enterTitle: UIButton!
    @IBOutlet weak var btn_enetrPercent: UIButton!
    @IBOutlet weak var tbl_titleList: UITableView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var switchEnableDisableAlert: UISwitch!
    
    var arr_goldAlert: NSMutableArray = NSMutableArray()
    var arr_SilverAlert: NSMutableArray = NSMutableArray()
    var arr_PlatinumAlert: NSMutableArray = NSMutableArray()
    var arr_PalladiumAlert: NSMutableArray = NSMutableArray()
    
    var str_dropDownType: String = ""
    var str_metalName: String = ""
    var str_alertType: String = ""
    var str_notifyStatus: String = ""
    var arr_alertTitle: NSMutableArray = NSMutableArray()
    var arr_alertPercent: NSMutableArray = NSMutableArray()
    var arr_alertPriceLimit: NSMutableArray = NSMutableArray()
    
    //MARK:- UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview_Settings.tableFooterView = UIView(frame: CGRect.zero)
        self.arr_alertPercent = ["0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9", "1.0", "1.1", "1.2", "1.3", "1.4", "1.5", "1.6", "1.7", "1.8", "1.9", "2.0", "2.1", "2.2", "2.3", "2.4", "2.5", "2.6", "2.7", "2.8", "2.9", "3.0", "3.1", "3.2", "3.3", "3.4", "3.5", "3.6", "3.7", "3.8", "3.9", "4.0", "4.1", "4.2", "4.3", "4.4", "4.5", "4.6", "4.7", "4.8", "4.9", "5.0"]
        dict_alertName = [AnyHashable: Any]()
        dict_alertName["spike_up"] = "Spike Up"
        dict_alertName["spike_down"] = "Spike Down"
        dict_alertName["day_gain"] = "Day Gain"
        dict_alertName["day_loss"] = "Day Loss"
        dict_alertName["price_limit"] = "Price Limit"
        // Save spike_up, spike_down, day_gain, day_loss, price_limit dat in Array
        
        self.arr_alertTitle = ["spike_up", "spike_down", "day_gain", "day_loss", "price_limit"]
        self.arr_alertPriceLimit = ["1000", "2000", "3000", "4000", "5000", "6000", "7000", "8000", "9000", "10000"]
        self.mview_alert.layer.cornerRadius = 5.0
        self.mview_alert.layer.masksToBounds = true
        self.tbl_titleList.layer.cornerRadius = 2.0
        self.tbl_titleList.layer.borderColor = UIColor(red: CGFloat(251 / 255.0), green: CGFloat(222 / 255.0), blue: CGFloat(0), alpha: CGFloat(1)).cgColor
        self.tbl_titleList.layer.borderWidth = 1.5
        self.tbl_titleList.layer.masksToBounds = true
        self.btn_enetrPercent.layer.borderColor = UIColor(red: CGFloat(251 / 255.0), green: CGFloat(222 / 255.0), blue: CGFloat(0), alpha: CGFloat(1)).cgColor
        self.btn_enetrPercent.layer.borderWidth = 1.5
        self.btn_enterTitle.layer.borderColor = UIColor(red: CGFloat(251 / 255.0), green: CGFloat(222 / 255.0), blue: CGFloat(0), alpha: CGFloat(251 / 255.0)).cgColor
        self.btn_enterTitle.layer.borderWidth = 1.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)// Do any additional setup after loading the view.
        self.callServiceToGetAllAlerts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- IBACtion
    @IBAction func enableAlertMethod(_ sender: UISwitch)
    {
        var str_notify: String = ""
        
        if (sender.isOn){
            print("is notify On")
            self.str_notifyStatus = "1"
            str_notify = "1"
        } else {
            print("is notify Off")
            self.str_notifyStatus = "0"
            str_notify = "0"
            
        }
        self.callServiceForUpdate(strUpdatevalue: str_notify as NSString)
    }
    
    //MARK:- UITableView
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == self.tbl_titleList{
            return 1
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == self.tbl_titleList {
            if (self.str_dropDownType == "title") {
                return dict_alertName.count
            }
            else if (self.str_dropDownType == "percentage") {
                return self.arr_alertPercent.count
            }
        }
        
        if section == 0{
            return arr_goldAlert.count
        } else if section == 1{
            return arr_SilverAlert.count
        } else if section == 2 {
            return arr_PlatinumAlert.count
        } else{
            return arr_PalladiumAlert.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if tableView == self.tbl_titleList{
            return 0
        }
        if section == 0 {
            return 40
        } else if section == 1 || section == 2 || section == 3 {
            return 60
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        var sectionHeaderView: UIView?
        if tableView == self.tbl_titleList{
            return sectionHeaderView!
        }
        sectionHeaderView = UIView(frame: CGRect(x:                                                                                                                                                                                                                                                       CGFloat(0), y: CGFloat(0), width: CGFloat(tableView.frame.size.width), height: CGFloat(50.0)))
        
        sectionHeaderView?.backgroundColor = UIColor(red: CGFloat(238 / 255.0), green: CGFloat(239 / 255.0), blue: CGFloat(244 / 255.0), alpha: CGFloat(1))
        
        if section == 0 {
            let label = UILabel(frame: CGRect(x: CGFloat(15), y: CGFloat(15), width: CGFloat(200), height: CGFloat(25)))
            label.text = "GOLD ALERTS"
            label.font = UIFont.systemFont(ofSize: CGFloat(14))
            label.textColor = UIColor.gray
            sectionHeaderView?.addSubview(label)
        } else if section == 1 {
            let label = UILabel(frame: CGRect(x: CGFloat(15), y: CGFloat(30), width: CGFloat(200), height: CGFloat(25)))
            label.text = "SILVER ALERTS"
            label.font = UIFont.systemFont(ofSize: CGFloat(14))
            label.textColor = UIColor.gray
            sectionHeaderView?.addSubview(label)
        }else if section == 2 {
            let label = UILabel(frame: CGRect(x: CGFloat(15), y:CGFloat(30), width: CGFloat(200), height: CGFloat(25)))
            label.text = "PLATINUM ALERTS"
            label.font = UIFont.systemFont(ofSize: CGFloat(14))
            label.textColor = UIColor.gray
            sectionHeaderView?.addSubview(label)
        }else {
            let label = UILabel(frame: CGRect(x: CGFloat(15), y:CGFloat(30), width: CGFloat(200), height: CGFloat(25)))
            label.text = "PALLADIUM ALERTS"
            label.font = UIFont.systemFont(ofSize: CGFloat(14))
            label.textColor = UIColor.gray
            sectionHeaderView?.addSubview(label)
        }
        
        return sectionHeaderView!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexpath: IndexPath) -> UITableViewCell {
        let simpletableIdentifier: String = "SimpleTableItem"
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: simpletableIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style:.default, reuseIdentifier: simpletableIdentifier)
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.none
        
        if tableView == self.tbl_titleList
        {
            cell.textLabel?.font = UIFont(name: "Helvetica-BoldOblique", size: CGFloat(13))
            if (self.str_dropDownType == "title")
            {
                cell.textLabel?.text = dict_alertName[indexpath.row] as! String?
                
            }else if (self.str_dropDownType == "percentage")
            {
                if (self.btn_enterTitle.titleLabel?.text == "Price Limit") {
                    cell.textLabel?.text = self.arr_alertPercent[indexpath.row] as? String
                }else {
                    cell.textLabel?.text = self.arr_alertPercent[indexpath.row] as? String
                }
            }
            return cell
        }
        cell.contentView.backgroundColor = UIColor.white
        
        for i in cell.contentView.subviews {
            i.removeFromSuperview()
        }
        
        if (indexpath.section == 0) {
            
            let btn_Add = UIButton(type: .custom) as UIButton
            btn_Add.frame = CGRect(x: CGFloat(10), y: CGFloat(8), width: CGFloat(30), height: CGFloat(30))
            btn_Add.addTarget(self, action: #selector(self.addorRemoveGoldAlerts(button:)), for: .touchUpInside)
            btn_Add.clipsToBounds = true
            btn_Add.layer.cornerRadius = 15
            btn_Add.tag = 10000 + indexpath.row
            cell.contentView.addSubview(btn_Add)
            
            if (indexpath.row == arr_goldAlert.count - 1)
            {
                btn_Add.setImage(UIImage(named: "plus_circle"), for: .normal)
                let label = UILabel(frame: CGRect(x: CGFloat(50), y: CGFloat(9), width: CGFloat(150), height: CGFloat(25)))
                
                label.text = ((arr_goldAlert[indexpath.row] as AnyObject)["notification_type"] as! String)
                label.font = UIFont.systemFont(ofSize: CGFloat(12))
                cell.contentView.addSubview(label)
                btn_Add.isUserInteractionEnabled = false
                
            } else {
                btn_Add.setImage(UIImage(named: "minus_circle"), for: .normal)
                
                let labelTitle = UILabel(frame: CGRect(x: CGFloat(50), y: CGFloat(9), width: CGFloat(150), height: CGFloat(25)))
                
                let str_t: String = ((arr_goldAlert[indexpath.row] as AnyObject)["notification_type"] as? String)!
                labelTitle.text = str_t.replacingOccurrences(of: "_", with: " ")
                labelTitle.font = UIFont.systemFont(ofSize: CGFloat(12))
                cell.contentView.addSubview(labelTitle)
                let labelPercent = UILabel(frame: CGRect(x: CGFloat(210), y: CGFloat(9), width: CGFloat(70), height: CGFloat(25)))
                labelPercent.textAlignment = .right
                
                
                if (((arr_goldAlert[indexpath.row] as AnyObject)["notification_type"] as? String) == "price_limit")
                {
                    labelPercent.text = "\((arr_goldAlert[indexpath.row] as AnyObject)["percent"] as! String) $"
                    
                }
                else{
                    labelPercent.text = "\((arr_goldAlert[indexpath.row] as AnyObject)["percent"] as! String) %"
                    
                }
                
                labelPercent.font = UIFont.systemFont(ofSize: CGFloat(12))
                
                labelPercent.textColor = UIColor.gray
                cell.contentView.addSubview(labelPercent)
                
                cell.accessoryType = .disclosureIndicator
                
            }
        } else if (indexpath.section == 1) {
            let btn_Add: UIButton = UIButton(type: .custom) as UIButton
            btn_Add.frame = CGRect(x: CGFloat(10), y: CGFloat(8), width: CGFloat(30), height: CGFloat(30))
            btn_Add.layer.cornerRadius = 15
            btn_Add.addTarget(self, action: #selector(self.addorRemoveSilverAlerts(button:)), for: .touchUpInside)
            btn_Add.tag = 10000 + indexpath.row
            cell.contentView.addSubview(btn_Add)
            
            if indexpath.row == arr_SilverAlert.count - 1
            {
                btn_Add.setImage(UIImage(named: "plus_circle"), for: .normal)
                let label = UILabel(frame: CGRect(x: CGFloat(50), y: CGFloat(9), width: CGFloat(150), height: CGFloat(25)))
                label.text = (arr_SilverAlert[indexpath.row] as AnyObject)["notification_type"] as? String
                label.font = UIFont.systemFont(ofSize: CGFloat(12))
                cell.contentView.addSubview(label)
                btn_Add.isUserInteractionEnabled = false
                
            } else{
                btn_Add.setImage(UIImage(named: "minus_circle"), for: .normal)
                let labelTitle = UILabel(frame: CGRect(x: CGFloat(50), y: CGFloat(9), width: CGFloat(150), height: CGFloat(25)))
                let str_t: String = ((arr_SilverAlert[indexpath.row] as AnyObject)["notification_type"] as? String)!
                
                labelTitle.text = str_t.replacingOccurrences(of: "_", with: " ")
                labelTitle.font = UIFont.systemFont(ofSize: CGFloat(12))
                cell.contentView.addSubview(labelTitle)
                let labelPercent = UILabel(frame: CGRect(x: CGFloat(210), y: CGFloat(9), width: CGFloat(70), height: CGFloat(25)))
                labelPercent.textAlignment = .right
                
                if (((arr_SilverAlert[indexpath.row] as AnyObject)["notification_type"] as? String) == "price_limit")
                {
                    labelPercent.text = "\((arr_SilverAlert[indexpath.row] as AnyObject)["percent"] as! String) $"
                    
                }
                else{
                    labelPercent.text = "\((arr_SilverAlert[indexpath.row] as AnyObject)["percent"] as! String) %"
                    
                }
                labelPercent.font = UIFont.systemFont(ofSize: CGFloat(12))
                labelPercent.textColor = UIColor.gray
                cell.contentView.addSubview(labelPercent)
                cell.accessoryType = .disclosureIndicator
            }
        } else if (indexpath.section == 2) {
            let btn_Add: UIButton = UIButton(type: .custom) as UIButton
            btn_Add.frame = CGRect(x: CGFloat(10), y: CGFloat(8), width: CGFloat(30), height: CGFloat(30))
            btn_Add.clipsToBounds = true
            btn_Add.layer.cornerRadius = 15
            btn_Add.addTarget(self, action: #selector(self.addorRemovePlatinumAlerts), for: .touchUpInside)
            btn_Add.tag = 10000 + indexpath.row
            cell.contentView.addSubview(btn_Add)
            
            if (indexpath.row == arr_PlatinumAlert.count - 1)
            {
                btn_Add.setImage(UIImage(named: "plus_circle"), for: .normal)
                let label = UILabel(frame: CGRect(x: CGFloat(50), y: CGFloat(9), width: CGFloat(150), height: CGFloat(25)))
                
                label.text = (arr_PlatinumAlert[indexpath.row] as AnyObject)["notification_type"] as? String
                label.font = UIFont.systemFont(ofSize: CGFloat(12))
                cell.contentView.addSubview(label)
                btn_Add.isUserInteractionEnabled = false
                
            }
            else
            {
                btn_Add.setImage(UIImage(named: "minus_circle"), for: .normal)
                let labelTitle = UILabel(frame: CGRect(x: CGFloat(50), y: CGFloat(9), width: CGFloat(150), height: CGFloat(25)))
                let str_t: String? = (arr_PlatinumAlert[indexpath.row] as AnyObject)["notification_type"] as? String
                
                labelTitle.text = str_t?.replacingOccurrences(of: "_", with: " ")
                labelTitle.font = UIFont.systemFont(ofSize: CGFloat(12))
                cell.contentView.addSubview(labelTitle)
                let labelPercent = UILabel(frame: CGRect(x: CGFloat(210), y: CGFloat(9), width: CGFloat(70), height: CGFloat(25)))
                labelPercent.textAlignment = .right
                if (((arr_PlatinumAlert[indexpath.row] as AnyObject)["notification_type"] as! String) == "price_limit")
                {
                    labelPercent.text = "\((arr_PlatinumAlert[indexpath.row] as AnyObject)["percent"] as! String) $"
                }
                else{
                    labelPercent.text = "\((arr_PlatinumAlert[indexpath.row] as AnyObject)["percent"] as! String) %"
                }
                labelPercent.textColor = UIColor.gray
                labelPercent.font = UIFont.systemFont(ofSize: CGFloat(12))
                cell.contentView.addSubview(labelPercent)
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
        } else  {
            let btn_Add: UIButton = UIButton(type: .custom) as UIButton
            btn_Add.frame = CGRect(x: CGFloat(10), y: CGFloat(8), width: CGFloat(30), height: CGFloat(30))
            btn_Add.clipsToBounds = true
            btn_Add.layer.cornerRadius = 15
            btn_Add.addTarget(self, action: #selector(self.addorRemovePalladiumAlerts), for: .touchUpInside)
            btn_Add.tag = 10000 + indexpath.row
            cell.contentView.addSubview(btn_Add)
            
            if (indexpath.row == arr_PalladiumAlert.count - 1) {
                btn_Add.setImage(UIImage(named: "plus_circle"), for: .normal)
                let label = UILabel(frame: CGRect(x: CGFloat(50), y: CGFloat(9), width: CGFloat(150), height: CGFloat(25)))
                
                label.text = (arr_PalladiumAlert[indexpath.row] as AnyObject)["notification_type"] as? String
                label.font = UIFont.systemFont(ofSize: CGFloat(12))
                cell.contentView.addSubview(label)
                btn_Add.isUserInteractionEnabled = false
                
            } else {
                
                btn_Add.setImage(UIImage(named: "minus_circle"), for: .normal)
                let labelTitle = UILabel(frame: CGRect(x: CGFloat(50), y: CGFloat(9), width: CGFloat(150), height: CGFloat(25)))
                let str_t: String? = (arr_PalladiumAlert[indexpath.row] as AnyObject)["notification_type"] as? String
                
                labelTitle.text = str_t?.replacingOccurrences(of: "_", with: " ")
                labelTitle.font = UIFont.systemFont(ofSize: CGFloat(12))
                cell.contentView.addSubview(labelTitle)
                let labelPercent = UILabel(frame: CGRect(x: CGFloat(210), y: CGFloat(9), width: CGFloat(70), height: CGFloat(25)))
                labelPercent.textAlignment = .right
                
                
                if (((arr_PalladiumAlert[indexpath.row] as AnyObject)["notification_type"] as! String) == "price_limit")
                {
                    labelPercent.text = "\((arr_PalladiumAlert[indexpath.row] as AnyObject)["percent"] as! String) $"
                }
                else{
                    labelPercent.text = "\((arr_PalladiumAlert[indexpath.row] as AnyObject)["percent"] as! String) %"
                }
                labelPercent.textColor = UIColor.gray
                labelPercent.font = UIFont.systemFont(ofSize: CGFloat(12))
                cell.contentView.addSubview(labelPercent)
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.isOpaque = true
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tbl_titleList
        {
            if (self.str_dropDownType == "title")
            {
                str_titleName = dict_alertName[indexPath.row] as! String
                self.btn_enterTitle.setTitle(dict_alertName[indexPath.row] as! String?, for: .normal)
            }
            else
                if (self.str_dropDownType == "percentage")
                {
                    if(self.btn_enterTitle.titleLabel?.text == "Price Limit")
                    {
                        self.btn_enetrPercent.setTitle(arr_alertPriceLimit[indexPath.row] as? String, for: .normal)
                    } else {
                        self.btn_enetrPercent.setTitle(self.arr_alertPercent[indexPath.row] as? String, for: .normal)
                    }
            }
            self.tbl_titleList.isHidden = true
            return
        }
        
        let obj_setNotify:GDSetNotificationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "GDSetNotificationViewController") as? GDSetNotificationViewController)!
        let obj_addAlert:GDAddAlertViewController = (self.storyboard?.instantiateViewController(withIdentifier: "GDAddAlertViewController") as? GDAddAlertViewController)!
        
        if (indexPath.section == 0)
        {
            self.str_metalName = "gold"
            self.str_alertType = "Gold Alert"
            
            if (indexPath.row == arr_goldAlert.count-1)
            {
                obj_addAlert.Str_metalName = "gold"
                self.navigationController?.pushViewController(obj_addAlert, animated: true)
            }
            else
            {
                
                obj_setNotify.str_alertName = ((arr_goldAlert[indexPath.row]as AnyObject)["notification_type"] as! String)
                obj_setNotify.str_alertPercent = ((arr_goldAlert[indexPath.row] as AnyObject)["percent"] as! String)
                UserDefaults.standard.set(((arr_goldAlert[indexPath.row] as AnyObject)["status"] as! String), forKey: "status")
                UserDefaults.standard.set(((arr_goldAlert[indexPath.row] as AnyObject)["sound"] as! String), forKey: "SelectedSound")
                UserDefaults.standard.set(((arr_goldAlert[indexPath.row] as AnyObject)["interval"] as! String), forKey: "selectedValue")
                UserDefaults.standard.set(((arr_goldAlert[indexPath.row] as AnyObject)["id"] as! String), forKey: "id")
                self.navigationController?.pushViewController(obj_setNotify, animated: true)
                
            }
        } else if (indexPath.section == 1)
        {
            self.str_metalName = "silver"
            if (indexPath.row == arr_SilverAlert.count-1)
            {
                obj_addAlert.Str_metalName = "silver"
                self.navigationController?.pushViewController(obj_addAlert, animated: true)
            }
            else
            {
                obj_setNotify.str_alertName = ((arr_SilverAlert[indexPath.row] as AnyObject)["notification_type"] as! String)
                obj_setNotify.str_alertPercent = ((arr_SilverAlert[indexPath.row] as AnyObject)["percent"] as! String)
                UserDefaults.standard.set(((arr_SilverAlert[indexPath.row] as AnyObject)["status"] as! String), forKey: "status")
                UserDefaults.standard.set(((arr_SilverAlert[indexPath.row] as AnyObject)["sound"] as! String), forKey: "SelectedSound")
                UserDefaults.standard.set(((arr_SilverAlert[indexPath.row] as AnyObject)["interval"] as! String), forKey: "selectedValue")
                UserDefaults.standard.set(((arr_SilverAlert[indexPath.row] as AnyObject)["id"] as! String), forKey: "id")
                self.navigationController?.pushViewController(obj_setNotify, animated: true)
            }
        } else if (indexPath.section == 2) {
            self.str_metalName = "platinum"
            
            if (indexPath.row==arr_PlatinumAlert.count-1)
            {
                obj_addAlert.Str_metalName = "platinum"
                self.navigationController?.pushViewController(obj_addAlert, animated: true)
            }
            else
            {
                obj_setNotify.str_alertName = ((arr_PlatinumAlert[indexPath.row] as AnyObject)["notification_type"] as! String)
                obj_setNotify.str_alertPercent = ((arr_PlatinumAlert[indexPath.row] as AnyObject)["percent"] as! String)
                UserDefaults.standard.set(((arr_PlatinumAlert[indexPath.row] as AnyObject)["status"] as! String), forKey: "status")
                UserDefaults.standard.set(((arr_PlatinumAlert[indexPath.row] as AnyObject)["sound"] as! String), forKey: "SelectedSound")
                UserDefaults.standard.set(((arr_PlatinumAlert[indexPath.row] as AnyObject)["interval"] as! String), forKey: "selectedValue")
                UserDefaults.standard.set(((arr_PlatinumAlert[indexPath.row] as AnyObject)["id"] as! String), forKey: "id")
                self.navigationController?.pushViewController(obj_setNotify, animated: true)
                
            }
        } else if (indexPath.section == 3) {
            self.str_metalName = "palladium"
            
            if (indexPath.row==arr_PalladiumAlert.count-1)
            {
                obj_addAlert.Str_metalName = "palladium"
                self.navigationController?.pushViewController(obj_addAlert, animated: true)
            }
            else
            {
                obj_setNotify.str_alertName = ((arr_PalladiumAlert[indexPath.row] as AnyObject)["notification_type"] as! String)
                UserDefaults.standard.set(((arr_PalladiumAlert[indexPath.row] as AnyObject)["status"] as! String), forKey: "status")
                obj_setNotify.str_alertPercent = ((arr_PalladiumAlert[indexPath.row] as AnyObject)["percent"] as! String)
                UserDefaults.standard.set(((arr_PalladiumAlert[indexPath.row] as AnyObject)["sound"] as! String), forKey: "SelectedSound")
                UserDefaults.standard.set(((arr_PalladiumAlert[indexPath.row] as AnyObject)["interval"] as! String), forKey: "selectedValue")
                UserDefaults.standard.set(((arr_PalladiumAlert[indexPath.row] as AnyObject)["id"] as! String), forKey: "id")
                self.navigationController?.pushViewController(obj_setNotify, animated: true)
            }
        }
        
        self.lbl_title.text = self.str_alertType
        self.tbl_titleList.isHidden = true
        str_titleName = ""
        self.btn_enetrPercent.setTitle("", for: UIControlState.normal)
        self.btn_enterTitle.setTitle("", for: UIControlState.normal)
        
        UserDefaults.standard.synchronize()
    }
    
    
    //MARK:- Local Methods
    func callServiceToGetAllAlerts()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        //let srt_saveToken = "https://www.goldline.com/iphone/api/services/index.php?uid=\(UserDefaults.standard.object(forKey: "UserID") as!  String)&action=getNotifications"
        
        let srt_saveToken = "https://www.goldline.com/iphone/api/services/index.php?uid=\(UserDefaults.standard.object(forKey: "UserID") as!  String)&action=getNotifications"
        WebServiceManger.requestUrl(srt_saveToken, completion: { (result, response , error) -> (Void) in
            if (error == nil) {
                
                print(result)
                let res = result as! NSDictionary
                self.arr_goldAlert.removeAllObjects()
                self.arr_PalladiumAlert.removeAllObjects()
                self.arr_PlatinumAlert.removeAllObjects()
                self.arr_SilverAlert.removeAllObjects()
                
                if ((res["message"] as! String) == "Success" ) {
                    
                    if (res["status_type"] as? String) == "1" {
                        self.str_notifyStatus = "1"
                        self.switchEnableDisableAlert.isOn = true
                    } else {
                        self.str_notifyStatus = "0"
                        self.switchEnableDisableAlert.isOn = false
                    }
                    
                    let resData = res["data"] as! NSArray
                    
                    for i in 0..<resData.count {
                        if ((resData[i] as! NSDictionary)["metal"] as! String) == "gold" {
                            let mutDict = NSMutableDictionary()
                            mutDict.setObject(((resData[i] as! NSDictionary)["notification_type"] as! String), forKey: "notification_type" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["notification_value"] as! String), forKey: "percent" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["id"] as! String), forKey: "id" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["sound"] as! String), forKey: "sound" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["interval"] as! String), forKey: "interval" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["status"] as! String), forKey: "status" as NSCopying)
                            self.arr_goldAlert.insert(mutDict, at: 0)
                        }
                        if ((resData[i] as! NSDictionary)["metal"] as! String) == "platinum" {
                            let mutDict = NSMutableDictionary()
                            mutDict.setObject(((resData[i] as! NSDictionary)["notification_type"] as! String), forKey: "notification_type" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["notification_value"] as! String), forKey: "percent" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["id"] as! String), forKey: "id" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["sound"] as! String), forKey: "sound" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["interval"] as! String), forKey: "interval" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["status"] as! String), forKey: "status" as NSCopying)
                            self.arr_PlatinumAlert.insert(mutDict, at: 0)
                        }
                        if ((resData[i] as! NSDictionary)["metal"] as! String) == "palladium" {
                            let mutDict = NSMutableDictionary()
                            mutDict.setObject(((resData[i] as! NSDictionary)["notification_type"] as! String), forKey: "notification_type" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["notification_value"] as! String), forKey: "percent" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["id"] as! String), forKey: "id" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["sound"] as! String), forKey: "sound" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["interval"] as! String), forKey: "interval" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["status"] as! String), forKey: "status" as NSCopying)
                            self.arr_PalladiumAlert.insert(mutDict, at: 0)
                        }
                        if ((resData[i] as! NSDictionary)["metal"] as! String) == "silver" {
                            let mutDict = NSMutableDictionary()
                            mutDict.setObject(((resData[i] as! NSDictionary)["notification_type"] as! String), forKey: "notification_type" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["notification_value"] as! String), forKey: "percent" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["id"] as! String), forKey: "id" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["sound"] as! String), forKey: "sound" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["interval"] as! String), forKey: "interval" as NSCopying)
                            mutDict.setObject(((resData[i] as! NSDictionary)["status"] as! String), forKey: "status" as NSCopying)
                            self.arr_SilverAlert.insert(mutDict, at: 0)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.addArrayLastObject()
                self.tableview_Settings.reloadData()
            }
        })
    }
    
    func addAlert(_ alertname: String, _ alertRatio: String) {
        
        let srt_saveToken = "https://www.goldline.com/iphone/api/services/index.php?action=NotificationType"
        let strupload = "uid=\(UserDefaults.standard.object(forKey: "UserID") as!  String)&metal=\(str_metalName)&notification_type=\(alertname)&notification_value=\(alertRatio)&interval=immediate&sound=default&status=1"
        let strpostlength = strupload.characters.count
        var urlrequest = URLRequest(url: URL(string: srt_saveToken)!)
        urlrequest.httpMethod = "POST"
        urlrequest.setValue(String(strpostlength), forHTTPHeaderField: "Content-length")
        urlrequest.httpBody = strupload.data(using: .utf8)
        
        NSURLConnection.sendAsynchronousRequest(urlrequest, queue: .main) { (response, data, error) in
            if (error != nil) {
                print("Error: \(error?.localizedDescription)")
                return
            }
            
            do{
                let res: [AnyHashable: Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [AnyHashable: Any]
                print("result: \(res)")
            } catch {
                print("Catch Erorr")
            }
        }
    }
    //CallServiceForUpdate
    
    func callServiceForUpdate(strUpdatevalue: NSString)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let srt_saveToken = "https://www.goldline.com/iphone/api/services/index.php?uid=\(UserDefaults.standard.object(forKey: "UserID") as!  String)&status=\(strUpdatevalue)&action=enableDisableNotifications"
        
        var urlrequest = URLRequest(url: URL(string: srt_saveToken)!)
        urlrequest.httpMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(urlrequest, queue: .main) { (response, data, error) in
            
            if (error != nil) {
                print("Error: \(error?.localizedDescription)")
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            do {
                let res: [AnyHashable: Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [AnyHashable: Any]
                print("result of all types of alert \(res)")
                MBProgressHUD.hide(for: self.view, animated: true)
                let alertController = UIAlertController(title: "Alert", message: res["message"] as?  String, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okButton)
                self.present(alertController, animated: true)
            } catch {
                print("Catch Block Error")
            }
        }
    }
    
    func callServiceForDeleteAlert(_ ID: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let srt_saveToken = "https://www.goldline.com/iphone/api/services/index.php?id=\(ID)&action=deleteNotification"
        var urlRequest = URLRequest(url: URL(string: srt_saveToken)!)
        urlRequest.httpMethod = "GET"
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: .main) { (response, data, error) in
            
            if error != nil {
                print("Error: \(error?.localizedDescription)")
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            
            do {
                let res: [AnyHashable: Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [AnyHashable: Any]
                print("result of all types of alert \(res)")
                MBProgressHUD.hide(for: self.view, animated: true)
                let alertController = UIAlertController(title: "Alert", message: (res["message"] as? String), preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okButton)
                self.present(alertController, animated: true)
            } catch {
                print("Catch Block Error")
            }
        }
    }
    
    func addorRemoveGoldAlerts(button: UIButton)
    {
        let row = button.tag - 10000
        print("Row: \(row)")
        self.str_metalName = "gold"
        self.str_alertType = "Gold Alert"
        
        if row != (arr_goldAlert.count - 1) {
            self.callServiceForDeleteAlert(Int((arr_goldAlert[row] as! NSDictionary).value(forKey: "id") as! String)!)
            arr_goldAlert.removeObject(at: row)
            tableview_Settings.reloadData()
        }
    }
    
    func addorRemoveSilverAlerts(button: UIButton)
    {
        let row = button.tag - 10000
        print("Row: \(row)")
        self.str_metalName = "silver"
        self.str_alertType = "Silver Alert"
        
        if row != (arr_SilverAlert.count - 1) {
            self.callServiceForDeleteAlert(Int((arr_SilverAlert[row] as! NSDictionary).value(forKey: "id") as! String)!)
            arr_SilverAlert.removeObject(at: row)
            tableview_Settings.reloadData()
        }
    }
    
    func addorRemovePlatinumAlerts(button: UIButton)
    {
        let row = button.tag - 10000
        print("Row: \(row)")
        self.str_metalName = "palladium"
        self.str_alertType = "Palladium Alert"
        
        if row != (arr_PlatinumAlert.count - 1) {
            self.callServiceForDeleteAlert(Int((arr_PlatinumAlert[row] as! NSDictionary).value(forKey: "id") as! String)!)
            //            self.callServiceForDeleteAlert((arr_PlatinumAlert[row] as! NSDictionary).value(forKey: "id") as! Int)
            arr_PlatinumAlert.removeObject(at: row)
            tableview_Settings.reloadData()
        }
    }
    
    func addorRemovePalladiumAlerts(button: UIButton)
    {
        let row = button.tag - 10000
        print("Row: \(row)")
        self.str_metalName = "platinum"
        self.str_alertType = "Platinum Alert"
        
        if row != (arr_PalladiumAlert.count - 1) {
            self.callServiceForDeleteAlert(Int((arr_PalladiumAlert[row] as! NSDictionary).value(forKey: "id") as! String)!)
            //            self.callServiceForDeleteAlert((arr_PalladiumAlert[row] as! NSDictionary).value(forKey: "id") as! Int)
            arr_PalladiumAlert.removeObject(at: row)
            tableview_Settings.reloadData()
        }
    }
    
    @IBAction func PerformSelectedAction(_ sender: UIButton) {
        
        if sender.tag == 1 {
            tbl_titleList.frame = CGRect(x: 107, y: 290, width: 190, height: 127)
            str_dropDownType = "title"
            tbl_titleList.isHidden = false
            tbl_titleList.reloadData()
        } else if sender.tag == 2 {
            tbl_titleList.frame = CGRect(x: 147, y: 330, width: 149, height: 120)
            str_dropDownType = "percentage"
            tbl_titleList.isHidden = false
            tbl_titleList.reloadData()
        } else if sender.tag == 3 {
            mview_alert.isHidden = true
        } else if sender.tag == 4 {
            tbl_titleList.isHidden = true
            mview_alert.isHidden = true
            
            if str_alertType == "Gold Alert" {
                str_metalName = "gold"
                let tilte: String = str_titleName
                let percent: String = btn_enetrPercent.currentTitle!
                
                if tilte.characters.count > 0 && percent.characters.count > 0{
                    let mutDict = NSMutableDictionary()
                    mutDict.setObject(tilte, forKey: "notification_type" as NSCopying)
                    mutDict.setObject(percent, forKey: "percent" as NSCopying)
                    mutDict.setObject("1111", forKey: "id" as NSCopying)
                    mutDict.setObject("Immediate", forKey: "selectedValue" as NSCopying)
                    mutDict.setObject("Default", forKey: "SelectedSound" as NSCopying)
                    arr_goldAlert.insert(mutDict, at: 0)
                    addAlert(tilte, percent)
                    print("Gold Array: \(arr_goldAlert)")
                    tableview_Settings.reloadData()
                } else {
                    let controller = UIAlertController(title: "Information", message: "Please Fill the Complete Details", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default)
                    controller.addAction(okButton)
                    present(controller, animated: true)
                }
            } else if str_alertType == "Silver Alert" {
                str_metalName = "silver"
                let tilte: String = str_titleName
                let percent: String = btn_enetrPercent.currentTitle!
                
                if tilte.characters.count > 0 && percent.characters.count > 0{
                    let mutDict = NSMutableDictionary()
                    mutDict.setObject(tilte, forKey: "notification_type" as NSCopying)
                    mutDict.setObject(percent, forKey: "percent" as NSCopying)
                    mutDict.setObject("1112", forKey: "id" as NSCopying)
                    mutDict.setObject("Immediate", forKey: "selectedValue" as NSCopying)
                    mutDict.setObject("Default", forKey: "SelectedSound" as NSCopying)
                    arr_SilverAlert.insert(mutDict, at: 0)
                    addAlert(tilte, percent)
                    print("Silver Array: \(arr_SilverAlert)")
                    tableview_Settings.reloadData()
                } else {
                    let controller = UIAlertController(title: "Information", message: "Please Fill the Complete Details", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default)
                    controller.addAction(okButton)
                    present(controller, animated: true)
                }
            } else if str_alertType == "Platinum Alert" {
                str_metalName = "platinum"
                let tilte: String = str_titleName
                let percent: String = btn_enetrPercent.currentTitle!
                
                if tilte.characters.count > 0 && percent.characters.count > 0{
                    let mutDict = NSMutableDictionary()
                    mutDict.setObject(tilte, forKey: "notification_type" as NSCopying)
                    mutDict.setObject(percent, forKey: "percent" as NSCopying)
                    mutDict.setObject("1113", forKey: "id" as NSCopying)
                    mutDict.setObject("Immediate", forKey: "selectedValue" as NSCopying)
                    mutDict.setObject("Default", forKey: "SelectedSound" as NSCopying)
                    arr_PlatinumAlert.insert(mutDict, at: 0)
                    addAlert(tilte, percent)
                    print("Platinum Array: \(arr_PlatinumAlert)")
                    tableview_Settings.reloadData()
                } else {
                    let controller = UIAlertController(title: "Information", message: "Please Fill the Complete Details", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default)
                    controller.addAction(okButton)
                    present(controller, animated: true)
                }
            } else if str_alertType == "Palladium Alert" {
                str_metalName = "palladium"
                let tilte: String = str_titleName
                let percent: String = btn_enetrPercent.currentTitle!
                
                if tilte.characters.count > 0 && percent.characters.count > 0{
                    let mutDict = NSMutableDictionary()
                    mutDict.setObject(tilte, forKey: "notification_type" as NSCopying)
                    mutDict.setObject(percent, forKey: "percent" as NSCopying)
                    mutDict.setObject("1114", forKey: "id" as NSCopying)
                    mutDict.setObject("Immediate", forKey: "selectedValue" as NSCopying)
                    mutDict.setObject("Default", forKey: "SelectedSound" as NSCopying)
                    arr_SilverAlert.insert(mutDict, at: 0)
                    addAlert(tilte, percent)
                    print("Palladium Array: \(arr_SilverAlert)")
                    tableview_Settings.reloadData()
                } else {
                    let controller = UIAlertController(title: "Information", message: "Please Fill the Complete Details", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default)
                    controller.addAction(okButton)
                    present(controller, animated: true)
                }
            }
        }
    }
    
    func addArrayLastObject()
    {
        let mutDictGOLD : NSMutableDictionary = NSMutableDictionary()
        mutDictGOLD["notification_type"] = "Add Gold Alert"
        mutDictGOLD["percent"] = ""
        arr_goldAlert.add(mutDictGOLD)
        
        let mutDictSILVER: NSMutableDictionary = NSMutableDictionary()
        mutDictSILVER["notification_type"] = "Add Silver Alert"
        mutDictSILVER["percent"] = ""
        arr_SilverAlert.add(mutDictSILVER)
        
        let mutDictPLATINUM: NSMutableDictionary = NSMutableDictionary()
        mutDictPLATINUM["notification_type"] = "Add Platinum Alert"
        mutDictSILVER["percent"] = ""
        arr_PlatinumAlert.add(mutDictPLATINUM)
        
        let mutDictPALLADIUM: NSMutableDictionary = NSMutableDictionary()
        mutDictPALLADIUM["notification_type"] = "Add Palladium Alert"
        mutDictSILVER["percent"] = ""
        arr_PalladiumAlert.add(mutDictPALLADIUM)
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