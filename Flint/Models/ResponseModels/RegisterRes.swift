//
//  RegisterRes.swift
//  Flint
//
//  Created by MILAD on 4/17/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

struct RegisterRes : Codable {
    let id : Int?
    let username : String?

    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case username = "username"

    }
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(Int.self, forKey: .id)
//        username = try values.decodeIfPresent(String.self, forKey: .username)
//    }
    
}
