//
//  FlintAnnotation.swift
//  Flint
//
//  Created by MILAD on 4/13/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Foundation

class FlintAnnotation: UIView {

    var image : UIImageView = UIImageView()
    var label : UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    public func setCharacteristics(size : Int , color : String , emoji : String){
        
        label.frame = CGRect(x:self.frame.width / 8 ,y: 0 ,width: self.frame.width * 6 / 8,height: self.frame.height * 1 / 2)
        label.backgroundColor = UIColor.clear
        label.textAlignment = NSTextAlignment.center
        label.font = label.font.withSize(50)
        label.adjustsFontSizeToFitWidth = true
        label.text = "🎬"
        
        image.frame = CGRect(x:0,y: 0,width: self.frame.width,height: self.frame.height)
        image.backgroundColor = UIColor.clear
        image.image = UIImage.init(named: "ChooseEmojiPin")
        
        self.addSubview(image)
        self.addSubview(label)
        
    }

    
}
