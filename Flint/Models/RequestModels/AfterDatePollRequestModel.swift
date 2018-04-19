//
//  AfterDatePollRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation


class AfterDatePollRequestModel {
    
    init() {
        
        
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var INVITE : String!
    
    var TEXT : String!
    
    var ANSWER : String!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME , "token": TOKEN ,"invite" : INVITE, "text": TEXT , "answer" : ANSWER]
        
    }
    
}
