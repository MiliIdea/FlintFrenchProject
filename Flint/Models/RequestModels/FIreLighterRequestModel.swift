//
//  FIreLighterRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class FireLighterRequestModel {
    
    init(targetLighter : String!) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.TARGET_LIGHTER = targetLighter
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var TARGET_LIGHTER : String!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! , "token": TOKEN! ,"target_lighter" : TARGET_LIGHTER!]
        
    }
    
}
