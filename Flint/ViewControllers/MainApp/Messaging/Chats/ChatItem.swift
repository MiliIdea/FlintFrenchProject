//
//  ChatItem.swift
//  HojreYar
//
//  Created by Soheil on 11/23/17.
//  Copyright © 2017 Soheil. All rights reserved.
//

import UIKit
import ObjectMapper


class ChatItem: NSObject, Mappable {
    
    
    public var id:Int?
    public var channel:String?
    public var status:String?
    public var seller:String?
    public var sellerId:Int?
    public var user:String?
    public var userId:Int?
    public var startDate:Int?
    public var storeId:Int?
    public var storeName:String?
    public var lastMessageDate:Int?
    
    required init?(map: Map) {
        
    }

    
    
     func mapping(map: Map) {
        id <- map["id"]
        channel <- map["channel"]
        status <- map["status"]
        seller <- map["seller"]
        sellerId <- map["sellerId"]
        user <- map["user"]
        userId <- map["userId"]
        startDate <- map["startDate"]
        storeId <- map["storeId"]
        storeName <- map["storeName"]
         lastMessageDate <- map["lastMessageDate"]
    }

    
    
}
