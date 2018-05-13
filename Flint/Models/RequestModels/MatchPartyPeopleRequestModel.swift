//
//  MatchPartyPeopleRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class MatchPartyPeopleRequestModel {
    
    init(txt : String , targetUser : Int) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.TEXT = txt
        
        self.TARGET_USER = targetUser
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var TEXT : String!
    
    var TARGET_USER : Int!
    
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME , "token": TOKEN ,"text" : TEXT, "target_user": TARGET_USER]
        
    }
    
}
