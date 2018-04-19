//
//  ChangeUserPasswordRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/17/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class ChangeUserPasswordRequestModel {
    
    init(userName : String , password : String , token : String) {
        
        self.USERNAME = userName
        
        self.PASSWORD = password
        
        self.TOKEN = token
        
    }
    
    var USERNAME: String!
    
    var PASSWORD: String!
    
    var TOKEN : String!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME , "password": PASSWORD ,"token" : TOKEN]
        
    }
    
}
