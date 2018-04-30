//
//  GDCoinCatalogDetailVC.swift
//  GoldLineSwift
//
//  Created by Gaurav Singh Rawat on 1/06/2017.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK


class GDCoinCatalogDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIWebViewDelegate {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var web_View: UIWebView!
    @IBOutlet weak var collectionViewMain: UICollectionView!
    @IBOutlet weak var scroll_Background: UIScrollView!
    @IBOutlet weak var page_Control: UIPageControl!
    
    //    var strTitle: NSString?
    //    var strImage: NSString?
    //    var strNID: NSString?
    //    var strCategory: NSString?
    //    var webserviceCount: Int?
    
    var item: GDCoinCatalogItem?
    var str_coinSelected: String?
    var str_notify: String?
    var str_NodeID: String?
    var strTitle: String?
    
    var del: AppDelegate?
    var strBody: String?
    var strSpecifications: NSString?
    var strImage: String?
    var arrImage: NSArray?
    var pageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        if str_notify == "Yes" {
            lblHeader.text = str_coinSelected
        } else {
            lblHeader.text = item?.strCoinTitle
        }
        Flurry.logEvent("Coin Catalog")   // Example of even logging

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        del = UIApplication.shared.delegate! as? AppDelegate
        del?.window!.bringSubview(toFront: (del?.btn_PlayOrPause)!)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        lblHeader.font = UIFont(name: "OpenSans-SemiBold", size: 18)
        let delayInSeconds: Double = 0.0;
        let popTime = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            self.parseAndLoadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            let xmlData = try Data(contentsOf: URL(string: "https://www.goldline.com/iphone/coin-view?nid=\(str_NID)")!)
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
    
    //MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        page_Control.numberOfPages = (arrImage?.count)!
        return (arrImage?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCelll", for: indexPath) as! GDCoinCatalogCollectionCell
        let activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activity.activityIndicatorViewStyle = .gray
        cell.imgView.addSubview(activity)
        cell.imgView.imageURL = URL(string: arrImage?[indexPath.row] as! String)!
        return cell
    }
    
    //MARK:- UIWebView
    
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


