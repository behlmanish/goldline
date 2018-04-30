//
//  GDNewsVideosTBlCell.swift
//  GoldLineSwift
//
//  Created by Gaurav Rawat on 5/23/17.
//  Copyright © 2017 MobileProgramming. All rights reserved.
//

import UIKit

class GDNewsVideosTBlCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var backImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
