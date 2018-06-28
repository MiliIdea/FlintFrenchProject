//
//  LoginWithFacebookRequestModel.swift
//  Flint
//
//  Created by MehrYasan on 5/15/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation
import OneSignal
import UIKit

class LoginWithFacebookRequestModel {
    
    init(email : String , token : String) {
        
        self.TOKEN = token
        
        self.EMAIL = email
        
        self.COUNTRY = "FR"
        
        self.ID = GlobalFields.oneSignalId
        
        self.TAG = "some-tag"
        
        self.DEVICE = "Apple iOS"
        
        self.OS_VERSION = UIDevice.current.systemVersion
        
    }
    
    var EMAIL: String!
    
    var TOKEN: String!
    
    var ID: String!
    
    var TAG: String!
    
    var COUNTRY: String!
    
    var DEVICE: String!
    
    var OS_VERSION : String!
    
    func getParams() -> [String: Any]{
        
        return ["email": EMAIL! , "token": TOKEN!  , "id": ID ?? "" , "country" : COUNTRY! , "device" : DEVICE! , "os_version" : OS_VERSION!]
        
    }
    
}
