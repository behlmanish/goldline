//
//  GDIndustryNewsVC.swift
//  GoldLineSwift
//
//  Created by Gaurav Singh Rawat on 6/16/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
import MBProgressHUD

class GDIndustryNewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource,XMLParserDelegate {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var strXMLData:String = ""
    var PubDATEXMLData:String = ""
    var summaryData: String = ""
    var guidData: String = ""
    var currentElement:String = ""
    var passData:Bool=false
    var passName:Bool=false
    var pubDate:Bool=false
    var SummaryName:Bool=false
    var guidName:Bool=false
    var parser = XMLParser()
    var itemArray: [String] = []
    var pubArray: [String] = []
    var summaryArray: [String] = []
    var guidArray: [String] = []
    var index = 0
    let cellReuseIdentifier = "cell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Flurry.logEvent("Recent Industry News")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Recent Industry News";
        MBProgressHUD.showAdded(to: self.view, animated: true)

   
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.apiLoad()
        }
    }
    
    func apiLoad(){

            print("This is run on the background queue")
            let url:String="https://www.goldline.com/iphone/news.xml"
            let urlToSend: URL = URL(string: url)!
            
            
                self.parser = XMLParser(contentsOf: urlToSend)!
                
                self.parser.delegate = self
                
                let success:Bool = self.parser.parse()
                
                print("This is run on the main queue, after the previous code in outer block")
                if success {
                    
                    print("parse success!")
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                 
                    tableView.reloadData()
                    print(self.strXMLData)
                    
                } else {
                    print("parse failure!")
                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

                }
            }
 
    //MARK: - TableView
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        
        if(elementName=="item" || elementName=="pubDate" || elementName=="summary" || elementName=="guid")
        {
            if(elementName=="item"){
                passName=true;
                strXMLData = ""
            }
            else if(elementName=="pubDate"){
                pubDate = true;
                PubDATEXMLData = ""
            }
            else if (elementName == "summary"){
                SummaryName = true
                summaryData = ""
                
            }else if (elementName == "guid"){
                guidName = true
                guidData = ""
                
            }
            passData=true;
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        if(elementName=="item" || elementName=="pubDate" || elementName=="summary" || elementName=="guid")
        {
            if(elementName=="item"){
                passName=false;
                itemArray.append(strXMLData)
                strXMLData = ""
            }
            passData=false;
            pubDate = false
            SummaryName = false
            guidName = false
        }

    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if passName {
            strXMLData=strXMLData+string
            
        } else if (pubDate) {
           let ab = convertDateFormatter(date: string)
           pubArray.append(ab)
            
        } else if (SummaryName) {
            
            let rawstr = string.replacingOccurrences(of: "<p>", with: "", options: .regularExpression, range: nil)
            print("rawstr \(rawstr)")
            let removeTag = rawstr.replacingOccurrences(of: "</p>", with: "", options: .regularExpression, range: nil)
            let removeBRTag = removeTag.replacingOccurrences(of: "<br>", with: "", options: .regularExpression, range: nil)
            let removeStrongTag = removeTag.replacingOccurrences(of: "<strong>", with: "", options: .regularExpression, range: nil)
            let removeCloseStrongTag = removeStrongTag.replacingOccurrences(of: "</strong>", with: "", options: .regularExpression, range: nil)
            let removeATag = removeCloseStrongTag.replacingOccurrences(of: "</a>", with: "", options: .regularExpression, range: nil)
            let removeWBRTag = removeATag.replacingOccurrences(of: "br", with: "", options: .regularExpression, range: nil)
            let reTag = removeWBRTag.replacingOccurrences(of: "<>", with: "", options: .regularExpression, range: nil)

            summaryArray.append(reTag)

        } else if (guidName){
            guidArray.append(string)
        }
    }
    
    func convertDateFormatter(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "E, MMM d, yyyy"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp1 = dateFormatter.string(from: date!)
        
        return timeStamp1
    }
    
    func insertElementAtIndex(element: String?, index: Int) {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

        while itemArray.count < index + 1 {
            itemArray.append("")
        }
        itemArray.insert(element!, at: index)
    }
    
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:IndustryNewsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! IndustryNewsTableViewCell
        
        cell.itemLabel.text = self.itemArray[indexPath.row]
        cell.dateLabel.text = self.pubArray[indexPath.row]
        cell.summaryLabel.text = self.summaryArray[indexPath.row]

        return cell
    }
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cell:IndustryNewsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! IndustryNewsTableViewCell
        let selectedProgram = guidArray[indexPath.row]
        
        let mapViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "GDIndustryNewsDetailVC") as? GDIndustryNewsDetailVC
        mapViewControllerObj?.str_URL = selectedProgram
        self.navigationController?.pushViewController(mapViewControllerObj!, animated: true)
        print("You tapped cell number \(indexPath.row).")
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