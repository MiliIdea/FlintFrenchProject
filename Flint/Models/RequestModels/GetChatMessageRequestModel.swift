//
//  GetChatMessageRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/29/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class GetChatMessageRequestModel {
    
    init(ID : Int , PAGE : Int , PER_PAGE : Int) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.ID = ID
        
        self.PAGE = PAGE
        
        self.PER_PAGE = PER_PAGE
    }
    
    var USERNAME: String!
    
    var TOKEN : String!
    
    var ID : Int!
    
    var PAGE : Int!
    
    var PER_PAGE : Int!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME ,"token" : TOKEN , "id" : ID , "page" : PAGE , "per_page" : PER_PAGE]
        
    }
    
}
