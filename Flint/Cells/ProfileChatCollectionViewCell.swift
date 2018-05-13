//
//  ProfileChatCollectionViewCell.swift
//  Flint
//
//  Created by MILAD on 4/24/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import DCKit
import UICircularProgressRing

class ProfileChatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ringView: UICircularProgressRingView!
    
    @IBOutlet weak var imageProfileButton: DCBorderedButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
