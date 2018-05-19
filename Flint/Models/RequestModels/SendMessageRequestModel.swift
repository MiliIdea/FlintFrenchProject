//
//  SendMessageRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/28/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class SendMessageRequestModel {
    
    init(TEXT : String , TARGET : Int) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.TEXT = TEXT
        
        self.TARGET = TARGET
    }
    
    var USERNAME: String!
    
    var TOKEN : String!
    
    var TEXT : String!
    
    var TARGET : Int!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! ,"token" : TOKEN! , "text" : TEXT! , "target" : TARGET!]
        
    }
    
}
