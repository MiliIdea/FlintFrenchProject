//
//  SparksTableViewCell.swift
//  Flint
//
//  Created by MILAD on 4/24/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import UICircularProgressRing

class SparksTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var lastText: UILabel!
    
    @IBOutlet weak var ringView: UICircularProgressRingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
