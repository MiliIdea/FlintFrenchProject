//
//  GetInviteMessageRes.swift
//  Flint
//
//  Created by MehrYasan on 5/22/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

struct GetInviteMessageRes : Codable {
    
    let name : String?
    let avatar : String?
    let invite : Int?
    let id : Int?
    let created_at : Int?
    let text : String?
    let seen : Int?
    let seen_at : Int?
    let second_avatar : String?
    let user : Int?
    
    
    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case avatar = "avatar"
        case invite = "invite"
        case id = "id"
        case created_at = "created_at"
        case text = "text"
        case seen = "seen"
        case seen_at = "seen_at"
        case second_avatar = "second_avatar"
        case user = "user"
        
    }
    
    
}
