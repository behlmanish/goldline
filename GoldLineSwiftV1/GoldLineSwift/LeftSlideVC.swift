//
//  LeftSlideVC.swift
//  GoldLineSwift
//  Created by Aravind.Kumar on 6/16/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit
//protocol SliderMenuDelegate {
//    func sliderMenuItemSelectedAtIndex(_ index : Int32)
//}

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
        //self.navigationController!.setNavigationBarHidden(true, animated: false)
        self.leftVCTable.backgroundColor = UIColor.clear
        self.leftVCTable.rowHeight = 44
        self.leftVCTable.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    func openSelectedScreenFromMenuItems(_ selectedIndex: NSInteger) -> Void {
    //
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: self.ary_storyboardIdsOfVC?.object(at: selectedIndex) as! String)
    //
    //        SlideNavigationController.sharedInstance().popToRootAndSwitch(to: vc, withSlideOutAnimation: false, andCompletion: nil)
    //    }
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.navigationController!.setNavigationBarHidden(true, animated: false)
        let del:AppDelegate = UIApplication.shared.delegate! as! AppDelegate
        del.btn_PlayOrPause?.isHidden = true
        leftVCTable.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        let del: AppDelegate = UIApplication.shared.delegate! as! AppDelegate
//        if del.isAudioPlaying == false
//        {
//            del.btn_PlayOrPause?.isHidden = true
//        }else{
//            del.btn_PlayOrPause?.isHidden = false
//        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewOnSliderTopView.removeFromSuperview()
        //        leftVCTable.delegate?.tableView!(leftVCTable, didDeselectRowAt: leftVCTable.indexPathForSelectedRow!)
    }
    
    
    
    //tableView
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell:LeftSlideTableViewCell! = (tableView.cellForRow(at: indexPath)! as! LeftSlideTableViewCell)
        cell.bckCellImg.image = nil
        cell.arrImg.image = UIImage(named: "arrow11")!
        cell.lbl_Cell.textColor = UIColor(red: CGFloat(182 / 255.0), green: CGFloat(182 / 255.0), blue: CGFloat(182 / 255.0), alpha: CGFloat(1.0))
        
        
        switch indexPath.row {
        case 0:
            cell.img_Cell.image = UIImage(named: "spot.png")
            cell.lbl_Cell.text = "Metal Spot Prices"
        case 1:
            cell.img_Cell.image = UIImage(named: "market")
            cell.lbl_Cell.text = "Financial Markets"
        case 2:
            cell.img_Cell.image = UIImage(named: "noti")
            cell.lbl_Cell.text = "Price Alerts"
        case 3:
            cell.img_Cell.image = UIImage(named: "news")
            cell.lbl_Cell.text = "News/Videos"
        case 4:
            cell.img_Cell.image = UIImage(named: "coin")
            cell.lbl_Cell.text = "Coin Catalog"
        case 5:
            cell.img_Cell.image = UIImage(named: "about")
            cell.lbl_Cell.text = "About Goldline"
        case 6:
            cell.img_Cell.image = UIImage(named: "gold")
            cell.lbl_Cell.text = "Goldline Difference"
        case 7:
            cell.img_Cell.image = UIImage(named: "social.png")
            cell.lbl_Cell.text = "Social"
        case 8:
            cell.img_Cell.image = UIImage(named: "contact")
            cell.lbl_Cell.text = "Contact"
        default:
            break
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
        return 9
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let MyIdentifier = "LeftSlider"
        var cell:LeftSlideTableViewCell! = tableView.dequeueReusableCell(withIdentifier: MyIdentifier)! as! LeftSlideTableViewCell
        if cell == nil {
            cell = LeftSlideTableViewCell(style: .default, reuseIdentifier: MyIdentifier)
        }
        cell.lbl_Cell.textColor = UIColor(red: CGFloat(182 / 255.0), green: CGFloat(182 / 255.0), blue: CGFloat(182 / 255.0), alpha: CGFloat(1.0))
        
        switch indexPath.row {
        case 0:
            cell.img_Cell.image = UIImage(named: "spot.png")!
            cell.lbl_Cell.text = "Metal Spot Prices"
        case 1:
            cell.img_Cell.image = UIImage(named: "market")!
            cell.lbl_Cell.text = "Financial Markets"
        case 2:
            cell.img_Cell.image = UIImage(named: "noti")!
            cell.lbl_Cell.text = "Price Alerts"
        case 3:
            cell.img_Cell.image = UIImage(named: "news")!
            cell.lbl_Cell.text = "News/Videos"
        case 4:
            cell.img_Cell.image = UIImage(named: "coin")!
            cell.lbl_Cell.text = "Coin Catalog"
        case 5:
            cell.img_Cell.image = UIImage(named: "about")!
            cell.lbl_Cell.text = "About Goldline"
        case 6:
            cell.img_Cell.image = UIImage(named: "gold")!
            cell.lbl_Cell.text = "Goldline Difference"
        case 7:
            cell.img_Cell.image = UIImage(named: "social.png")!
            cell.lbl_Cell.text = "Social"
        case 8:
            cell.img_Cell.image = UIImage(named: "contact")!
            cell.lbl_Cell.text = "Contact"
        default:
            break
        }
        cell.selectionStyle = .none
        cell.textLabel!.numberOfLines = 2
        if UI_USER_INTERFACE_IDIOM() == .pad {
            cell.textLabel!.font = UIFont.systemFont(ofSize: CGFloat(21.0))
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var viewController : UIViewController!
        switch indexPath.row {
        case 0:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "SpotPrices")
            break
        case 1:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "MarketVC")
        case 2:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "GDSettingsViewController")
        case 3:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "News&videos")
        case 4:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "GDCoinCatalogInitialVC")
        case 5:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "GDAboutVC")
        case 6:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "GDGoldLineDifferenceVC")
        case 7:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "GDSocialVC")
        case 8:
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "GDContactVC")
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
        
        
        
        //    UINavigationController *navCntrl=[[UINavigationController alloc]initWithRootViewController:viewController];
        //    navCntrl.navigationBarHidden=YES;
        //    [[[GDAppDelegate globalDelegate] drawerViewController] setCenterViewController:navCntrl];
        //    [[GDAppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
        
        
        
        //        let cell: LeftSlideTableViewCell! = (tableView.cellForRow(at: indexPath)! as! LeftSlideTableViewCell)
        //        cell.bckCellImg.image = UIImage(named: "selectb")
        //        cell.lbl_Cell.textColor = UIColor.black
        //        cell.arrImg.image = UIImage(named: "arrow_sel")
        //
        //        switch indexPath.row {
        //        case 0:
        //            cell.img_Cell.image = UIImage(named: "spot_sel.png")!
        //        case 1:
        //            cell.img_Cell.image = UIImage(named: "market_sel")!
        //        case 2:
        //            cell.img_Cell.image = UIImage(named: "noti")!
        //        case 3:
        //            cell.img_Cell.image = UIImage(named: "news_sel")!
        //        case 4:
        //            cell.img_Cell.image = UIImage(named: "coin_sel")!
        //        case 5:
        //            cell.img_Cell.image = UIImage(named: "about_sel")!
        //        case 6:
        //            cell.img_Cell.image = UIImage(named: "gold_sel")!
        //        case 7:
        //            cell.img_Cell.image = UIImage(named: "social_sel.png")!
        //        case 8:
        //            cell.img_Cell.image = UIImage(named: "contact_sel")!
        //        default:
        //            break
        //        }
        //
        //        let del: AppDelegate = UIApplication.shared.delegate! as! AppDelegate
        ////        del.isAudioPlaying = false
        //        if (del.isAudioPlaying) == false {
        //            del.btn_PlayOrPause.isHidden = true
        //        }
        //        else{
        //            del.btn_PlayOrPause.isHidden = false
        //        }
    }
    
    @objc(tableView:willDisplayCell:forRowAtIndexPath:) func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    
    
}
