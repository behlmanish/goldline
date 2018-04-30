//
//  LeftSlideVC.swift
//  GoldLineSwift
//  Created by Aravind.Kumar on 6/16/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit

class LeftSlideVC: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var viewOnSliderTopView: UIView!
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    @IBOutlet weak var leftVCTable: UITableView!
    var slideOutAnimationEnabled:Bool?
    var ary_menuItems:NSArray?
    var ary_imagesMenuItems:NSArray?
    var ary_storyboardIdsOfVC:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leftVCTable.rowHeight = 44
        self.leftVCTable.tableFooterView = UIView(frame: CGRect.zero)
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let del:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
        del.btn_PlayOrPause?.isHidden = true
        leftVCTable.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    var index :IndexPath?
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    @IBAction func callNowFunction(_ sender: UIButton) {
        let device = UIDevice.current
        if (device.model == "iPhone") {
            let stringURL: String = "telprompt://8003185505"
            UIApplication.shared.openURL(URL(string: stringURL)!)
        } else {
            UIAlertView(title: "", message: "Device not supporting calling functionality", delegate: nil, cancelButtonTitle: "", otherButtonTitles: "Ok").show()
        }
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return 74
        } else {
            return 48
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
        
    }
     let MyIdentifier = "LeftSlider"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:LeftSlideTableViewCell! = tableView.dequeueReusableCell(withIdentifier: MyIdentifier)! as! LeftSlideTableViewCell
        if cell == nil {
            cell = LeftSlideTableViewCell(style: .default, reuseIdentifier: MyIdentifier)
        }
        cell.arrImg.image = UIImage(named: "arrow_right")
        cell.lbl_Cell.textColor = UIColor(red: CGFloat(182 / 255.0), green: CGFloat(182 / 255.0), blue: CGFloat(182 / 255.0), alpha: CGFloat(1.0))
        
        switch indexPath.row {
        case 0:
            cell.img_Cell.image = UIImage(named: "spot.png")!
            cell.lbl_Cell.text = "Metal Spot Prices"

        case 1:
            cell.img_Cell.image = UIImage(named: "news")!
            cell.lbl_Cell.text = "News/Videos"
        case 2:
            cell.img_Cell.image = UIImage(named: "coin")!
            cell.lbl_Cell.text = "Coin Catalog"
        case 3:
            cell.img_Cell.image = UIImage(named: "about")!
            cell.lbl_Cell.text = "About Goldline"
        case 4:
            cell.img_Cell.image = UIImage(named: "gold")!
            cell.lbl_Cell.text = "Goldline Difference"
        case 5:
            cell.img_Cell.image = UIImage(named: "social.png")!
            cell.lbl_Cell.text = "Social"
        case 6:
            cell.img_Cell.image = UIImage(named: "contact")!
            cell.lbl_Cell.text = "Contact"
        default:
            break
        }

        cell.textLabel!.numberOfLines = 2
        if UI_USER_INTERFACE_IDIOM() == .pad {
            cell.textLabel!.font = UIFont.systemFont(ofSize: CGFloat(21.0))
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var viewController : UIViewController!
        let cell:LeftSlideTableViewCell! = tableView.cellForRow(at: indexPath) as! LeftSlideTableViewCell

        index?.row = indexPath.row
        index?.section = indexPath.section
        
        
        switch indexPath.row {
        case 0:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "SpotPrices")
            leftVCTable.deselectRow(at: indexPath, animated: false)

            break

        case 1:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "News&videos")
            leftVCTable.deselectRow(at: indexPath, animated: false)
        case 2:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "GDCoinCatalogInitialVC")
            leftVCTable.deselectRow(at: indexPath, animated: false)

        case 3:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "GDAboutVC")
            leftVCTable.deselectRow(at: indexPath, animated: false)

        case 4:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "GDGoldLineDifferenceVC")
            leftVCTable.deselectRow(at: indexPath, animated: false)

        case 5:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "GDSocialVC")
            leftVCTable.deselectRow(at: indexPath, animated: false)

        case 6:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "GDContactVC")
            leftVCTable.deselectRow(at: indexPath, animated: false)

        default:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: " ")
            break
        }
     
        //         Replacement of ECSlidingViewController with JVsliderMenu
        let navCntrl = UINavigationController(rootViewController: viewController!)
        navCntrl.isNavigationBarHidden = true
        let del: AppDelegate = UIApplication.shared.delegate! as! AppDelegate
        
        del.drawerViewController.centerViewController = navCntrl
        del.toggleLeftDrawer(self, animated: true)
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell:LeftSlideTableViewCell! = (tableView.cellForRow(at: indexPath)! as! LeftSlideTableViewCell)
        cell.bckCellImg.image = nil

        cell.arrImg.image = UIImage(named: "arrow_right")!
        cell.lbl_Cell.textColor = UIColor(red: CGFloat(182 / 255.0), green: CGFloat(182 / 255.0), blue: CGFloat(182 / 255.0), alpha: CGFloat(1.0))

        switch indexPath.row {
        case 0:
            cell.img_Cell.image = UIImage(named: "spot.png")
            cell.lbl_Cell.text = "Metal Spot Prices"

        case 1:
            cell.img_Cell.image = UIImage(named: "news")
            cell.lbl_Cell.text = "News/Videos"
        case 2:
            cell.img_Cell.image = UIImage(named: "coin")
            cell.lbl_Cell.text = "Coin Catalog"
        case 3:
            cell.img_Cell.image = UIImage(named: "about")
            cell.lbl_Cell.text = "About Goldline"
        case 4:
            cell.img_Cell.image = UIImage(named: "gold")
            cell.lbl_Cell.text = "Goldline Difference"
        case 5:
            cell.img_Cell.image = UIImage(named: "social.png")
            cell.lbl_Cell.text = "Social"
        case 6:
            cell.img_Cell.image = UIImage(named: "contact")
            cell.lbl_Cell.text = "Contact"
        default:
            break
        }
    }

    @objc(tableView:willDisplayCell:forRowAtIndexPath:) func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      cell.backgroundColor = UIColor.clear
    }
    
    
    
}
