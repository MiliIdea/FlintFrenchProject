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
    

    public func setCharacteristics(pinImage : String , emoji : String){
        
        if(pinImage.split(separator: "-")[0] == "S"){
            label.frame = CGRect(x:self.frame.width / 8 ,y: self.frame.height * 1 / 6 ,width: self.frame.width * 6 / 8,height: self.frame.height * 6 / 14)
        }else if(pinImage != "N-P"){
            label.frame = CGRect(x:self.frame.width / 8 ,y: 0 ,width: self.frame.width * 6 / 8,height: self.frame.height * 6 / 14)
        }else{
            label.frame = CGRect(x:self.frame.width / 8 ,y: self.frame.height * 1 / 12 ,width: self.frame.width * 6 / 8,height: self.frame.height * 6 / 14)
        }
        
        label.backgroundColor = UIColor.clear
        label.textAlignment = NSTextAlignment.center
        label.font = label.font.withSize(50)
        label.adjustsFontSizeToFitWidth = true
        if(emoji != "💥"){
            label.text = emoji
        }else{
            label.text = "💥"
        }
        
        image.frame = CGRect(x:0,y: 0,width: self.frame.width,height: self.frame.height)
        image.backgroundColor = UIColor.clear
        image.image = UIImage.init(named: pinImage)
        
        self.addSubview(image)
        self.addSubview(label)
        
    }

    func decode(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
    
}
