//
//  UserLoginRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class LoginRequestModel {
    
    init(userName : String , password : String) {
        
        self.USERNAME = userName
        
        self.PASSWORD = password
        
//        self.USERNAME = "09335556196"
//
//        self.PASSWORD = "745319"
        
        self.COUNTRY = "FR"
        
        self.ID = "7b25266d-c98f-482f-8954-f15e21029492" // oneSignal ID
        
        self.TAG = "some-tag"
        
        self.DEVICE = "Apple iOS"
        
        self.OS_VERSION = "11.1.2"
        
    }
    
    var USERNAME: String!
    
    var PASSWORD: String!
    
    var ID: String!
    
    var TAG: String!
    
    var COUNTRY: String!
    
    var DEVICE: String!
    
    var OS_VERSION : String!
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME , "password": PASSWORD  , "id": ID , "country" : COUNTRY , "device" : DEVICE , "os_version" : OS_VERSION]
        
    }
    
}
