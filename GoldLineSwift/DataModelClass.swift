//
//  DataModelClass.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 6/23/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit
var dicAllData = [String:String]()
var arrAllData1 = NSMutableArray()

class DataModelClass: NSObject{
    
    var strMetalName: String?
    var strMetalValue: String?
    var strMetalChange: String?
    var strMetalPercentChange: String?
    var VC: ViewController?
    var arrMetals = [String]()
    var goldImage: String?
    var imageView: UIImage?
    
    class func getObjectWithJSONInfo(_ jsonDict: NSDictionary) -> DataModelClass {
     
        let metalGold = DataModelClass()
        return metalGold
    }
}
