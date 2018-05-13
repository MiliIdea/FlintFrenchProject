//
//  ChangeUserSettingRquestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class ChangeUserSettingsRequestModel {
    
    init(LF : Int , NPN  : Bool , L : Bool , IAN : Bool , MN : Bool ,V : Bool , S : Bool , MINA : Int , MAXA : Int) {
        self.USERNAME = GlobalFields.USERNAME
        self.TOKEN = GlobalFields.TOKEN
        self.LOOKING_FOR = LF
        self.NEW_PIN_NOTIF = NPN
        self.LIGHTER = L
        self.INVITE_ACCEPTED_NOTIF = IAN
        self.MESSAGE_NOTIF = MN
        self.VIBRATION = V
        self.SOUNDS = S
        self.MIN_AGE = MINA
        self.MAX_AGE = MAXA
    }
    
    var USERNAME: String!
    
    var TOKEN: String!
    
    var LOOKING_FOR: Int!
    
    var NEW_PIN_NOTIF: Bool!
    
    var LIGHTER: Bool!
    
    var INVITE_ACCEPTED_NOTIF: Bool!
    
    var MESSAGE_NOTIF : Bool!
    
    var VIBRATION : Bool!
    
    var SOUNDS : Bool!
    
    var MIN_AGE : Int!
    
    var MAX_AGE : Int!
    
    
    func getParams() -> [String: Any]{
        
        return ["username": USERNAME , "token": TOKEN  , "looking_for": LOOKING_FOR , "new_pin_notif" : NEW_PIN_NOTIF , "lighter" : LIGHTER , "invite_accepted_notif" : INVITE_ACCEPTED_NOTIF , "message_notif" : MESSAGE_NOTIF , "vibration" : VIBRATION , "sounds" : SOUNDS , "min_age" : MIN_AGE , "max_age" : MAX_AGE]
        
    }
    
}
