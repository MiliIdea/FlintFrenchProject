//
//  SearchInLocationRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/22/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class SearchInLocationRequestModel {
    
    init(lat : String , long : String) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.LAT = lat
        
        self.LONG = long
    }
    
    var USERNAME: String!
    
    var TOKEN : String!
    
    var LAT : String!
    
    var LONG : String!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME ,"token" : TOKEN , "latitude" : LAT , "longitude" : LONG]
        
    }
    
}
