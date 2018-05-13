//
//  UploadImageRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/17/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class UploadImageRequestModel {
    
    init() {
        
        self.USERNAME = GlobalFields.USERNAME

        self.TOKEN = GlobalFields.TOKEN
        
    }
    
    var USERNAME: String!
    
    var TOKEN : String!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME ,"token" : TOKEN]
        
    }
    
}
