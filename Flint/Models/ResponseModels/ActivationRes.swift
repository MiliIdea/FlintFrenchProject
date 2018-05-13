//
//  ActivationRes.swift
//  Flint
//
//  Created by MILAD on 4/17/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

struct ActivationRes : Codable {

    let token : String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case token = "token"
        
    }
    
    
}
