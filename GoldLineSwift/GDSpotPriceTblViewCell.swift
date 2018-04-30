//
//  GDSpotPriceTblViewCell.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 6/21/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit

class GDSpotPriceTblViewCell: UITableViewCell {
    
    @IBOutlet weak var lblMetalName: UILabel!
    @IBOutlet weak var imgViewMetal: UIImageView!
    @IBOutlet weak var lblPriceInDollars: UILabel!
    @IBOutlet weak var lblChangeInDollars: UILabel!
    @IBOutlet weak var lblChangeWeight: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
