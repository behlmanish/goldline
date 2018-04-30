//
//  GDBrochureViewController.swift
//  GoldLineSwift
//
//  Created by Gaurav Singh Rawat on 25/05/17.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit

class GDBrochureViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var mGridView: UICollectionView!
    @IBOutlet weak var headingLabel: UILabel!
    
    var arr_data: NSMutableArray?
    var arr_link: NSMutableArray?
    var arr_brochureName: NSMutableArray?
    var appDelegate: AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let str_saveToken = "https://www.goldline.com/iphone/brochure.json"
        let urlrequest: URLRequest = URLRequest(url: URL(string: str_saveToken)!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlrequest)
        {
            (data, response , error) in
            guard error == nil else
            {
                print(error)
                return
            }
            guard let responseData = data else
            {
                print("No Data")
                return
            }
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: []) as? NSArray else {
                    print("error trying to convert data to JSON")
                    return
                }
                self.arr_data = NSMutableArray(array: todo)
                print(self.arr_data)
                DispatchQueue.main.async {
                //    MBProgressHUD.hide(for: self.view, animated: true)
                    self.mGridView.delegate = self
                    self.mGridView.dataSource = self
                    self.mGridView.reloadData()
                }
            } catch {
                print("Some Error")
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                return
            }
        }
        task.resume()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (arr_data?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Brochure", for: indexPath) as! GDBrochureCollectionViewCell
        let data = arr_data?[indexPath.row] as! NSDictionary
        getImageData(alink: data["image"] as! NSString, image: cell.img_cover)
        MBProgressHUD.hide(for: self.view, animated: true)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = self.view.frame.width / 2 - 5
        return CGSize(width: width, height: width + 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let controller: GDBrochureDetailViewController? = self.storyboard?.instantiateViewController(withIdentifier: "BrochureDetail") as? GDBrochureDetailViewController
        let data = arr_data?[indexPath.row] as! NSDictionary
        controller!.str_title = data["title"] as!  String
        controller!.str_selectedLink = data["url"] as!  String
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    func getImageData(alink: NSString, image: UIImageView)
    {
        let dataSet = WXDataSet.default()
        let imagelink: String = alink as String
        let imageKey: String = NSURL.dataSetKey(fromLink: imagelink)
        
        if (dataSet?.doesKeyExist(imageKey))! == false || (dataSet?.age(forKey: imageKey))! > Double(WXDataSetAgeMinute) {
            image.image(fromCloudURL: URL(string: imagelink), cacheTo: dataSet)
        } else {
            image.image = dataSet?.image(forKey: imageKey)
        }
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
