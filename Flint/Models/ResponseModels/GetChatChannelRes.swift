//
//  GetChatChannelRes.swift
//  Flint
//
//  Created by MehrYasan on 6/12/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

struct GetChatChannelRes : Codable {
    let channel : String?
    
    enum CodingKeys: String, CodingKey {
        
        case channel = "channel"
    }
    
}
