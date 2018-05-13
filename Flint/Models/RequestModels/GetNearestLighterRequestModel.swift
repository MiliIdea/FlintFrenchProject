//
//  GetNearestLighterRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class GetNearestLighterRequestModel {
    
    init() {
        
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME , "token": TOKEN ]
        
    }
    
}
