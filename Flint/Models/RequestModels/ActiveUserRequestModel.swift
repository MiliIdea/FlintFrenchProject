//
//  ActiveUserRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/17/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation


class ActiveUserRequestModel {
    
    init(userName : String , code : String) {
        
        self.USERNAME = userName
        
        self.CODE = code
        
    }
    
    var USERNAME: String!
    
    var CODE: String!

    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME , "code": CODE ]
        
    }
    
}
