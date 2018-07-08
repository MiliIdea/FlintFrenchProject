//
//  DescriptionPageCollectionViewCell.swift
//  Flint
//
//  Created by MILAD on 4/5/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class DescriptionPageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var bioText: UITextView!
    
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var reportButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
