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
import UIColor_Hex_Swift


public class GlobalFields {
    
    static let defaults: UserDefaults = UserDefaults.standard
    
    static var loginResData : LoginRes? {
        get{
            if(self.defaults.object(forKey: "loginResData") == nil){
                return nil
            }else{
                return NSKeyedUnarchiver.unarchiveObject(with: self.defaults.object(forKey: "loginResData") as! Data) as! LoginRes?
            }
            
        }
        set(newValue){
            
            if let newValue = newValue {
                self.defaults.set(NSKeyedArchiver.archivedData(withRootObject: newValue), forKey: "loginResData")
                self.userInfo.AVATAR = newValue.avatar
                self.userInfo.BIO = newValue.bio
                self.userInfo.BIRTHDATE = newValue.birthdate
                self.userInfo.GENDER = newValue.gender
                self.userInfo.JOB = newValue.job
                self.userInfo.STUDIES = newValue.studies
                self.userInfo.LOOKING_FOR = newValue.looking_for
                self.userInfo.NAME = newValue.name
                self.userInfo.SECOND_AVATAR = newValue.second_avatar
                self.userInfo.USERNAME = newValue.username
                self.userInfo.SELFIE_IMAGE = newValue.selfie
                self.userInfo.TOKEN = newValue.token
            }
            
            
        }
    }
    
    static var settingsResData : GetSettingsRes? = nil
    
    static var TOKEN : String! {
        get{
            return (self.defaults.object(forKey: "TOKEN") ?? "") as! String
        }
        set(newValue){
            self.defaults.set(newValue, forKey: "TOKEN")
        }
    }
    
    static var USERNAME : String! {
        get{
            return (self.defaults.object(forKey: "USERNAME") ?? "") as! String
        }
        set(newValue){
            self.defaults.set(newValue, forKey: "USERNAME")
        }
    }
    
    static var oneSignalId : String?
    
    static var userInfo : EditUserInformationRequestModel = EditUserInformationRequestModel()
    
    // MARK: -CreateInviation
    
    static var inviteLocation : CLLocationCoordinate2D? // SearchViewController set mishe
    
    static var inviteAddress : String? // SearchViewController set mishe
    
    static var inviteEmoji : String? // ActivityTypeViewController - SetEmojiViewController
    
    static var inviteTitle : String? // ActivityTypeViewController
    
    static var inviteExactTime : Date?
    
    static var inviteWhen : Int?
    
    static var inviteNumber : Int? // PersonNumberInvitationViewController
    
    static var inviteMood : String? // DetermineInvitationViewController
    
    static var inviteMoodColor : UIColor? // DetermineInvitationViewController
    
    static var invite : Int? //setEmojiViewController
    
    // MARK: -InviteAcception
    
    static var myInvite : MyInvites?
    
    
    
    
    static func getTypeColor(type : Int) -> UIColor{
        //1 => party , 2 => Business , 3 => LetsSee , 4 => Friendly
        
        if(type == 1){
            return UIColor("#0035CF")
        }else if(type == 2){
            return UIColor("#8F8F8E")
        }else if(type == 3){
            return UIColor("#FC8A88")
        }else if(type == 4){
            return UIColor("#FFBE00")
        }
        return UIColor("#0035CF")
    }
    
    static func showLoading(vc : UIViewController) -> LoadingViewController{
        let loadingView : LoadingViewController = (vc.storyboard?.instantiateViewController(withIdentifier: "LoadingViewController"))! as! LoadingViewController
        vc.addChildViewController(loadingView)
        loadingView.view.frame = vc.view.frame
        vc.view.addSubview(loadingView.view)
        loadingView.didMove(toParentViewController: vc)
        return loadingView
    }
    
    static func compressImage(image:UIImage) -> Data? {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        var maxHeight : CGFloat = 1136.0
        var maxWidth : CGFloat = 640.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        var maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
                compressionQuality = 1;
            }
        }
        
        var rect = CGRect.init(x : 0.0,y: 0.0,width: actualWidth,height: actualHeight);
        UIGraphicsBeginImageContext(rect.size);
        image.draw(in: rect)
        var img = UIGraphicsGetImageFromCurrentImageContext();
        let imageData = UIImageJPEGRepresentation(img!, compressionQuality);
        UIGraphicsEndImageContext();
        
        return imageData
    }

    
    
}






