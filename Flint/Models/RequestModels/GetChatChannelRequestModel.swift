//
//  GetChatChannelRequestModel.swift
//  Flint
//
//  Created by MehrYasan on 6/12/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class GetChatChannelRequestModel {
    
    init(ID : Int!) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.ID = ID
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var ID : Int!
    
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! , "token": TOKEN!, "id": ID!]
        
    }
    
}
