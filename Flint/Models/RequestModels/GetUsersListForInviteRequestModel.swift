//
//  GetUserListForInviteRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class GetUsersListForInviteRequestModel {
    
    init(invite : Int , page : Int , perPage : Int ,lat : String , long : String) {
        
        self.USERNAME = GlobalFields.USERNAME
        
        self.TOKEN = GlobalFields.TOKEN
        
        self.INVITE = invite
        
        self.PAGE = page
        
        self.PER_PAGE = perPage
        
        //TODO
        self.LATITUDE = "35.673609"
        
        self.LONGITUDE = "51.215622"
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var INVITE : Int!
    
    var PAGE : Int!
    
    var PER_PAGE : Int!
    
    var LATITUDE : String!
    
    var LONGITUDE : String!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! , "token": TOKEN! ,"invite" : INVITE!, "page": PAGE!, "per_page": PER_PAGE! , "latitude" : LATITUDE! , "longitude" : LONGITUDE!]
        
    }
    
}
