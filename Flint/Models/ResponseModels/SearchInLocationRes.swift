//
//  SearchInLocationRes.swift
//  Flint
//
//  Created by MILAD on 4/22/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

struct SearchInLocationRes : Codable {
    
    let st_x : String?
    let st_y : String?
    let title : String?
    let image : String?
    let status : Int?
    let color : String?

    
    enum CodingKeys: String, CodingKey {
        
        case st_x = "st_x"
        case st_y = "st_y"
        case title = "title"
        case image = "image"
        case status = "status"
        case color = "color"
        
    }
    
}
