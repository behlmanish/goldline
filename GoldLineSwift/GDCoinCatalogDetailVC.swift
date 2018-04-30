//
//  GDCoinCatalogDetailVC.swift
//  GoldLineSwift
//
//  Created by Gaurav Singh Rawat on 1/06/2017.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

extension String {
    func removingCharacters(inCharacterSet forbiddenCharacters:CharacterSet) -> String
    {
        var filteredString = self
        while true {
            if let forbiddenCharRange = filteredString.rangeOfCharacter(from: forbiddenCharacters)  {
                filteredString.removeSubrange(forbiddenCharRange)
            }
            else {
                break
            }
        }
        
        return filteredString
    }
}

class GDCoinCatalogDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIWebViewDelegate,XMLParserDelegate {
    
    
    var parser = XMLParser()
    var titleXMLData:String = ""
    var currentElement:String = ""
    var titleName:Bool=false
    var itemArray: [String] = []
    var coinImage:Bool=false
    var nid:Bool=false
    var coinData:String = ""
    var nidData: String = ""
    var pubArray: [String] = []
    var summaryArray: [String] = []
    var guidArray: [String] = []
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var web_View: UIWebView!
    @IBOutlet weak var collectionViewMain: UICollectionView!
    @IBOutlet weak var scroll_Background: UIScrollView!
    @IBOutlet weak var page_Control: UIPageControl!
    var imaageArray = Array<String>()
    //    var strTitle: NSString?
    //    var strImage: NSString?
    //    var strCategory: NSString?
    //    var webserviceCount: Int?
    var selectedPro: String?

    var item: GDCoinCatalogItem?
    var str_coinSelected: String?
    var str_notify: String?
    var str_NodeID: String?
    var strTitle: String?
    var imageAray = [UIImage]()

    var del: AppDelegate?
    var strBody: String?
    var strSpecifications: NSString?
    var strImage: String?
    var arrImage: NSArray?
    var pageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url:String = "https://www.goldline.com/iphone/coin-view?nid=1841"
        let urlToSend: URL = URL(string: url)!
        parser = XMLParser(contentsOf: urlToSend)!
        parser.delegate = self as! XMLParserDelegate
        
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
            
