//
//  LeftSlideTableViewCell.swift
//  GoldLineSwift
//
//  Created by Aravind.Kumar on 7/1/16.
//  Copyright © 2016 MobileProgramming. All rights reserved.
//

import UIKit

class LeftSlideTableViewCell: UITableViewCell {

    @IBOutlet weak var arrImg: UIImageView!
    @IBOutlet weak var bckCellImg: UIImageView!
    @IBOutlet weak var lbl_Cell: UILabel!
    @IBOutlet weak var img_Cell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
