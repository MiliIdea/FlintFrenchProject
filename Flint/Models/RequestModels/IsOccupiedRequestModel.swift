//
//  isOccupiedRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/28/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class IsOccupiedRequestModel {
    
    init(CHANNEL : String) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.CHANNEL = CHANNEL
    
    }
    
    var USERNAME: String!
    
    var TOKEN : String!
    
    var CHANNEL : String!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! ,"token" : TOKEN! , "channel" : CHANNEL!]
        
    }
    
}