            print(titleXMLData)
            
            
        } else {
            print("parse failure!")
        }
        
        print(selectedPro)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        Flurry.logEvent("Coin Catalog")

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        del = UIApplication.shared.delegate! as? AppDelegate
        del?.window!.bringSubview(toFront: (del?.btn_PlayOrPause)!)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let delayInSeconds: Double = 0.0;
        let popTime = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        DispatchQueue.main.asyncAfter(deadline: popTime) {
        }
    }

    //MARK:- Local Method
    func parseAndLoadData() {

        var str_NID: String = "";
        if str_notify == "Yes" {
            str_NID = str_NodeID!
        } else {
            str_NID = (item?.strNID)!
        }

        do {
            let xmlData = try Data(contentsOf: URL(string: "https://www.goldline.com/iphone/coin-view?nid=\(selectedPro)")!)
            let tbxml = try TBXML(xmlData: xmlData, error: { (error) in
                print("XML Error \(error)")
                }())
            let root = tbxml.rootXMLElement

            if (root != nil) {
                var elem_node = TBXML.childElementNamed("node", parentElement: root)

                while elem_node != nil {
                    let elem_Title = TBXML.childElementNamed("title", parentElement: elem_node)
                    strTitle = TBXML.text(for: elem_Title)

                    let elem_body = TBXML.childElementNamed("body", parentElement: elem_node)
                    strBody = TBXML.text(for: elem_body)

                    let elem_Specification = TBXML.childElementNamed("Specifications", parentElement: elem_node)
                    strSpecifications = TBXML.text(for: elem_Specification) as NSString?

                    let elem_Image = TBXML.childElementNamed("image", parentElement: elem_node)
                    strImage = TBXML.text(for: elem_Image)

                    elem_node = TBXML.nextSiblingNamed("node", searchFrom: elem_node)
                }
            }

            del?.window?.bringSubview(toFront: (del?.btn_PlayOrPause)!)
            scroll_Background.contentSize = CGSize(width: 0, height: 700)
            let range = strImage?.range(of: "|")

            if range?.lowerBound != range?.upperBound {
                let arr = strImage?.components(separatedBy: "|")
                arrImage = NSArray(array: arr!)
            } else {
                arrImage = NSArray(arrayLiteral: strImage)
            }

            collectionViewMain.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
            strSpecifications = strSpecifications?.convertingHTMLToPlainText() as NSString?
            strBody = strBody?.replacingOccurrences(of: "<p>", with: "<p style=\"BACKGROUND-COLOR:rgb(240,240,240)\"><font size=\"3\" face=\"TradeGothic\">")
            var count: NSInteger = 0, length = strSpecifications?.length
            var rangeStr = NSMakeRange(0, length!)

            while(rangeStr.location != NSNotFound) {
                rangeStr = (strSpecifications?.range(of: "Size", options: .caseInsensitive, range: rangeStr))!

                if rangeStr.location != NSNotFound {
                    rangeStr = NSMakeRange((rangeStr.location + rangeStr.length), (length! - (rangeStr.location + rangeStr.length)))
                    count += 1
                }

                if count != 1 {
                    strSpecifications = strSpecifications?.replacingOccurrences(of: "Size", with: "\nSize") as NSString?
                }
            }

            DispatchQueue.main.async {
                self.web_View.loadHTMLString("<html><body bgcolor=\"#F0F0F0\">\(self.strSpecifications) \n \(self.strBody)</body></html>", baseURL: nil)
            }
        } catch {
            print("Catch Error")
        }
    }

    func loadURL(_ strURL: String) {
        _ = TBXML(url: URL(string: strURL), success: { (tbxmlDocument) in

            if ((tbxmlDocument?.rootXMLElement) != nil) {
                self.traverseElement((tbxmlDocument?.rootXMLElement)!)
            }

            }, failure: { (tbxmlDocument, error) in
                print("Xml Load Error : \(error?.localizedDescription)")
        })
    }

    func traverseElement(_ element: UnsafeMutablePointer<TBXMLElement>) {
        TBXML.iterateElements(forQuery: "node", from: element) { (anElement) in
            var elem = anElement?.pointee.firstChild

            repeat {
                let name = String(cString: (elem?.pointee.name)!, encoding: .utf8)

                if name == "title" {
                    self.strTitle = String(cString: (elem?.pointee.text)!, encoding: .utf8)
                }

                if name == "body" {
                    self.strBody = String(cString: (elem?.pointee.text)!, encoding: .utf8)
                }

                if name == "image" {
                    self.strImage = String(cString: (elem?.pointee.text)!, encoding: .utf8)
                }

                if name == "Specifications" {
                    self.strSpecifications = String(cString: (elem?.pointee.text)!, encoding: .utf8) as NSString?
                }

                elem = elem?.pointee.nextSibling
            } while(elem != nil)
        }

        let range = strImage?.range(of: "|")

        if range?.lowerBound == range?.upperBound {
            let arr = strImage?.components(separatedBy: "|")
            arrImage = NSArray(array: arr!)
        } else {
            arrImage = NSArray(arrayLiteral: strImage)
        }

        collectionViewMain.reloadData()
        MBProgressHUD.hide(for: self.view, animated: true)
        strSpecifications = strSpecifications?.convertingHTMLToPlainText() as NSString?
        strBody = strBody?.replacingOccurrences(of: "<p>", with: "<p style=\"BACKGROUND-COLOR:rgb(240,240,240)\"><font size=\"3\" face=\"TradeGothic\">")
        var count: NSInteger = 0, length = strSpecifications?.length
        var rangeStr = NSMakeRange(0, length!)

        while rangeStr.location != NSNotFound {
            rangeStr = (strSpecifications?.range(of: "Size", options: NSString.CompareOptions(rawValue: UInt(0)), range: rangeStr))!

            if rangeStr.location != NSNotFound {
                rangeStr = NSMakeRange((rangeStr.location + rangeStr.length), (length! - (rangeStr.location + rangeStr.length)))
                count += 1
            }

            if count != 1 {
                strSpecifications = strSpecifications?.replacingOccurrences(of: "Size", with: "\nSize") as NSString?
            }
        }

        DispatchQueue.global(qos: .default).async {
            self.web_View.loadHTMLString("<html><body bgcolor=\"#F0F0F0\">\(self.strSpecifications) \n \(self.strBody)</body></html>", baseURL: nil)
        }
    }

   // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        page_Control.numberOfPages = (pubArray.count)
        return (pubArray.count)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewMain.dequeueReusableCell(withReuseIdentifier: "collectionCelll", for: indexPath) as! GDCoinCatalogCollectionCell
        let activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.activityIndicatorViewStyle = .gray
        cell.imgView.addSubview(activity)
        cell.imgView.imageURL = URL(string: pubArray[indexPath.row] as! String)!
        return cell
    }

  //  MARK:- UIWebView

    func webViewDidFinishLoad(_ webView: UIWebView) {
        let webHeight = webView.scrollView.contentSize.height
        scroll_Background.contentSize = CGSize(width: 0, height: webHeight + 220)
        webView.frame = CGRect(x: 0, y: webView.frame.origin.y, width: 320, height: webHeight)
    }

    // MARK: - UIScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = floor((scrollView.contentOffset.x - scrollView.frame.width / 2) / scrollView.frame.width) + 1
        page_Control.currentPage = Int(page)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = floor((scrollView.contentOffset.x - scrollView.frame.width / 2) / scrollView.frame.width) + 1
        pageCount = Int(page)
    }
}


