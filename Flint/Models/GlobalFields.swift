//
//  GlobalFields.swift
//  Flint
//
//  Created by MILAD on 4/16/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public class GlobalFields {
    
    static var loginResData : LoginRes? = nil
    
    static var settingsResData : GetSettingsRes? = nil
    
    static var TOKEN : String! = ""
    
    static var USERNAME : String! = ""
    
    static var userInfo : EditUserInformationRequestModel = EditUserInformationRequestModel()
    
    static var inviteLocation : CLLocationCoordinate2D?
    
    static var inviteAddress : String?
    
    static var inviteEmoji : String?
    
    static var inviteTitle : String?
    
    static var inviteWhen : Int?
    
    static var inviteNumber : Int?
    
    static var inviteMood : String?
    
    static var inviteMoodColor : UIColor?
    
}
