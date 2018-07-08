//
//  LikeUserRequestModel.swift
//  Flint
//
//  Created by MehrYasan on 6/11/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class LikeUserRequestModel {
    
    init(targetUser : Int) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.TARGET_USER = targetUser
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var TARGET_USER : Int!
    
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! , "token": TOKEN!, "target": TARGET_USER!]
        
    }
    
}
