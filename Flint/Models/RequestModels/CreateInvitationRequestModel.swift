//
//  CreateInvitationRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class CreateInvitationRequestModel {
    
    init(type : Int , lat :String , long : String , peopleCount : Int ,exactTime : Int , when : Int ,emoji : String , title : String) {
        
        self.USERNAME = GlobalFields.USERNAME
        self.TOKEN = GlobalFields.TOKEN
        self.TYPE = type
        self.LAT = lat
        self.LONG = long
        self.PEOPLE_COUNT = peopleCount
        self.EXACT_TIME = exactTime
        self.WHEN = when
        self.EMOJI = emoji
        self.TITLE = title
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var TYPE: Int!
    
    var LAT: String!
    
    var LONG : String!
    
    var PEOPLE_COUNT: Int!
    
    var EXACT_TIME: Int!
    
    var WHEN: Int!
    
    var EMOJI: String!
    
    var TITLE : String!

    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME! , "token": TOKEN!  , "type": TYPE! , "longitude" : LONG! ,"latitude" : LAT!, "people_count" :PEOPLE_COUNT! ,"exact_time" : EXACT_TIME!, "when" : WHEN!,"emoji" : EMOJI! , "title"  : TITLE!]
        
    }
    
}
