//
//  EditUserInformationRequestModel.swift
//  Flint
//
//  Created by MILAD on 4/10/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation

class EditUserInformationRequestModel {
    
    init() {
        self.USERNAME = GlobalFields.USERNAME
        self.TOKEN = GlobalFields.TOKEN
    }
    
    init(name : String? , birthdate : Int? , gender : String? , bio : String? , avatar : String? , secAvatar : String? , lookingFor : Int? , selfie : String? , job : String? , studies : String?){
        
        self.USERNAME = GlobalFields.USERNAME
        self.TOKEN = GlobalFields.TOKEN
        self.NAME = name
        self.BIRTHDATE = birthdate
        self.GENDER = gender
        self.BIO = bio
        self.AVATAR = avatar
        self.SECOND_AVATAR = secAvatar
        self.LOOKING_FOR = lookingFor
        self.SELFIE_IMAGE = selfie
        self.JOB = job
        self.STUDIES = studies
    }
    
    var USERNAME: String?
    
    var TOKEN: String?
    
    var NAME: String?
    
    var BIRTHDATE: Int?
    
    var GENDER: String?
    
    var BIO: String?
    
    var AVATAR: String?
    
    var SECOND_AVATAR: String?
    
    var LOOKING_FOR: Int?
    //0 man , 1 woman
    
    var SELFIE_IMAGE: String?
    
    var JOB: String?
    
    var STUDIES: String?
    
    
    func getParams() -> [String: Any]{
        
        let par : [String : Any?] = ["username": USERNAME , "token": TOKEN  , "name": NAME , "birthdate" : BIRTHDATE , "gender" :GENDER ,"bio" : BIO, "avatar" : AVATAR,"second_avatar" : SECOND_AVATAR, "looking_for" : LOOKING_FOR, "selfie_image" : SELFIE_IMAGE , "job" : JOB, "studies" : STUDIES]
        
        var param : [String : Any] = [String : Any]()
        
        for p in par {
            if(p.value != nil){
                param[p.key] = p.value!
            }
        }
        
        return param
        
    }
    
}
