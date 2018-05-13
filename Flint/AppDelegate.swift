//
//  AppDelegate.swift
//  Flint
//
//  Created by MILAD on 4/3/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import CoreData
import AlamofireNetworkActivityLogger
import IQKeyboardManagerSwift
import Toast_Swift
import OneSignal
import CoreLocation
import Alamofire
import CodableAlamofire
import FacebookLogin
import FacebookCore



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , OSPermissionObserver, OSSubscriptionObserver , CLLocationManagerDelegate ,UNUserNotificationCenterDelegate {

    var window: UIWindow?

    let locationManager = CLLocationManager()
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug
        IQKeyboardManager.sharedManager().enable = true
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.isQueueEnabled = true
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 1000
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = .other
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        registerBackgroundTask()
        
        
        UNUserNotificationCenter.current().delegate = self
        
        
        // OneSignal
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload = result!.notification.payload
            if payload.additionalData != nil  && GlobalFields.TOKEN != nil {
                self.handleNotification(payload.additionalData)
            }
        }
        
        let notificationRecievedAction : OSHandleNotificationReceivedBlock = { result in
            print(result)
            print()
        }
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false,
                                     kOSSettingsKeyInAppLaunchURL: true]
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "7b25266d-c98f-482f-8954-f15e21029492",
                                        handleNotificationReceived: { (notification) in
                                            print("handleNotificationReceived")
                                            print(notification?.payload.description)
                                            let payload: OSNotificationPayload = notification!.payload
                                            if payload.additionalData != nil  && GlobalFields.TOKEN != nil {
                                                self.handleNotification(payload.additionalData)
                                            }
                                        },
                                        handleNotificationAction: notificationOpenedBlock,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        
        OneSignal.add(self as OSPermissionObserver)
        
        OneSignal.add(self as OSSubscriptionObserver)
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Flint")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        
        // Example of detecting answering the permission prompt
        if stateChanges.from.status == OSNotificationPermission.notDetermined {
            if stateChanges.to.status == OSNotificationPermission.authorized {
                print("Thanks for accepting notifications!")
            } else if stateChanges.to.status == OSNotificationPermission.denied {
                print("Notifications not accepted. You can turn them on later under your iOS settings.")
            }
        }
        // prints out all properties
        print("PermissionStateChanges: \n\(stateChanges)")
    }
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
    }
    
    func handleNotification(_ data:Dictionary<AnyHashable, Any>) {
        
        print(data)
        print()
//        let type = "\(data["type"] ?? "")"
//        if (type == OneSignalModel.TYPE_BROADCAST) {
//            let id = "\(data["id"] ?? "")"
//            let single = MessagesShowView()
//            single.isOpenFromNotification = true
//            single.boardId = Int(id)
//            self.window?.rootViewController = single
//            self.window?.makeKeyAndVisible()
//        } else if (type == OneSignalModel.TYPE_OFFER) {
//            let id = "\(data["id"] ?? "")"
//            let question = SingleOfferView()
//            question.offerId = Int(id)
//            self.window?.rootViewController = question
//            self.window?.makeKeyAndVisible()
//        } else if (type == OneSignalModel.TYPE_CUSTOMER) {
//            //            let date = "\(data["date"] ?? "")"
//            let near = SingleNearCustomerViewController()
//            self.window?.rootViewController = near
//            self.window?.makeKeyAndVisible()
//
//        } else if (type == OneSignalModel.TYPE_UPDATE) {
//            let version = "\(data["version"] ?? "")"
//            let description = "\(data["description"] ?? "")"
//
//        } else if (type == OneSignalModel.TYPE_STORE_MESSAGE) {
//            let id = "\(data["id"] ?? "")"
//            let question = QuestionsAnswerView()
//            question.isOpenFromNotification = true
//            question.messageId = Int(id)
//            self.window?.rootViewController = question
//            self.window?.makeKeyAndVisible()
//        } else if (type == OneSignalModel.TYPE_MESSAGE) {
//            let channel = "\(data["channel"] ?? "")"
//            let chatId = "\(data["chatId"] ?? "")"
//            let chatView = SingleChatView()
//            chatView.isOpenFromNotification = true
//            chatView.chatId = Int(chatId)!
//            chatView.channelName = channel
//            self.window?.rootViewController = chatView
//            self.window?.makeKeyAndVisible()
//
//        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Update the app interface directly.
        print(notification.request.content.userInfo)
        let a : [AnyHashable : Any] = ["mili" : "haminjuri "]
        do {
            if(notification.request.content.userInfo as! [String : String] == ["mili" : "haminjuri "]){
                print("its ok")
            }else{
                completionHandler([.alert, .badge, .sound])
            }
        }catch {
            print(error)
        }
        // Play a sound.
//        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.content.categoryIdentifier == "TIMER_EXPIRED" {
            // Handle the actions for the expired timer.
            if response.actionIdentifier == "SNOOZE_ACTION" {
                // Invalidate the old timer and create a new one. . .
            }
            else if response.actionIdentifier == "STOP_ACTION" {
                // Invalidate the timer. . .
            }
        }
        completionHandler()
        // Else handle actions for other notification types. . .
    }

    
    
    
    
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var lat: String
        
        var long: String
        
        let locManager = CLLocationManager()
        
        locManager.requestAlwaysAuthorization()
        
        var currentLocation = CLLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locManager.location!
            
        }
        
        long = String(currentLocation.coordinate.longitude)
        
        lat = String(currentLocation.coordinate.latitude)
        
        getAddressFromLatLon(pdblLatitude: lat, withLongitude: long)
        
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String){
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
//                    self.setAddressAndLocation()
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    var addressString : String = ""
                    
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality!
                    }
                    
                    
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    request(URLs.updateUserLocation, method: .post , parameters: UpdateUserLocationRequestModel.init(lat: pdblLatitude, long: pdblLongitude , city : pm.locality ?? "" , hood : pm.thoroughfare ?? "").getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
                        
                        let res = response.result.value
                        
                        
                    }
                    
                }
        })
        
    }
    
    func registerBackgroundTask() {
        
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            
            self?.reinstateBackgroundTask()
            
        }
        
        assert(backgroundTask != UIBackgroundTaskInvalid)
        
    }
    
    func reinstateBackgroundTask() {
        if (backgroundTask == UIBackgroundTaskInvalid) {
            // register background task
            registerBackgroundTask()
        }
    }
}

