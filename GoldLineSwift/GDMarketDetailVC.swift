  //
//  GDMarketDetailVC.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 6/16/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
import MBProgressHUD


let kDollarChartBaseURL: String = "https://www.goldline.com/iphone/dollar_chart.php?period=%@&w=320&h=185"
let kStockChartBaseURL: String = "https://www.goldline.com/iphone/market_chart.php?symbol=%@&period=%@&w=320&h=185"

let WEEK = "week"
let MONTH = "month"
let NINETY = "ninety"
let FIVEYEAR = "5year"
let ONEYEAR = "year"
var i = 0

class GDMarketDetailVC: UIViewController,UIGestureRecognizerDelegate {
    
    var str_header: NSString?
    var market: GDMarket?
    var strDate: NSString?
    var strTime: NSString?
    var strAMPM: NSString?
    var strMarketName: NSString?
    var strPeriod = ""
    var isRedColor: Bool?

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCurrentValue: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var lblAMPM: UILabel!
    @IBOutlet weak var imgViewGraph: UIImageView!
    @IBOutlet weak var lblChangeInValue: UILabel!
    @IBOutlet weak var lblChnageInPercent: UILabel!
    @IBOutlet weak var lblHigh_Title: UILabel!
    @IBOutlet weak var lblHigh: UILabel!
    @IBOutlet weak var lblLow_Title: UILabel!
    @IBOutlet weak var lblLow: UILabel!
    @IBOutlet weak var imgUndreline_High: UIImageView!
    @IBOutlet weak var imgUndreline_Low: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var imgViewGraphIcon: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if (strTime?.contains("P"))! {
            let endIndex = strTime?.range(of: "P").lowerBound
            strTime = strTime?.substring(to: endIndex!).trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
        }
        let url = strTime
        
        lblTime.text = url as! String
        lblDate.text = strDate as String?
        Flurry.logEvent("Financial Markets")

        let frame: CGRect = UIScreen.main.bounds
        if frame.size.height <= 480 {
            segment.frame = CGRect(x: CGFloat(8), y: CGFloat(148), width: CGFloat(305), height: CGFloat(29))
        }
        
