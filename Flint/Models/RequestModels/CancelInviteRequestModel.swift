//
//  CancelInviteRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/20/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CancelInviteRequestModel {
    
    init(invite : Int) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.INVITE = invite.description
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var INVITE : String!
    
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! , "token": TOKEN! ,"invite" : INVITE!]
        
    }
    
}
