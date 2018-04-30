//
//  GDResetAlertViewController.swift
//  GoldLineSwift
//
//  Created by Gaurav Singh Rawat on 06/06/17.
//  Copyright © 2017 MobileProgramming. All rights reserved.
//

import UIKit

class GDResetAlertViewController: UIViewController, GDAlertResetDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tbl_resetList: UITableView!
    @IBOutlet weak var headingLabel: UILabel!
    var str_title: String?
    var str_screenTacked: String?
    var arr_resetData: NSMutableArray = NSMutableArray()
    var appDelegate: AppDelegate?
    var delegate: GDAlertResetDelegate?
    
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbl_resetList.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headingLabel.font = UIFont(name: "OpenSans-SemiBold", size: 18)
        self.headingLabel.text = self.str_title
        self.arr_resetData = NSMutableArray()
        
        if self.str_title == "Alert Reset" {
            self.arr_resetData.addObjects(from: ["immediate", "1 hour", "3 hours", "6 hours", "next trading day", "1 week", "1 month"])
        } else if self.str_title == "Notification Sound" {
            self.arr_resetData.addObjects(from: ["default", "bell", "ping", "horn", "cuckoo", "woop"])
        }
        
        self.navigationController?.isNavigationBarHidden = true
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.tbl_resetList.reloadData()
    }
    
    //MARK:- UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_resetData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTableItem")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "SimpleTableItem")
        }
        
        cell?.textLabel?.text = self.arr_resetData[indexPath.row] as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.str_title == "Alert Reset" {
            UserDefaults.standard.set(self.arr_resetData[indexPath.row], forKey: "selectedValue")
            self.callServiceForUpdate(for: "interval", value: self.arr_resetData[indexPath.row] as! String)
        } else if self.str_title == "Notification Sound" {
            UserDefaults.standard.set(self.arr_resetData[indexPath.row], forKey: "SelectedSound")
            self.callServiceForUpdate(for: "sound", value: self.arr_resetData[indexPath.row] as! String)
        }
        UserDefaults.standard.synchronize()
    }
    
    //MARK: - Local Methods
    func callServiceForUpdate(for str_updateFor: String, value  str_updateValue: String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let srt_saveToken = "https://www.goldline.com/iphone/api/services/index.php?action=editNotification";
        let strupload = "id=\(UserDefaults.standard.object(forKey: "id") as! String)&update_for=\(str_updateFor)&update_value=\(str_updateValue)"
        let strpostlength = String(strupload.characters.count)
        var urlRequest = URLRequest(url: URL(string: srt_saveToken)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(strpostlength, forHTTPHeaderField: "Content-length")
        urlRequest.httpBody = strupload.data(using: .utf8)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: .main) { (response, data, error) in
            if error != nil {
                print("Error: \(error?.localizedDescription)")
                MBProgressHUD.hide(for: self.view, animated: true)
                return
            }
            do{
                let res: [AnyHashable: Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [AnyHashable: Any]
                print("Result: \(res)")
                MBProgressHUD.hide(for: self.view, animated: true)
            } catch {
                print("Catch Error")
            }
        }
    }
    
    internal func setAlertValue(_ string: String) {
    }
}
