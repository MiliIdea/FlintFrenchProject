//
//  SendChatRequestModel.swift
//  Flint
//
//  Created by MehrYasan on 5/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class SendChatRequestModel {
    
    init(TEXT : String , CHAT : Int) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.TEXT = TEXT
        
        self.CHAT = CHAT
    }
    
    var USERNAME: String!
    
    var TOKEN : String!
    
    var TEXT : String!
    
    var CHAT : Int!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! ,"token" : TOKEN! , "text" : TEXT! , "chat" : CHAT! , "type" : 1]
        
    }
    
}
