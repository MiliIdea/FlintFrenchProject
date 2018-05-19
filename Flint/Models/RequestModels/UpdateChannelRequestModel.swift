//
//  UpdateChannelRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/28/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class UpdateChannelRequestModel {
    
    init(CHANNEL : String , CHAT : Int) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.CHANNEL = CHANNEL
        
        self.CHAT = CHAT
    }
    
    var USERNAME: String!
    
    var TOKEN : String!
    
    var CHANNEL : String!
    
    var CHAT : Int!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! ,"token" : TOKEN! , "channel" : CHANNEL! , "chat" : CHAT!]
        
    }
    
}
