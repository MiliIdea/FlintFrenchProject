//
//  CreateChannelRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/28/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CreateChannelRequestModel {
    
    init(CHANNEL : String , TARGET : Int) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.CHANNEL = CHANNEL
        
        self.TARGET = TARGET
    }
    
    var USERNAME: String!
    
    var TOKEN : String!
    
    var CHANNEL : String!
    
    var TARGET : Int!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! ,"token" : TOKEN! , "channel" : CHANNEL! , "target" : TARGET!]
        
    }
    
}
