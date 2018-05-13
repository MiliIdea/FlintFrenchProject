//
//  CreateInviteRes.swift
//  Flint
//
//  Created by MILAD on 4/19/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation
struct CreateInviteRes : Codable {
    
    let invite : Int?
    
    
    enum CodingKeys: String, CodingKey {
        
        case invite = "invite"
        
    }
    
    
}
