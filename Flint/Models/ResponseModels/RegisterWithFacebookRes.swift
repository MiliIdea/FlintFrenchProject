//
//  RegisterWithFacebookRes.swift
//  Flint
//
//  Created by MehrYasan on 5/15/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

struct RegisterWithFacebookRes : Codable {
    let id : Int?
    let username : String?
    let token : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case username = "username"
        case token = "token"
        
    }
    
}
