//
//  GDCoinCatalogVC.swift
//  GoldLineSwift
//
//  Created by Gaurav Singh Rawat on 30/05/17.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
import Kingfisher

class GDCoinCatalogVC: UIViewController, UITableViewDelegate, UITableViewDataSource,XMLParserDelegate{
    
    var coinNumber: Int!
    var str_coinName: String!
    var arrCoinCatalog: NSMutableArray?
    @IBOutlet weak var tblView: UITableView!
    
    var titleXMLData:String = ""
    var coinData:String = ""
    var categoryData: String = ""
    var nidData: String = ""
    var currentElement:String = ""
    var passData:Bool=false
    var titleName:Bool=false
    var coinImage:Bool=false
    var CategoryName:Bool=false
    var nid:Bool=false
    
    var parser = XMLParser()
    var itemArray: [String] = []
    var pubArray: [String] = []
    var summaryArray: [String] = []
    var guidArray: [String] = []
      var url:String?
    var index = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
    }
    func imageparse(){
        
        let group = DispatchGroup()
        var urlToSend: URL?
        switch (coinNumber) {
        case 0:
                self.url = "https://www.goldline.com/iphone/coin-exclusive"
                urlToSend = URL(string: self.url!)!
            break;
        case 1:
                self.url = "https://www.goldline.com/iphone/coin-gold"
                urlToSend = URL(string: self.url!)!
            break;
        case 2:
                self.url = "https://www.goldline.com/iphone/coin-silver"
                urlToSend = URL(string: self.url!)!
            break;
        case 3:
                self.url = "https://www.goldline.com/iphone/coin-platinum"
                urlToSend = URL(string: self.url!)!
            break;
        case 4:
                self.url = "https://www.goldline.com/iphone/coin-palladium"
                urlToSend = URL(string: self.url!)!
            break;
        case 5:
                self.url = "https://www.goldline.com/iphone/coin-ira"
                urlToSend = URL(string: self.url!)!
            break;
        default:
            break;
        }
        
        while (urlToSend == nil) {
            
        }
        parser = XMLParser(contentsOf: urlToSend!)!
        parser.delegate = self
        
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
            
            print(titleXMLData)
            
            
        } else {
            print("parse failure!")
        }
        
        
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: false)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let del:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
        del.window!.bringSubview(toFront: del.btn_PlayOrPause!)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        DispatchQueue.main.async {
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        self.tblView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        itemArray.removeAll()
        Flurry.logEvent("Coin Catalog")
        arrCoinCatalog = NSMutableArray()
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.bringSubview(toFront: delegate.btn_PlayOrPause)
        self.navigationController?.isNavigationBarHidden = true
        self .perform(#selector(imageparse), with: nil, afterDelay: 1);
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        
        if(elementName=="Coin-Category" || elementName=="Coin-image" || elementName=="Title" || elementName=="Nid")
        {
            if(elementName=="Title"){
                titleName = true;
                titleXMLData = ""
            }
            else if(elementName=="Coin-image"){
                coinImage = true;
                coinData = ""
            }
            else if (elementName == "Coin-Category"){
                CategoryName = true
                categoryData = ""
                
            }else if (elementName == "Nid"){
                nid = true
                nidData = ""
                
            }
            passData=true;
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        if(elementName=="Title" || elementName=="Coin-image" || elementName=="Coin-Category" || elementName=="Nid")
        {
            if(elementName=="Title"){
                titleName=false;
                itemArray.append(titleXMLData)
                titleXMLData = ""
            }
            passData=false;
            coinImage = false
            CategoryName = false
            nid = false
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if titleName {
            titleXMLData=titleXMLData+string
        }
        else if (coinImage)
        {
            pubArray.append(string)
        }
        else if (CategoryName){
            
            
            let rawstr = string.replacingOccurrences(of: "<p>", with: "", options: .regularExpression, range: nil)
            print("rawstr \(rawstr)")
            let removeTag = rawstr.replacingOccurrences(of: "<br>", with: "", options: .regularExpression, range: nil)
            summaryArray.append(removeTag)
        } else if (nid){
            guidArray.append(string)
        }
        
        tblView.reloadData()
        
    }
    func insertElementAtIndex(element: String?, index: Int) {
        while itemArray.count < index + 1 {
            itemArray.append("")
        }
        itemArray.insert(element!, at: index)
    }
    let cellReuseIdentifier = "cell"
    
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    var headerLbl = String()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GDCoinCatalogTblCell = self.tblView.dequeueReusableCell(withIdentifier: "coincatalog") as! GDCoinCatalogTblCell
        headerLbl = self.itemArray[indexPath.row]
        cell.lblCell.text = headerLbl
        var imageA = self.pubArray[indexPath.row]
        
        if imageA.contains("|") {
            let endIndex = imageA.range(of: "|")!.lowerBound
            imageA = imageA.substring(to: endIndex).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let url  = URL(string: imageA)
        
        cell.imgCell.kf.setImage(with: url)
        
        
        
        var ireEligble = self.summaryArray[indexPath.row]
        if ireEligble.contains("|") {
            let endIndex = ireEligble.range(of: "|")!.lowerBound
            ireEligble = ireEligble.substring(to: endIndex).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        cell.lblIRA.text = ireEligble
        return cell
    }
    // method to run when table view cell is tapped
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var ab :GDCoinCatalogTblCell = tblView.dequeueReusableCell(withIdentifier: "coincatalog") as! GDCoinCatalogTblCell
        let Nid = guidArray[indexPath.row]
        print(pubArray)
        let header = itemArray[indexPath.row]
        print(header)
        let coinDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "coin") as? CoinCatologViewController
        coinDetailVC?.bckimaageArray = [pubArray[indexPath.row]]
       
        coinDetailVC?.headingLbl = header

        coinDetailVC?.nidUrl = Nid
        self.navigationController?.pushViewController(coinDetailVC!, animated: true)
        print("You tapped cell number \(indexPath.row).")
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
     let cell:GDCoinCatalogTblCell = self.tblView.dequeueReusableCell(withIdentifier: "coincatalog") as! GDCoinCatalogTblCell
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

