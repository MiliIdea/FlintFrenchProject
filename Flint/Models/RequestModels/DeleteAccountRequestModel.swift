//
//  DeleteAccountRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class DeleteAccountRequestModel {
    
    init() {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME , "token": TOKEN ]
        
    }
    
}
