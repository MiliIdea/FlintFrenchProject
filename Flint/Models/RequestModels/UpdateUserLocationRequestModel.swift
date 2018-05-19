//
//  UpdateUserLocationRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class UpdateUserLocationRequestModel {
    
    init(lat : String , long : String , city : String , hood : String) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.LATITUDE = lat
        
        self.LONGITUDE = long
        
        self.CITY = city
        
        self.Hood = hood
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var LATITUDE: String!
    
    var LONGITUDE: String!
    
    var CITY : String!
    
    var Hood : String!

    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! , "token": TOKEN!  , "latitude": LATITUDE! , "longitude" : LONGITUDE! , "city" : CITY! , "hood" : Hood!]
        
    }
    
}
