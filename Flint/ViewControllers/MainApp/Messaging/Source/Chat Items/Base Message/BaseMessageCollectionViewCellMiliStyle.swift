//
//  BaseMessageCollectionViewCellMiliStyle.swift
//  Flint
//
//  Created by MILAD on 4/15/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation
import ChattoAdditions

class BaseMessageCollectionViewCellMiliStyle: BaseMessageCollectionViewCell<CustomBubbleView> {
    
    override func createBubbleView() -> CustomBubbleView! {
        
        var bubbleView : CustomBubbleView = CustomBubbleView()
        
        bubbleView.backgroundColor = UIColor.brown
        
        return bubbleView
        
    }
    
}
