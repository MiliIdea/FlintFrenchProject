//
//  ReportUserRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class ReportUserRequestModel {
    
    init(targetUser : Int , reason : Int , txt : String) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.REASON = reason
        
        self.TEXT = txt
        
        self.TARGET_USER = targetUser
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var TEXT : String!
    
    var TARGET_USER : Int!
    
    var REASON : Int!
    
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME , "token": TOKEN ,"text" : TEXT, "target_user": TARGET_USER , "reason" : REASON]
        
    }
    
}
