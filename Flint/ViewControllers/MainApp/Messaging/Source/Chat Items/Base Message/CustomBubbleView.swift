//
//  CustomBubbleView.swift
//  Flint
//
//  Created by MILAD on 4/15/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class CustomBubbleView : UIView, MaximumLayoutWidthSpecificable, BackgroundSizingQueryable {
    
    var preferredMaxLayoutWidth: CGFloat = 200.0
    
    var canCalculateSizeInBackground: Bool = true
    
}
