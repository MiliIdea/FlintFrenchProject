//
//  UserLoginRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation
import UIKit
import OneSignal

class LoginRequestModel {
    
    init(userName : String , password : String) {
        
        self.USERNAME = userName
        
        self.PASSWORD = password
        
        self.COUNTRY = "FR"
        
        OneSignal.registerForPushNotifications()
        OneSignal.idsAvailable({(_ userId, _ pushToken) in
            self.ID = userId
        })
        
        self.TAG = "some-tag"
        
        self.DEVICE = "Apple iOS"
        
        self.OS_VERSION = UIDevice.current.systemVersion
        
    }
    
    var USERNAME: String!
    
    var PASSWORD: String!
    
    var ID: String!
    
    var TAG: String!
    
    var COUNTRY: String!
    
    var DEVICE: String!
    
    var OS_VERSION : String!
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! , "password": PASSWORD!  , "id": ID ?? "" , "country" : COUNTRY! , "device" : DEVICE! , "os_version" : OS_VERSION!]
        
    }
    
}
