//
//  ChatModel.swift
//  HojreYar
//
//  Created by Soheil on 11/23/17.
//  Copyright © 2017 Soheil. All rights reserved.
//

import UIKit
import ObjectMapper

class ChatModel: NSObject, Mappable {
    
    
    public var messageId:Int?
    public var senderId:Int?
    public var senderName:String?
    public var sentDate:Double?
    public var status:String?
    public var text:String?
    public var type:String?
    public var senderAvatar:String?
    
    init(text:String, sendDate:Double, status:String , senderName:String, senderId:Int, messageId:Int, type:String, senderAvatar:String) {
        self.text = text
        self.sentDate = sendDate
        self.senderName = senderName
        self.status = status
        self.senderId = senderId
        self.messageId = messageId
        self.type = type
        self.senderAvatar = senderAvatar
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        messageId <- map["messageId"]
        senderId <- map["senderId"]
        senderName <- map["senderName"]
        sentDate <- map["sentDate"]
        status <- map["status"]
        text <- map["text"]
        type <- map["type"]
        senderAvatar <- map["senderAvatar"]
    }
    
    public func isIncommingMessage() -> Bool {
//        let user = UserInfo.getAll()
//        if (user?.serverId != self.senderId){
//            return true
//        }
        return false
    }
    
    
    public func isImageMessege() -> Bool {
        if let v = self.type {
            if v == "image" {
                return true
            }
        }
        return false
    }
}
