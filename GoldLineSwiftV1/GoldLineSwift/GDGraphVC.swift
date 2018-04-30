  //
//  GDGraphVC.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 6/16/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit
  import Flurry_iOS_SDK


class GDGraphVC: UIViewController, UIGestureRecognizerDelegate {
    let WEEK = "week"
    let MONTH = "month"
    let NINETY = "ninety"
    let FIVEYEAR = "5year"
    let ONEYEAR = "year"
    var i = 0
    
    @IBOutlet weak var lblCurrentValueInHeader: UILabel!
    @IBOutlet weak var lblTimeInHeader: UILabel!
    @IBOutlet weak var lblCurrentWeightInHeader: UILabel!
    @IBOutlet weak var lblDateInHeader: UILabel!
    @IBOutlet weak var lblAMPMInHeader: UILabel!
    
    
    @IBOutlet weak var imgViewGraphIcon: UIImageView!
    
    @IBOutlet weak var lblCurrentValueInBottom: UILabel!
    
    @IBOutlet weak var lblChangeValueInBottom: UILabel!
    
    @IBOutlet weak var lblChangepercentValuetInBottom: UILabel!
    
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var imgViewGraph: UIImageView!
    
    
    @IBOutlet weak var lblMetalHeader: UILabel!
    
    var str_header = ""
    var metal: GDMetal!
    var strPeriod = ""
    var strDateInHeader = ""
    var strTimeInHeader = ""
    var strAMPMInHeader = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Flurry.logEvent("Metal Spot Prices")
        lblTimeInHeader.text = strTimeInHeader
        lblDateInHeader.text = strDateInHeader
        lblAMPMInHeader.text = strAMPMInHeader
        
        UISegmentedControl.appearance().setBackgroundImage(UIImage(named: "whitebg1.png"), for: .normal, barMetrics: UIBarMetrics.default)
        segment.setBackgroundImage(UIImage(named: "yellowbg.png"), for: .selected, barMetrics: UIBarMetrics.default)

        
/*
         let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 16.0)!, forKey: NSFontAttributeName)
         UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , forState: .Normal)
 
        
        let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 16.0)!, forKey: NSFontAttributeName as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject: AnyObject], for: .normal)
*/
        
       lblChangeValueInBottom.text = metal.strMetalChange
        lblChangepercentValuetInBottom.text = metal.strMetalPercentChange
        
        
        if (metal.strMetalChange?.hasPrefix("+"))!
        {
            lblChangepercentValuetInBottom.textColor = UIColor(red: CGFloat(16 / 255.0), green: CGFloat(124 / 255.0), blue: CGFloat(19 / 255.0), alpha: CGFloat(1.0))
            lblChangeValueInBottom.textColor = UIColor(red: CGFloat(16 / 255.0), green: CGFloat(124 / 255.0), blue: CGFloat(19 / 255.0), alpha: CGFloat(1.0))
        }
        else
        {
            lblChangepercentValuetInBottom.textColor = UIColor(red: CGFloat(186 / 255.0), green: CGFloat(0 / 255.0), blue: CGFloat(0), alpha: CGFloat(1.0))
            lblChangeValueInBottom.textColor = UIColor(red: CGFloat(186 / 255.0), green: CGFloat(0 / 255.0), blue: CGFloat(0), alpha: CGFloat(1.0))

        }
   
        //Parse metal Name & values.
        lblMetalHeader.text = "\(metal.strMetalName! as String) Details"
        lblCurrentValueInHeader.text = metal.strMetalValue
        lblCurrentValueInBottom.text = metal.strMetalValue
        self.strPeriod = FIVEYEAR
       //MBProgressHUD.showAdded(to: self.view, animated: true)
        self.getSpotData()
    
