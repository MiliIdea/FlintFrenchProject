//
//  GetMyChatsRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/28/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class GetMyChatsRequestModel {
    
    init(page : Int , per_page : Int) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.PAGE = page
        
        self.PER_PAGE = per_page
    }
    
    var USERNAME: String!
    
    var TOKEN : String!
    
    var PAGE : Int!
    
    var PER_PAGE : Int!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! ,"token" : TOKEN! , "page" : PAGE! , "per_page" : PER_PAGE!]
        
    }
    
}