        UISegmentedControl.appearance().setBackgroundImage(UIImage(named: "whitebg1.png"), for: .normal, barMetrics: UIBarMetrics.default)
        segment.setBackgroundImage(UIImage(named: "yellowbg.png"), for: .selected, barMetrics: UIBarMetrics.default)
        UISegmentedControl.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black], for: UIControlState.selected)
        let font = UIFont.boldSystemFont(ofSize: 13)
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSFontAttributeName: font],
                                                               for: UIControlState.normal)
        
        self.strPeriod = FIVEYEAR
        self.getSpotData()

        
        if (self.market?.isMarketHigh)! {
            lblChnageInPercent.textColor = UIColor(red: CGFloat(16 / 255.0), green: CGFloat(124 / 255.0), blue: CGFloat(19 / 255.0), alpha: CGFloat(1.0))
            lblChangeInValue.textColor = UIColor(red: CGFloat(16 / 255.0), green: CGFloat(124 / 255.0), blue: CGFloat(19 / 255.0), alpha: CGFloat(1.0))
        }
        else{
            lblChnageInPercent.textColor = UIColor(red: CGFloat(186 / 255.0), green: CGFloat(0 / 255.0), blue: 0, alpha: CGFloat(1.0))
            lblChangeInValue.textColor = UIColor(red: CGFloat(186 / 255.0), green: CGFloat(0 / 255.0), blue: 0, alpha: CGFloat(1.0))

        }
        let strChangeValue = NSMutableString(string: (self.market?.strMarketChange)!)
        
        if ((strChangeValue as? NSMutableString)?.substring(to: 1) == "+") || ((strChangeValue as? NSMutableString)?.substring(to: 1) == "-") {
            strChangeValue.insert("$", at: 1)
        }
        else {
            
            strChangeValue.insert("$", at: 0)
        }
        
        lblChangeInValue.text = strChangeValue as String
        lblChnageInPercent.text = market?.strMarketPercentChange
        lblCurrentValue.text = "$\((self.market?.strMarketValue)! as String)"
        lblHigh.text = "$\((self.market?.strHigh)! as String)"
        lblLow.text = "$\((self.market?.strLow)! as String)"
        
        lblHeader.text = strMarketName as? String
        
        // Do any additional setup after loading the view.
        //........towards right Gesture recogniser for swiping.....//
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.rightSwipeHandle(_:)))
        rightRecognizer.delegate = self
        rightRecognizer.direction = UISwipeGestureRecognizerDirection.right
        rightRecognizer.numberOfTouchesRequired = 1
        imgViewGraph.addGestureRecognizer(rightRecognizer)
        
        //........towards left Gesture recogniser for swiping.....//
        
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.rightSwipeHandle(_:)))
        leftRecognizer.delegate = self
        leftRecognizer.direction = UISwipeGestureRecognizerDirection.left
        leftRecognizer.numberOfTouchesRequired = 1
        imgViewGraph.addGestureRecognizer(leftRecognizer)
        imgViewGraph.isUserInteractionEnabled = true
        
        i = 0
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let del:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
        del.window!.bringSubview(toFront: del.btn_PlayOrPause!)
        
        if (self.market?.strHigh == "") || (self.market?.strLow == "") {
            lblHigh.isHidden = true
            lblLow.isHidden = true
            lblHigh_Title.isHidden = true
            lblLow_Title.isHidden = true
            imgUndreline_High.isHidden = true
            imgUndreline_Low.isHidden = true
            
        }  else {
            lblHigh.isHidden = false
            lblLow.isHidden = false
            lblHigh_Title.isHidden = false
            lblLow_Title.isHidden = false
            imgUndreline_High.isHidden = false
            imgUndreline_Low.isHidden = false
            
        }
    }

    
    //Data Loading
    
    func getSpotData() {
        var spotDataURL: String
        
        if (self.market?.strSymbol == "USD") {
            // US Dollar Image service
            spotDataURL = String(format: kDollarChartBaseURL, self.strPeriod)
        } else {
            // Stock data service
            spotDataURL = String(format: kStockChartBaseURL, (self.market?.strSymbol)!, self.strPeriod)
        }
        self.getImageData(alink: spotDataURL as NSString)
    }
    
    func serviceComplete(_ connection: WXCloudConnection){
        if (self.market?.strSymbol == "USD")
        {
            //US Dollar Image service loads an image directly
            let imageView: UIImageView? = imgViewGraph
            imageView?.image = UIImage(data: connection.data as Data)
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }
        else{
            // Stock data service loads a JSON array
            let json: NSString = connection.dataAsUTF8String() as NSString
            var serviceData: [Any] = json.jsonValue() as! [Any]
            var info: [AnyHashable: Any] = serviceData[0] as! [AnyHashable : Any]
            var strLastUpdatedDate: String? = "\(info["last_updated"] as? String)"
     
            let imageURL: String = "\(info["image_url"] as? String)"
            if imageURL != nil{
                //get the image data
                
                self.getImageData(alink: imageURL as NSString)
                
            }
            
        }
    }
    
    
    func getImageData(alink: NSString) {
        let dataSet = WXDataSet.default()
        let imagelink: String = alink as String
        let imageKey: String = NSURL.dataSetKey(fromLink: imagelink)
        
        if (dataSet?.doesKeyExist(imageKey))! == false || (dataSet?.age(forKey: imageKey))! > Double(WXDataSetAgeMinute)
        {
            imgViewGraph.image(fromCloudURL: URL(string: imagelink), cacheTo: dataSet)
            
        } else {
            imgViewGraph.image = dataSet?.image(forKey: imageKey)
        }
    }
    func removeAnimateion()
    {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }

    @IBAction func timeSelectorValueChanged(_ sender: UISegmentedControl) {
        MBProgressHUD.showAdded(to: self.view, animated: true)

        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            self.strPeriod = (FIVEYEAR as NSString) as String
            imgViewGraphIcon.image = UIImage(named: "1.png")
            
        case 1:
            self.strPeriod = (ONEYEAR as NSString) as String
            imgViewGraphIcon.image = UIImage(named: "2.png")
            
        case 2:
            self.strPeriod = (NINETY as NSString) as String
            imgViewGraphIcon.image = UIImage(named: "3.png")
            
        case 3:
            self.strPeriod = (MONTH as NSString) as String
            imgViewGraphIcon.image = UIImage(named: "4.png")
            
        case 4:
            self.strPeriod = (WEEK as NSString) as String
            imgViewGraphIcon.image = UIImage(named: "5.png")
            
        default:
            break
        }
        
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        self.getSpotData()
    }
    
    func rightSwipeHandle(_ gestureRecognizer: UISwipeGestureRecognizer)  {
        i -= 1
        if i >= 0
        {
            switch i {
            case 0:
                segment.selectedSegmentIndex = 0
                self.strPeriod = (FIVEYEAR as NSString) as String
                imgViewGraphIcon.image = UIImage(named: "1.png")
                
            case 1:
                segment.selectedSegmentIndex = 1
                self.strPeriod = (ONEYEAR as NSString) as String
                imgViewGraphIcon.image = UIImage(named: "2.png")
                
            case 2:
                segment.selectedSegmentIndex = 2
                self.strPeriod = (NINETY as NSString) as String
                imgViewGraphIcon.image = UIImage(named: "3.png")
                
            case 3:
                segment.selectedSegmentIndex = 3
                self.strPeriod = (MONTH as NSString) as String
                imgViewGraphIcon.image = UIImage(named: "4.png")
                
            case 4:
                segment.selectedSegmentIndex = 4
                self.strPeriod = (WEEK as NSString) as String
                imgViewGraphIcon.image = UIImage(named: "5.png")
                
            default:
                break
            }
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            self.getSpotData()
        }
        else
        {
            i = 0
        }
    }

    func leftSwipeHandle(gestureRecognizer: UISwipeGestureRecognizer)
    {
        //do moving
        i += 1
        if (i<5)
        {
            switch i {
            case 0:
                segment.selectedSegmentIndex = 0
                self.strPeriod = (FIVEYEAR as NSString) as String
                imgViewGraphIcon.image = UIImage(named: "1.png")
                
            case 1:
                segment.selectedSegmentIndex = 1
                self.strPeriod = (ONEYEAR as NSString) as String
                imgViewGraphIcon.image = UIImage(named: "2.png")
                
            case 2:
                segment.selectedSegmentIndex = 2
                self.strPeriod = (NINETY as NSString) as String
                imgViewGraphIcon.image = UIImage(named: "3.png")
                
            case 3:
                segment.selectedSegmentIndex = 3
                self.strPeriod = (MONTH as NSString) as String
                imgViewGraphIcon.image = UIImage(named: "4.png")
                
            case 4:
                segment.selectedSegmentIndex = 4
                self.strPeriod = (WEEK as NSString) as String
                imgViewGraphIcon.image = UIImage(named: "5.png")
                
            default:
                break
            }
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            self.getSpotData()
        
        }else{
            i = 4
        }
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
