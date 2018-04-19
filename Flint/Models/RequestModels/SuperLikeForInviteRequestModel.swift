//
//  SuperLikeForInviteRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class SuperLikePersonForInviteRequestModel {
    
    init() {
        
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var INVITE : String!
    
    var TARGET_USER : String!
    
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME , "token": TOKEN ,"invite" : INVITE, "target_user": TARGET_USER]
        
    }
    
}
