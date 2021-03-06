//
//  PromotionsVC.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 6/16/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class PromotionsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    var arrImage: NSMutableArray?
    var arr_PromotionsData: NSMutableArray?
    var pageCount: Int = 0
    
    @IBOutlet weak var btn_SideBar: UIButton!
    @IBOutlet weak var btn_Search: UIButton!
    @IBOutlet weak var collection_View: UICollectionView!
    @IBOutlet weak var page_Control: UIPageControl!
    @IBOutlet weak var headingLabel: UILabel!
    
    //MARK:- UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        Flurry.logEvent("iGoldline")
        arrImage = NSMutableArray()
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headingLabel.font = UIFont(name: "OpenSans-SemiBold", size: 18)
        let frame = UIScreen.main.bounds
        if(frame.height <= 480)
        {
            page_Control.frame = CGRect(x: 141, y: 420, width: 39, height: 37)
            collection_View.frame = CGRect(x: 0, y: 70, width: 320, height: 340)
        }
        self.navigationController?.isNavigationBarHidden = true
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.loadURL("https://www.goldline.com/iphone/promotion")
    }
    
    //MARK:- UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        page_Control.numberOfPages = (arrImage?.count)!
        return arrImage!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection_View.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! PromotionsCollectionCell
        let frame = UIScreen.main.bounds
        if(frame.size.height <= 480)
        {
            cell.img_Promotions.frame = CGRect(x: 0, y: 35, width: 279, height: 335)
        }
        cell.img_Promotions.imageURL = URL(string: arr_PromotionsData?[indexPath.item] as! String)!
        MBProgressHUD.hide(for: self.view, animated: true)
        return cell;
    }
    
    //MARK:- UIScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1
        page_Control.currentPage = Int(page)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let page = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1
        pageCount = Int(page)
    }

    //MARK:- Local Methods
    func loadURL(_ strURL: String) {
        _ = TBXML(url: URL(string: strURL)!, success: { (tbxmlDocument) in
            if tbxmlDocument?.rootXMLElement != nil {
                self.traverseElement((tbxmlDocument?.rootXMLElement)!)
            }
            }, failure: { (tbxmlDocument, error) in
                print("XML Error: \(error?.localizedDescription)")
        })
    }
    
    func traverseElement(_ element: UnsafeMutablePointer<TBXMLElement>) {
        TBXML.iterateElements(forQuery: "noide", from: element) { (anElement) in
            var elem = anElement?.pointee.firstChild
            repeat {
                let name = String(cString: (elem?.pointee.name)!, encoding: .utf8)
                if name == "Image" {
                    let strImage = String(cString: (elem?.pointee.text)!, encoding: .utf8)
                    let range = strImage?.range(of: "|")
                    if range?.lowerBound == range?.upperBound {
                        let arr =  strImage?.components(separatedBy: "|")
                        self.arrImage?.addingObjects(from: arr!)
                    } else {
                        self.arrImage?.add(strImage)
                    }
                }
                elem = elem?.pointee.nextSibling
            } while (elem != nil)
        }
        arr_PromotionsData = NSMutableArray()
        arr_PromotionsData?.add(arr_PromotionsData?.object(at: 1))
        arr_PromotionsData?.add(arr_PromotionsData?.object(at: 2))
        arr_PromotionsData?.add(arr_PromotionsData?.object(at: 0))
        collection_View.reloadData()
    }

}
