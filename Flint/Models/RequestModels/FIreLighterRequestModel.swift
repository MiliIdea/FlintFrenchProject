//
//  FIreLighterRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class FireLighterRequestModel {
    
    init() {
        
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var TARGET_LIGHTER : String!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME , "token": TOKEN ,"target_lighter" : TARGET_LIGHTER]
        
    }
    
}
