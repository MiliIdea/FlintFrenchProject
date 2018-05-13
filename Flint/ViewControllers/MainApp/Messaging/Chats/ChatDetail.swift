//
//  ChatDetail.swift
//  HojreYar
//
//  Created by Soheil on 11/23/17.
//  Copyright © 2017 Soheil. All rights reserved.
//

import UIKit
import ObjectMapper

class ChatDetail: NSObject, Mappable {

    
    public var status:String?
    public var message:String?
    public var data:[ChatModel]?
    public var count:Int?
    public var page:Int?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
        count <- map["count"]
        page <- map["page"]
    }
}
