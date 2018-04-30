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

        // Do any additional setup after loading the view.
        Flurry.logEvent("Coin Catalog")   // Example of even logging

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//         let cell:GDCoinCatalogTblCell = tableView.dequeueReusableCellWithIdentifier("GDCoinCatalogTblCell") as! GDCoinCatalogTblCell
        cell.imgCell.image = UIImage(named: (self.arrCoinImages?.object(at: indexPath.row) as! String))
        cell.lblCell.text = self.arrCoinCatalog?.object(at: indexPath.row) as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coinDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CoinCatalogVC") as! GDCoinCatalogVC
        coinDetailVC.coinNumber = indexPath.row
        coinDetailVC.str_coinName = arrCoinCatalog?[indexPath.row] as! String
        self.navigationController?.pushViewController(coinDetailVC, animated: true)
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
