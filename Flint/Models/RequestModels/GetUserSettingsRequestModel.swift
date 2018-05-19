//
//  GetUserSettingsRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class GetUserSettingsRequestModel {
    
    init(lat : String , long : String) {
        
        self.USERNAME = GlobalFields.loginResData?.username
        
        self.TOKEN = GlobalFields.loginResData?.token
        
        self.LATITUDE = lat
        
        self.LONGITUDE = long
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var LATITUDE: String!
    
    var LONGITUDE: String!

    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! , "token": TOKEN!  , "latitude": LATITUDE! , "longitude" : LONGITUDE!]
        
    }
    
}
