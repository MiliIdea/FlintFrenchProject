//
//  ReportUserRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class TeportUserRequestModel {
    
    init() {
        
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var TEXT : String!
    
    var TARGET_USER : String!
    
    var REASON : String!
    
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME , "token": TOKEN ,"text" : TEXT, "target_user": TARGET_USER , "reason" : REASON]
        
    }
    
}
