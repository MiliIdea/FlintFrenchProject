//
//  BigPinTableViewCell.swift
//  Flint
//
//  Created by MILAD on 4/22/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import DCKit


class BigPinTableViewCell: UITableViewCell {

    @IBOutlet weak var b1: DCBorderedButton!
    
    @IBOutlet weak var b2: DCBorderedButton!
    
    @IBOutlet weak var b3: DCBorderedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
