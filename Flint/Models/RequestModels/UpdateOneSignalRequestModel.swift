//
//  UpdateOneSignalRequestModel.swift
//  Flint
//
//  Created by MehrYasan on 6/12/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class UpdateOneSignalRequestModel {
    
    init(PLAYER_ID : String!) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.PLAYER_ID = PLAYER_ID
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var PLAYER_ID : String!
    
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! , "token": TOKEN!, "player_id": PLAYER_ID!]
        
    }
    
}