        let del:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
        del.isLandscape = true
/*
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
         imgViewGraph.isUserInteractionEnabled = true*/

        
        // Do any additional setup after loading the view.
        //........towards right Gesture recogniser for swiping.....//
        
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.rightSwipeHandle(_:)))
        //rightRecognizer.delegate = self
        rightRecognizer.direction = UISwipeGestureRecognizerDirection.right
        rightRecognizer.numberOfTouchesRequired = 1
        imgViewGraph.addGestureRecognizer(rightRecognizer)
        
        
            //........towards left Gesture recogniser for swiping.....//
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.leftSwipeHandle(_:)))
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
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    func getSpotData()
    {
        var urlLink: String
        let urlHeader = "https://www.goldline.com/iphone/metals_chart.php?metal="
        let urlMetal = "\((self.metal.strMetalName?.lowercased())! as String)&period="
        let urlPeriod = "\(self.strPeriod as String)"
        
        //default is week
        var urlGraphSize: String? = nil
        urlGraphSize = "&w=320&h=185"
        urlLink = "\(urlHeader)\(urlMetal)\(urlPeriod)\(urlGraphSize!)"
    
        self.getImagedata(urlLink as NSString)
    }
    
    /*
     func serviceComplete(_ c: WXCloudConnection) {
     var json = c.dataAsUTF8String()
     var serviceData: [Any] = json.jsonValue()
     var info: [AnyHashable: Any] = serviceData[0]
     var strLastUpdatedDate: String? = "\(info["last_updated"] as? String)"
     var dateFormatter = DateFormatter()
     DateFormatter.setDefaultFormatterBehavior(.default)
     dateFormatter.dateFormat = "MMMM dd, yyyy - HH:mm:ss"
     var dateFromString: Date? = dateFormatter.date(fromString: strLastUpdatedDate?.replacingOccurrences(of: "PST", with: ""))
     print("print date 11\(dateFromString)")
     var sourceDate: Date? = dateFromString
     var sourceTimeZone = NSTimeZone(abbreviation: "PST")
     var destinationTimeZone = NSTimeZone(abbreviation: "EST")
     var sourceGMTOffset: Int = sourceTimeZone.secondsFromGMT(forDate: sourceDate)
     var destinationGMTOffset: Int = destinationTimeZone.secondsFromGMT(forDate: sourceDate)
     */
    
    func serviceComplete(c: WXCloudConnection)
    {
        /*
         let imageURL: String = "\(info["image_url"] as? String)"
         if imageURL != nil{
         //get the image data
         
         self.getImageData(alink: imageURL as NSString)

        */
        let json: NSString = c.dataAsUTF8String() as NSString
        var serviceData: [Any] = json.jsonValue() as! [Any]
        var info: [AnyHashable: Any] = serviceData[0] as! [AnyHashable : Any]
        
        var strLastUpdateDate: String? = "\(info["last_updated"] as? String)"
        
        let imageURL: String = "\(info["image_url"] as! String)"
        
        if imageURL != nil{
            //get the image data
            self.getImagedata(imageURL as NSString)
        }
        
        
        
    }
    
    
    func getImagedata(_ aLink: NSString)
    {   
        let dataSet:WXDataSet = WXDataSet.default() as WXDataSet
        
        let imageLink = aLink
        let imageKey = NSURL.dataSetKey(fromLink: imageLink as String!)
        
        if dataSet.doesKeyExist(imageKey) == false || dataSet.age(forKey: imageKey) > Double(WXDataSetAgeMinute)
        {
            imgViewGraph.image(fromCloudURL: URL(string: imageLink as String), cacheTo: dataSet)
        }
        else{
            imgViewGraph.image = dataSet.image(forKey: imageKey)
        }

        //MBProgressHUD.showAdded(to: self.view, animated: true)
//     print(dataSet)
    }

    @IBAction func timeSelectorValueChanged(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
        case 0:
            i = 0
            self.strPeriod = FIVEYEAR
            imgViewGraphIcon.image = UIImage(named: "1.png")!
            
        case 1:
            self.strPeriod = ONEYEAR
            imgViewGraphIcon.image = UIImage(named: "2.png")
        
        case 2:
            self.strPeriod = NINETY
            imgViewGraphIcon.image = UIImage(named: "3.png")
        
        case 3:
            self.strPeriod = MONTH
            imgViewGraphIcon.image = UIImage(named: "4.png")
            
        case 4:
            self.strPeriod = WEEK
            imgViewGraphIcon.image = UIImage(named: "5.png")
            
        default:
            break
        }
       
       // MBProgressHUD.showAdded(to: self.view, animated: true)
        self.getSpotData()
        
//        segment.selectedSegmentIndex = sender.selectedSegmentIndex
        
    }
 
    
    //Gesture action
    func rightSwipeHandle(_ gestureRecognizer: UISwipeGestureRecognizer) {
        i -= 1
        
        if i >= 0 {
            switch i {
            case 0:
                segment.selectedSegmentIndex = 0
                self.strPeriod = FIVEYEAR
                imgViewGraphIcon.image = UIImage(named: "1.png")!
            
            case 1:
                segment.selectedSegmentIndex = 1
                self.strPeriod = ONEYEAR
                imgViewGraphIcon.image = UIImage(named: "2.png")
            
            case 2:
                segment.selectedSegmentIndex = 2
                self.strPeriod = NINETY
                imgViewGraphIcon.image = UIImage(named: "3.png")
            
            case 3:
                segment.selectedSegmentIndex = 3
                self.strPeriod = MONTH
                imgViewGraphIcon.image = UIImage(named: "4.png")
            
            case 4:
                segment.selectedSegmentIndex = 4
                self.strPeriod = WEEK
                imgViewGraphIcon.image = UIImage(named: "5.png")
                
                
            default:
                break
            }
         //  MBProgressHUD.showAdded(to: self.view, animated: true)
            self.getSpotData()
        }
        else
        {
            i = 0
        }
    }

    func leftSwipeHandle(_ gestureRecognizer: UISwipeGestureRecognizer)
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
    


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }



}
