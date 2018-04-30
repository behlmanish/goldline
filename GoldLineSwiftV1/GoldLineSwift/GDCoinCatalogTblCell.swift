//
//  GDCoinCatalogTblCell.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 7/15/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit

class GDCoinCatalogTblCell: UITableViewCell {

    @IBOutlet weak var lblCell: UILabel!
    @IBOutlet weak var imgCell: AsyncImageView!
    @IBOutlet weak var lblIRA: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
