//
//  UploadImageRes.swift
//  Flint
//
//  Created by MILAD on 4/17/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation
struct UploadImageRes : Codable {
    
    let name : String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        
    }
    
    
}
