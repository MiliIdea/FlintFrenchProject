//
//  RegisterWithFacebookRequestModel.swift
//  Flint
//
//  Created by MehrYasan on 5/15/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation
import UIKit
import OneSignal

class RegisterWithFacebookRequestModel {
    
    init(email : String! , token : String! ) {
        
        self.USERNAME = email
        
        self.TOKEN = token
        
        self.ID = GlobalFields.oneSignalId
            
        self.TAG = "some tag"
        
        self.COUNTRY = "IR"
        
        self.DEVICE = "Apple iOS"
        
        self.OS_VERSION = UIDevice.current.systemVersion
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var ID : String!
    
    var TAG : String!
    
    var COUNTRY : String!
    
    var DEVICE : String!
    
    var OS_VERSION : String!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! , "token": TOKEN! , "id" : ID! , "tag" : TAG! , "country" : COUNTRY! , "device" : DEVICE! , "os_version" : OS_VERSION!]
        
    }
    
}

