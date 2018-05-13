//
//  ChatListRes.swift
//  Flint
//
//  Created by MILAD on 4/25/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

struct ChatListRes : Codable {
    
    let id : Int?
    let channel : String?
    let created_at : Int?
    let last_message : String?
    let last_message_at : Int?
    let user : Int?
    let target : Int?
    let target_name : String?
    let target_avatar : String?
    let user_avatar : String?
    let user_name : String?
    let last_message_type : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case channel = "channel"
        case created_at = "created_at"
        case last_message = "last_message"
        case last_message_at = "last_message_at"
        case user = "user"
        case target = "target"
        case target_name = "target_name"
        case target_avatar = "target_avatar"
        case user_avatar = "user_avatar"
        case user_name = "user_name"
        case last_message_type = "last_message_type"
    }

}
