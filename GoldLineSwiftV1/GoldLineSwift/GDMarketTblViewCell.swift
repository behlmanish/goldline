//
//  GDMarketTblViewCell.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 7/6/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit

class GDMarketTblViewCell: UITableViewCell {

    @IBOutlet weak var lblMarketName: UILabel!
    @IBOutlet weak var lblMarketValue: UILabel!
    

    @IBOutlet weak var lblMarketChange: UILabel!
  
    @IBOutlet weak var lblMarketPercentChange: UILabel!
    
    
    @IBOutlet weak var imgViewMarketChange: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
