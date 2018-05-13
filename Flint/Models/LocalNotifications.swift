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
    
    
    
    
}
