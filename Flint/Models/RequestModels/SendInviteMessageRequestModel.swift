//
//  SendInviteMessageRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/28/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class SendInviteMessageRequestModel {
    
    init(TEXT : String , INVITE : Int) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.TEXT = TEXT
        
        self.INVITE = INVITE
    }
    
    var USERNAME: String!
    
    var TOKEN : String!
    
    var TEXT : String!
    
    var INVITE : Int!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! ,"token" : TOKEN! , "text" : TEXT! , "invite" : INVITE!]
        
    }
    
}
