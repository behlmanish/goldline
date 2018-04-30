//
//  GDCoinCatalogInitialVC.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 6/16/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class GDCoinCatalogInitialVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    var arrCoinImages: NSArray?
    var arrCoinCatalog: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrCoinImages = self.getAllCoinImages()
        self.arrCoinCatalog = self.getAllCoinCatalog()

        Flurry.logEvent("Coin Catalog")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        MBProgressHUD.hideAllHUDs(for: self.view, animated:true)
    }

    
    func getAllCoinImages() -> NSArray {
        return ["exclusive", "gold_coin", "silver_coin", "platinum_coin", "palladium", "ira"]
    }
    
    func getAllCoinCatalog() -> NSArray {
        return ["Exclusive","Gold", "Silver", "Platinum", "Palladium", "IRA"]
    }
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (arrCoinCatalog?.count)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: GDCoinCatalogTblCell! = tableView.dequeueReusableCell(withIdentifier: "GDCoinCatalogTblCell") as! GDCoinCatalogTblCell
        if cell == nil {
            cell = GDCoinCatalogTblCell(style: UITableViewCellStyle.value1, reuseIdentifier: "GDCoinCatalogTblCell")
        }

        cell.imgCell.image = UIImage(named: (self.arrCoinImages?.object(at: indexPath.row) as! String))
        cell.lblCell.text = self.arrCoinCatalog?.object(at: indexPath.row) as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let coinDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CoinCatalogVC") as! GDCoinCatalogVC

        coinDetailVC.coinNumber = indexPath.row
        coinDetailVC.str_coinName = arrCoinCatalog?[indexPath.row] as! String
        self.navigationController?.pushViewController(coinDetailVC, animated: true)
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        var cell: GDCoinCatalogTblCell! = tableView.dequeueReusableCell(withIdentifier: "GDCoinCatalogTblCell") as! GDCoinCatalogTblCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
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
