//
//  StoreChatResponse.swift
//  HojreYar
//
//  Created by Soheil on 12/13/17.
//  Copyright © 2017 Soheil. All rights reserved.
//

import UIKit
import ObjectMapper

class StoreChatResponse: NSObject, Mappable {
    
    public var status:String?
    public var message:String?
//    public var _meta:Meta?
    public var items:[ChatItem]?
    
    
     required init?(map: Map) {
        
    }
    
     func mapping(map: Map) {
//        _meta <-  map["_meta"]
        status <- map["status"]
        message <- map["message"]
        items <- map["items"]
    }

}
