//
//  NewCancelInviteRequestModel.swift
//  Flint
//
//  Created by MehrYasan on 6/28/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class NewCancelInviteRequestModel {
    
    init(invite : Int , note : String) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.INVITE = invite
        
        self.note = note
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var INVITE : Int!
    
    var note : String!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! , "token": TOKEN! ,"invite" : INVITE! , "note" : note!]
        
    }
    
}
