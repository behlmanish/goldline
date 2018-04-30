//
//  GDMarketVC.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 6/16/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class GDMarketVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var arrMarkets: NSMutableArray?
    var parsedItems: NSMutableArray?
    
    
    @IBOutlet weak var lblUsDebts: UILabel!
    @IBOutlet weak var lblUsDebtsDate: UILabel!
    @IBOutlet weak var lblDateInHeader: UILabel!
    @IBOutlet weak var tblView: UITableView!
 
    var marketDollar: GDMarket?
    var strDate: NSString?
    var strTime: NSString?
    var strTimeAmPm: NSString?
    var arr_MarketNames: NSMutableArray?
    
    var serviceData: NSArray?
    var compareDates: Comparator?
    var sortDesc1: NSSortDescriptor? = NSSortDescriptor()
    
    
    
//    var feedParser = MWFeedParser()
  
    func refreshRatesTimer(_ timer: Timer)
    {
        self.getRealTimeData()
    }
    

    func getRealTimeData()
    {
   
        
        WXCloudConnection.getLink("https://www.goldline.com/includes/reuters/markets_rt.php", target: self, selector: #selector(self.serviceComplete), userData: nil)
        
        WXCloudConnection.getLink("https://www.goldline.com/includes_common/json_dollar_index_delayed.php", target: self, selector: #selector(self.dollarIndexUpdated), userData: nil)

        
    }
    
    func dollarIndexUpdated(cloudConnection: WXCloudConnection)
    {
      //  var jsonData: NSArray = cloudConnection.dataAsUTF8String().jsonValue() as! NSArray
        let jsonData = cloudConnection.dataAsUTF8String().jsonValue() as? NSArray
        
        if (jsonData != nil) {
            let dic: NSDictionary = jsonData![0] as! NSDictionary
            
            marketDollar = GDMarket()
            marketDollar?.strMarketName = "Dollar"
            marketDollar?.strMarketChange = (dic["Dollarchange"] as! String)
            marketDollar?.strMarketValue = (dic["Dollarvalue"] as! String)
            marketDollar?.strMarketPercentChange = (dic["Dollarpercentchange"] as! String)
            marketDollar?.strLow = ""
            marketDollar?.strHigh = ""
            
            
            if (marketDollar?.strMarketChange?.hasPrefix("-"))!
            {
                marketDollar?.isMarketHigh = false
            }
            else
            {
                marketDollar?.isMarketHigh = true
            }
            
        }
        tblView.reloadData()
    }

    
    func serviceComplete(cloudConnection: WXCloudConnection)
    {
        let json = cloudConnection.dataAsUTF8String() as String
        self.serviceData = json.jsonValue() as! NSArray?
        
      
        let info:NSDictionary = self.serviceData?[0] as! NSDictionary
        var strLastUpdatedDate = "\(info["CF_DATE"] as! String) \(info["CF_TIME"] as! String)"
        
        if strLastUpdatedDate.hasSuffix("am")
        {
            strLastUpdatedDate = strLastUpdatedDate.replacingOccurrences(of: "am", with: "")
        }
        if strLastUpdatedDate.hasSuffix("pm")
        {
            strLastUpdatedDate = strLastUpdatedDate.replacingOccurrences(of: "pm", with: "")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        let dateFromString: Date? = dateFormatter.date(from: strLastUpdatedDate)
       // print("print date das\(dateFromString)")
        
        let sourceDate: Date? = dateFromString
        
        let sourceTimeZone = NSTimeZone(abbreviation: "PST")
        let destinationTimeZone = NSTimeZone(abbreviation: "EST")
        
        let sourceGMTOffset: Double = Double((sourceTimeZone?.secondsFromGMT(for: sourceDate!))!)
        let destinationGMTOffset: Double = Double((destinationTimeZone?.secondsFromGMT(for: sourceDate!))!)
        let interval: TimeInterval = destinationGMTOffset - sourceGMTOffset
        var destinationDate = Date(timeInterval: interval, since: sourceDate!)
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        
        let formatterLocal = NSLocale.init(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = formatterLocal as Locale!
        strDate = "\(dateFormatter.string(from: sourceDate!))"
         as NSString?
        
        dateFormatter.dateFormat = "hh:mm a"
        strTime = dateFormatter.string(from: sourceDate!) as NSString?
        strTimeAmPm = ""
        lblDateInHeader.text = "\(strTime!) \(strTimeAmPm!)(EST), \(strDate!)"
        lblDateInHeader.text = lblDateInHeader.text?.uppercased()
        

        
       print("json print",serviceData)
      arrMarkets?.removeAllObjects()
        


        var i = 0
        for dict in serviceData!
        {
            let market: GDMarket = GDMarket()
            
            market.strMarketName = (dict as AnyObject).value(forKey: "DSPLY_NAME") as? String
            market.strMarketChange = (dict as! NSDictionary).value(forKey: "CF_NETCHNG") as! String?
            market.strMarketValue = (dict as AnyObject).value(forKey: "CF_LAST") as? String
           
            
            market.strMarketPercentChange = (dict as! NSDictionary).value(forKey: "PCTCHNG") as! String?
            market.strHigh = (dict as AnyObject).value(forKey: "CF_HIGH") as? String
            market.strLow = (dict as AnyObject).value(forKey: "CF_LOW") as? String
            
            if (market.strMarketChange?.hasPrefix("-"))!
            {
                market.isMarketHigh = false
            }
            else{
                market.isMarketHigh = true
            }
            arrMarkets?.add(market)

        }
        tblView.reloadData()
        //MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        
    
    }
    
       //TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    

    
    //TableView Delegates
    
    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rowCount: Int = (arrMarkets!.count)
        if rowCount > 0{
       if ((marketDollar) != nil)
       {
        rowCount+=1
        }
        return rowCount
        }else{
            return 0
        }
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt IndexPath: IndexPath) -> UITableViewCell
    {
        var cell: GDMarketTblViewCell! = tableView.dequeueReusableCell(withIdentifier: "GDMarketTblViewCell") as! GDMarketTblViewCell
        
        
        if cell == nil
        {
            cell = GDMarketTblViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "GDMarketTblViewCell")
        }
        
        var market: GDMarket
        
        if (IndexPath.row<arrMarkets?.count)
        {
            market = arrMarkets![IndexPath.row] as! GDMarket
            
        }
        else
        {
            market = marketDollar!
            
        }
                if (market.strMarketChange?.hasPrefix("-"))!
                {
                    cell.lblMarketChange.textColor = UIColor(red: 186 / 255.0, green: 0 / 255.0, blue: 0, alpha: 1.0)
                    cell.imgViewMarketChange.image = UIImage(named: "red_arrow")!
                    
                    cell.lblMarketChange.text = "$\(market.strMarketChange!.replacingOccurrences(of: "-", with: "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))"
                   
                    if (market.strMarketPercentChange?.hasSuffix("%"))!
                    {
                        cell.lblMarketPercentChange.text = "\(market.strMarketPercentChange!)"
                    }
                    else{
                        cell.lblMarketPercentChange.text = market.strMarketPercentChange
                    }
                    
                }else{
                                cell.lblMarketChange.textColor = UIColor(red: 16 / 255.0, green: 124 / 255.0,blue: 19/255.0, alpha: 1.0 )
                                cell.imgViewMarketChange.image = UIImage(named: "green_arrow")!
                                cell.lblMarketChange.text = "$\(market.strMarketChange!)"
                                if !(market.strMarketPercentChange?.hasSuffix("%"))! {
                                    cell.lblMarketPercentChange.text = "+ \(market.strMarketPercentChange!)%"
                                }
                                else{
                                    cell.lblMarketPercentChange.text = market.strMarketPercentChange
                                }
                                
                            }
        var strTemp: String?
                if market.strMarketName == "NASDAQ COMP" {
                    strTemp = "NASDAQ"
                }
                else if (market.strMarketName == "DJ INDU AVE"){
                    strTemp = "Dow Jones"
                }
                else if (market.strMarketName == "S&P 500 IND"){
                    strTemp = "S&P 500"
                }
                else if (market.strMarketName == "Dollar"){
                    strTemp = "US Dollar"
                }
               cell.lblMarketName.text = strTemp
                cell.lblMarketValue.text = market.strMarketValue
//                cell.lblMarketValue.font = UIFont(name: "TradeGothic-Bold", size: 20)
//                cell.lblMarketChange.font = UIFont(name: "TradeGothic", size: 17)
//                cell.lblMarketPercentChange.font = UIFont(name: "TradeGothic", size: 17)
                cell.selectionStyle = .none
        
        return cell
        


    }
    
    /*
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
     
     let metalFromArr:GDMetal =  self.arrMetals[indexPath.row] as! GDMetal
     let c: GDGraphVC = self.storyboard?.instantiateViewController(withIdentifier: "GraphDetailVC") as! GDGraphVC
     c.metal = metalFromArr
     c.strDateInHeader = lblUpdatedDate.text!
     c.strAMPMInHeader = (lblTimeAmPm.text as! NSString).substring(with: NSRange(location: 0, length: 2))
     c.strTimeInHeader = lblTime.text!
     c.reloadInputViews()
     self.navigationController?.pushViewController(c, animated: true)
     
     }*/
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            var market = GDMarket()
            if(indexPath.row < arrMarkets?.count){
                market = arrMarkets?[indexPath.row] as! GDMarket
    
            }else{
                market = marketDollar!
            }
            let detailVC: GDMarketDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "GDMarketDetailVC") as! GDMarketDetailVC
            switch indexPath.row {
            case 0:
                market.strSymbol = "ND"
                detailVC.str_header = "Nasdaq";
    
            case 1:
                market.strSymbol = "DJ"
                detailVC.str_header = "Dow Jones"
    
            case 2:
                market.strSymbol = "SP"
                detailVC.str_header = "S&P 500"
    
            case 3:
                market.strSymbol = "USD"
                detailVC.str_header = "US Dollar"
            default:
                break
            }
            detailVC.market = market
            detailVC.strDate = strDate
            detailVC.strTime = strTime
            detailVC.strAMPM = strTimeAmPm
           detailVC.strMarketName = arr_MarketNames![indexPath.row] as? NSString
           detailVC.strPeriod = FIVEYEAR as NSString?
            self.navigationController?.pushViewController(detailVC, animated: true)
            
            
            
        }
    
    
        override func viewDidLoad() {
            super.viewDidLoad()


           let refreshMe = UIRefreshControl()
            refreshMe.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshMe.addTarget(self, action: #selector(self.refreshTable(refreshMe:)), for: .valueChanged)
            arrMarkets = NSMutableArray()
            parsedItems = NSMutableArray()
            
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            self.getRealTimeData()
            
//            let feedURL = URL(string: "https://www.treasurydirect.gov/NP/debt/rss")!
//            feedParser = MWFeedParser(feedURL: feedURL)
//            feedParser.delegate = self
//            feedParser.feedParseType = ParseTypeFull
//            feedParser.delegate = self
//            feedParser.connectionType = ConnectionTypeAsynchronously
//            feedParser.parse()
//            
            Flurry.logEvent("Financial Markets")
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let del:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
        del.window!.bringSubview(toFront: del.btn_PlayOrPause!)
        
        arr_MarketNames = ["S&P 500", "Dow Jones", "NASDAQ", "US Dollar"]
        
        //self.navigationController!.setNavigationBarHidden(true, animated: false)
    }
    
    func refreshTable(refreshMe: UIRefreshControl)
    {
        WXCloudConnection.getLink("https://www.goldline.com/includes/reuters/markets_rt.php", target: self, selector: #selector(serviceComplete), userData: nil)
        
        WXCloudConnection.getLink("https://www.goldline.com/includes_common/json_dollar_index_delayed.php", target: self, selector: #selector(dollarIndexUpdated), userData: nil)
        
        refreshMe.endRefreshing()
    }
    
    
    
/*
    //#pragma mark MWFeedParserDelegate
    
    
    func feedParserDidStart(_ parser: MWFeedParser)
    {
        print("Started Parsing: \(parser.url)")
    }
    
    func feedParser(_ parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
        print("Parsed Feed Info: “\(info.title)”")
        self.title = info.title
    }
    
    func feedParser(_ parser: MWFeedParser, didParseFeedItem item: MWFeedItem)
    {
        if item != nil
        {
            parsedItems?.add(item)
        }
    }
    
    
    func feedParserDidFinish(_ parser: MWFeedParser)
    {

   print("Finished Parsing\(parser.isStopped ? " (Stopped)" : "")")
       //var sortDesc1 = NSSortDescriptor(key: "date", ascending: false, comparator: compareDates)
        
        var compareDates = {(date1: Date, date2: Date) -> ComparisonResult in
        return date1.compare(date2 as Date)
        }
        
        sortDesc1 = NSSortDescriptor(key: "date", ascending: false, comparator: compareDates as! Comparator)
        var descriptors: [Any] = [sortDesc1]
      parsedItems?.sort(using: descriptors as! [NSSortDescriptor])
        var item: MWFeedItem? = parsedItems?[0] as? MWFeedItem
        var str: String? = item?.summary?.convertingHTMLToPlainText()
        
        if (str?.characters.count)! > 0
        {
            var range: NSRange = (str! as String).range(of: "Public Debt Outstanding:") as! NSRange
            var strValue: String = ((str! as NSString)).substring(with: NSRange(location: range.location + range.length, length: (str?.characters.count)! - (range.location + range.length)))
            print("str value \(strValue)")
            lblUsDebts.text = strValue
    
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
            print("date \(dateFormatter.string(from: (item?.date)!))")
            lblUsDebtsDate.text = "as of \(dateFormatter.string(from: (item?.date)!))"
        }
        else
        {
            
        }
        
        
        func feedParser(_ parser: MWFeedParser, didFailWithError error: Error?)
        {
            print("Finished the parsing with Error: \(error)")
            if parsedItems?.count == 0
            {
                self.title = "Failed"
                
            }
            else{
                var alert = UIAlertView(title: "Parsing Incompleted ", message: "There was an error during the parsing of this feed. Not all of the feed items could parsed.", delegate: nil, cancelButtonTitle: "Dismiss", otherButtonTitles: "")
                alert.show()
            }
        }
        
    }
    
*/

}
