//
//  LocalNotifications.swift
//  Flint
//
//  Created by MILAD on 4/30/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import Foundation
import NotificationCenter
import UserNotifications
import OneSignal

class LocalNotifications {
    
    func pushLocalNotification( info : [AnyHashable : Any] , title : String , subtitle : String , body : String  , timeInterval : TimeInterval , identifier : String){

        let notificationTest = UNMutableNotificationContent()
        notificationTest.title = title
        notificationTest.subtitle = subtitle
        notificationTest.body = body
        notificationTest.userInfo = info
        notificationTest.sound = UNNotificationSound(named: "onesignal_default_sound.wav")
        
        let notificationTriggerTest = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let requestTest = UNNotificationRequest(identifier: identifier, content: notificationTest, trigger: notificationTriggerTest)
        
        UNUserNotificationCenter.current().add(requestTest, withCompletionHandler: nil)
    }
    
    //status after date bud popupe nazar sanjio neshun bedam
    // statuse get active afterReconfirm bud 30 min bad az exat time popup nazarsanjio nehsun midam

    
    //ReConfirm notif
    //status after confirm check mikonim ag right now bud hamun moqe neshun midim
    // ag right now nabud 30 min qabl az exaxt time neshun midim
    // qable ink popupo call konam yebar getActive inviteo call konam
    
    
    static func sendNotify(){
        OneSignal.registerForPushNotifications()
        OneSignal.idsAvailable({(_ userId, _ pushToken) in
            print("UserId:\(userId!)")
            if pushToken != nil {
                print("pushToken:\(pushToken!)")
                var title = "title"
                var message = Date().description(with: .current)
                print(Date().addingTimeInterval(120).description(with: .current))
                OneSignal.postNotification(["headings": ["en": title], "contents": ["en": message], "include_player_ids": [userId!] , "subtitle" : ["en": title] , "content_available" : true , "data" : ["mili" : "haminjuri "] , "ios_sound" : "onesignal_default_sound.wav" ,"send_after" : Date().addingTimeInterval(120).description(with: .current)] ,
                                           onSuccess: {
                                            (result) in print("success") },
                                           onFailure: {(error) in print("error : \(error)") })
                
            }
        })
        
    }
    
    
}







