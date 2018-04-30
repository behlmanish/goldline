//
//  CoinCatologViewController.swift
//  GoldLineSwift
//
//  Created by Manish Behl on 27/10/17.
//  Copyright © 2017 MobileProgramming. All rights reserved.
//
import UIKit
import MBProgressHUD
//extension String {
//    func removingCharacters(inCharacterSet forbiddenCharacters:CharacterSet) -> String
//    {
//        var filteredString = self
//        while true {
//            if let forbiddenCharRange = filteredString.rangeOfCharacter(from: forbiddenCharacters)  {
//                filteredString.removeSubrange(forbiddenCharRange)
//            }
//            else {
//                break
//            }
//        }
//
//        return filteredString
//    }
//}
class CoinCatologViewController: UIViewController,UIWebViewDelegate,XMLParserDelegate,UICollectionViewDataSource, UICollectionViewDelegate {
    var bckimaageArray = Array<String>()
    var titleXMLData:String = ""
    var currentElement:String = ""
    var titleName:Bool=false
    var itemArray: [String] = []
    var coinImage:Bool=false
    var pubArray: [String] = []
    var summaryArray: [String] = []
    var guidArray: [String] = []
    var coinData:String = ""
    var nidData: String = ""
    var nid:Bool=false
    var parser = XMLParser()
    var pageCount = 0

    
    var headingLbl = String()
    @IBOutlet weak var coinCatalogHeaderLbl: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var collectionView: UICollectionView!
    var imageAray = [UIImage]()
    var nidUrl = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinCatalogHeaderLbl.text = headingLbl
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        
      let url:String = "https://www.goldline.com/iphone/coin-view?nid=\(nidUrl)"

        let urlToSend: URL = URL(string: url)!
        parser = XMLParser(contentsOf: urlToSend)!
        parser.delegate = self
        let success:Bool = parser.parse()
        if success {
            print("parse success!")
            print(titleXMLData)
            
        } else {
            print("parse failure!")
        }
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        
        if(elementName=="nodes" || elementName=="node" || elementName=="title" || elementName=="Nid" || elementName=="body" || elementName=="image" || elementName=="category" || elementName=="Specifications" )
        {
            if(elementName=="body"){
                titleName = true;
                titleXMLData = ""
            }
            else if(elementName == "image"){
                coinImage = true;
                coinData = ""
            }
            else if (elementName == "Specifications"){
                nid = true
                nidData = ""
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        if(elementName=="nodes" || elementName=="node" || elementName=="title" || elementName=="Nid" || elementName=="body" || elementName=="image" || elementName=="category" || elementName=="Specifications" )
            {
            if(elementName=="body"){
                titleName=false;
                itemArray.append(titleXMLData)
                titleXMLData = ""
            }
            
            coinImage = false
            nid = false
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if titleName {
            titleXMLData=titleXMLData+string
        } else if (coinImage) {
            pubArray.append(string)
        } else if (nid){
            
        let rawstr = string.replacingOccurrences(of: "<br>", with: "", options: .regularExpression, range: nil)
        print(rawstr)
            guidArray.append(rawstr)
          
        }}
    
    func insertElementAtIndex(element: String?, index: Int) {
        while itemArray.count < index + 1 {
            itemArray.append("")
        }
        itemArray.insert(element!, at: index)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        var myHTMLString : String! = String(describing: self.guidArray)
        let HTMLString : String! = self.itemArray[0]
        
        myHTMLString.append(HTMLString)
        
        
        let rawstr = myHTMLString.replacingOccurrences(of: "\"", with: "", options: .regularExpression, range: nil)
        print(rawstr)
        let removeTag = rawstr.replacingOccurrences(of: "\n\n[", with: "", options: .regularExpression, range: nil)
        let coma = removeTag.replacingOccurrences(of: "]", with: "", options: .regularExpression, range: nil)
        let brack = coma.replacingOccurrences(of: ",", with: "", options: .regularExpression, range: nil)
        
        removeTag.removingCharacters(inCharacterSet: CharacterSet.punctuationCharacters)
        webView.loadHTMLString(brack, baseURL: nil)
        
        var imageA = self.pubArray[0]
        var ab =  pubArray[0].characters.split{$0 == "|"}.map(String.init)
        print(ab)
        DispatchQueue.global().async {
            for item in 0..<ab.count {
                let url = NSURL(string:ab[item])
                var data = NSData(contentsOf: url as! URL)
                self.imageAray.append(UIImage(data: data as! Data)!)
                
                if item == ab.count - 1{
                    DispatchQueue.main.sync {
                        self.collectionView.reloadData()
                    }
                }
                
            }
        }

        


    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(imageAray.count)

        return self.imageAray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CoinCatologCollectionViewCell
        self.pageControl.numberOfPages = imageAray.count
        print(imageAray.count)
        self.pageControl.currentPage = 0
        cell.imageView.image = imageAray[indexPath.row]
        
        return cell
    }
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        print("Started to load")
    }
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        MBProgressHUD.hide(for: self.view, animated: true)

        print("Finished loading")
    }
    
    @IBAction func bckBttn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func callNowAction(_ sender: Any) {
        let device = UIDevice.current
        if (device.model == "iPhone") {
            let stringURL: String = "telprompt://8003185505"
            UIApplication.shared.openURL(URL(string: stringURL)!)
        } else {
            UIAlertView(title: "", message: "Device not supporting calling functionality", delegate: nil, cancelButtonTitle: "", otherButtonTitles: "Ok").show()
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = floor((scrollView.contentOffset.x - scrollView.frame.width / 2) / scrollView.frame.width) + 1
        pageControl.currentPage = Int(page)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = floor((scrollView.contentOffset.x - scrollView.frame.width / 2) / scrollView.frame.width) + 1
        pageCount = Int(page)
    }
}
