//
//  CheckUpdateRes.swift
//  Flint
//
//  Created by MehrYasan on 6/19/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

struct CheckUpdateRes : Codable {
    
    let ios_current_version : String?
    let ios_link : String?
    
    enum CodingKeys: String, CodingKey {
        
        case ios_current_version = "ios_current_version"
        case ios_link = "ios_link"
        
    }
    
}
