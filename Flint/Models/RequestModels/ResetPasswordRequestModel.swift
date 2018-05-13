//
//  ResetPasswordRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/18/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class ResetPasswordRequestModel {
    
    init(userName : String , password : String , code : String) {
        
        self.USERNAME = userName
        
        self.PASSWORD = password
        
        self.CODE = code
        
    }
    
    var USERNAME: String!
    
    var PASSWORD: String!
    
    var CODE : String!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME , "password": PASSWORD ,"cpde" : CODE]
        
    }
    
}
