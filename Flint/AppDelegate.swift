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
import FBSDKLoginKit
import FBSDKCoreKit
import Google
import GGLAnalytics



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , OSPermissionObserver, OSSubscriptionObserver , CLLocationManagerDelegate ,UNUserNotificationCenterDelegate{

    var window: UIWindow?

    let locationManager = CLLocationManager()
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        if(GlobalFields.USERNAME != "" && GlobalFields.TOKEN != "" && GlobalFields.PASSWORD != "" && GlobalFields.defaults.bool(forKey: "isRegisterCompleted")){
//            
//            if(GlobalFields.PASSWORD == "FACEBOOK"){
//                loginWithFaceBook()
//            }else{
//                login()
//            }
//            
//        }
        // Override point for customization after application launch.
        NetworkActivityLogger.shared.startLogging()
        NetworkActivityLogger.shared.level = .debug
        IQKeyboardManager.sharedManager().enable = true
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.isQueueEnabled = true
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 100
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.activityType = .other
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        registerBackgroundTask()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
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
        
        OneSignal.registerForPushNotifications()
        OneSignal.idsAvailable({(_ userId, _ pushToken) in
            GlobalFields.oneSignalId = userId
            if(GlobalFields.USERNAME != nil && GlobalFields.USERNAME != "" && GlobalFields.TOKEN != nil && GlobalFields.TOKEN != ""){
                self.updateOneSignal(id : userId)
            }
        })
        
        self.setupGoogleAnalytics()
        
        return true
    }

    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
        // Add any custom logic here.
        return handled
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
    
    func setupGoogleAnalytics() {
        
        // Configure tracker from GoogleService-Info.plist.
//        let configureError:NSError?
//        GGLContext.sharedInstance().configureWithError(&configureError)
//        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        let gai = GAI.sharedInstance()
        gai?.trackUncaughtExceptions = true  // report uncaught exceptions
        gai?.logger.logLevel = GAILogLevel.verbose  // remove before app release
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
        
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            GlobalFields.oneSignalId = stateChanges.to.userId
        }
        
    }
    
    func handleNotification(_ data:Dictionary<AnyHashable, Any>) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        print(data)
        print()
        
        let type = "\(data["type"] ?? "")"
        print(type)
        if(type == "cancel"){
            let inv = "\(data["invite"] ?? "")"
            print("now i should call getInviteInfo")
            request(URLs.getInviteInfo, method: .post , parameters: GetInviteInfoRequestModel.init(invite: Int(inv)!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<InviteInfoRes>>) in
                let res = response.result.value
                if(res?.data != nil){
                    if((res?.data?.main?.status)! < 5){
                        request(URLs.cancelInvite, method: .post , parameters: CancelInviteRequestModel.init(invite: Int(inv)!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response2 : DataResponse<ResponseModel<LoginRes>>) in
                            
                            let res2 = response2.result.value
                            if(res2?.status == "success"){
                                let vc : UIViewController? = self.topViewController()
                                if(vc != nil){
                                    if(vc?.isKind(of: FirstMapViewController.self))!{
                                        (vc as! FirstMapViewController).callGetActiveInvites(showLoading: true)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }else if(type == "finish"){
            let inv = "\(data["invite"] ?? "")"
            print("now i should call getInviteInfo")
            request(URLs.getInviteInfo, method: .post , parameters: GetInviteInfoRequestModel.init(invite: Int(inv)!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<InviteInfoRes>>) in
                let res = response.result.value
                if(res?.data != nil){
                    if((res?.data?.main?.status)! < 6){
                        request(URLs.finishDate, method: .post , parameters: GetInviteInfoRequestModel.init(invite: Int(inv)!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
                            
                            let res = response.result.value
                            
                            if(res?.data != nil){
                                let vc : UIViewController? = self.topViewController()
                                if(vc != nil){
                                    if(vc?.isKind(of: FirstMapViewController.self))!{
                                        (vc as! FirstMapViewController).callGetActiveInvites(showLoading: false)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }else if(type == "send_message" || type == "send_chat_message"){
            let vc : UIViewController? = self.topViewController()
            if(vc != nil){
                if(vc?.isKind(of: SparksViewController.self))!{
                    (vc as! SparksViewController).callChatListRest(showLoading: false)
                }else if(vc?.isKind(of: MessagePageViewController.self))!{
                    if((vc as! MessagePageViewController).chatTypeMode == .Messages){
                        (vc as! MessagePageViewController).callGetMessages()
                    }
                }
            }
        }else if(type == "send_invite_message"){
            let vc : UIViewController? = self.topViewController()
            if(vc != nil){
                if(vc?.isKind(of: FirstMapViewController.self))!{
                    (vc as! FirstMapViewController).updateInviteBadge()
                }else if(vc?.isKind(of: MessagePageViewController.self))!{
                    if((vc as! MessagePageViewController).chatTypeMode == .Invites){
                        (vc as! MessagePageViewController).callGetInviteInfo()
                    }
                }
            }
        }else{
            let vc : UIViewController? = self.topViewController()
            if(vc != nil){
                if(vc?.isKind(of: FirstMapViewController.self))!{
                    (vc as! FirstMapViewController).callGetActiveInvites(showLoading: false)
                }
            }
        }
        
        
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Update the app interface directly.
        print(notification.request.content.userInfo)
        let a : [AnyHashable : Any] = ["mili" : "haminjuri "]
        do {
            if(notification.request.content.userInfo as? [String : String] == ["mili" : "haminjuri "]){
                print("its ok")
                completionHandler(.init(rawValue: 0))
            }else{
                completionHandler([.alert, .badge, .sound])
            }
        }catch {
            
            completionHandler([])
            print(error)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
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
        
        GlobalFields.myLocation = currentLocation.coordinate
        
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
    
    func updateOneSignal(id : String!){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.updateOneSignal, method: .post , parameters: UpdateOneSignalRequestModel.init(PLAYER_ID: id).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            
            
        }
    }
    
    
    func topViewController() -> UIViewController? {
        var top = UIApplication.shared.keyWindow?.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
    
    func login(){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.login, method: .post , parameters: LoginRequestModel.init(userName : GlobalFields.USERNAME ,password : GlobalFields.PASSWORD).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value

            if(res?.status == "success" || res?.status == "5"){
                
                //inja bayad check kard k ta koja takmil karde
                
                if(res?.data != nil){
                    
                    GlobalFields.defaults.set(false, forKey: "reconfirm")
                    
                    GlobalFields.loginResData = res?.data!
                    
                    GlobalFields.TOKEN = res?.data?.token
                    
                    GlobalFields.PASSWORD = GlobalFields.PASSWORD
                    
                    GlobalFields.USERNAME = res?.data?.username
                    
                    GlobalFields.ID = res?.data?.id
                    
                    let data = res?.data
                    if(data?.name == nil || data?.name == ""){
                        self.goPage(name: "IntroViewController")
                    }else if(data?.birthdate == nil){
                        self.goPage(name: "IntroViewController")
                    }else if(data?.gender == nil){
                        self.goPage(name: "IntroViewController")
                    }else if(data?.avatar == nil || (data?.avatar?.contains("avatar.jpeg"))!){
                        self.goPage(name: "IntroViewController")
                    }else if(data?.selfie == nil || (data?.selfie?.contains("avatar.jpeg"))!){
                        self.goPage(name: "IntroViewController")
                    }else if(data?.bio == nil){
                        self.goPage(name: "IntroViewController")
                    }else if(data?.looking_for == nil){
                        self.goPage(name: "IntroViewController")
                    }else {
                        self.goPage(name: "FirstMapViewController")
                    }
                }else{
                    GlobalFields.USERNAME = ""
                    GlobalFields.TOKEN = ""
                    GlobalFields.PASSWORD = nil
                    GlobalFields.USERNAME = nil
                    GlobalFields.TOKEN = nil
                    GlobalFields.ID = nil
                    GlobalFields.defaults.set(false, forKey: "isRegisterCompleted")
                }
                
                
            }else if(res?.errCode == -2){
                self.goPage(name: "IntroViewController")
            }else{
                GlobalFields.USERNAME = ""
                GlobalFields.TOKEN = ""
                GlobalFields.PASSWORD = nil
                GlobalFields.USERNAME = nil
                GlobalFields.TOKEN = nil
                GlobalFields.ID = nil
                GlobalFields.defaults.set(false, forKey: "isRegisterCompleted")
                self.goPage(name: "IntroViewController")
            }
            
            
        }
        
        
    }
    
    
    func loginWithFaceBook(){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        request(URLs.loginWithFacebook, method: .post , parameters: LoginWithFacebookRequestModel.init(email: GlobalFields.USERNAME, token: GlobalFields.TOKEN ).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            if(res?.status == "success" || res?.status == "5"){
                //inja bayad check kard k ta koja takmil karde
                
                if(res?.data != nil){
                    
                    GlobalFields.loginResData = res?.data!
                    
                    GlobalFields.TOKEN = res?.data?.token
                    
                    GlobalFields.PASSWORD = "FACEBOOK"
                    
                    GlobalFields.USERNAME = res?.data?.username
                    
                    GlobalFields.ID = res?.data?.id
                    
                    let data = res?.data
                    if(data?.gender == nil){
                        self.goPage(name: "IntroViewController")
                    }else if(data?.avatar == nil || (data?.avatar?.contains("avatar.jpeg"))!){
                        self.goPage(name: "IntroViewController")
                    }else if(data?.selfie == nil || (data?.selfie?.contains("avatar.jpeg"))!){
                        self.goPage(name: "IntroViewController")
                    }else if(data?.bio == nil){
                        self.goPage(name: "IntroViewController")
                    }else if(data?.looking_for == nil){
                        self.goPage(name: "IntroViewController")
                    }else {
                        self.goPage(name: "FirstMapViewController")
                    }
                }else{
                    GlobalFields.USERNAME = ""
                    GlobalFields.TOKEN = ""
                    GlobalFields.PASSWORD = nil
                    GlobalFields.USERNAME = nil
                    GlobalFields.TOKEN = nil
                    GlobalFields.ID = nil
                    GlobalFields.defaults.set(false, forKey: "isRegisterCompleted")
                }
                
                
                
            }else if (res?.errCode == -2){
                self.goPage(name: "IntroViewController")
            }else{
                GlobalFields.USERNAME = ""
                GlobalFields.TOKEN = ""
                GlobalFields.PASSWORD = nil
                GlobalFields.USERNAME = nil
                GlobalFields.TOKEN = nil
                GlobalFields.ID = nil
                GlobalFields.defaults.set(false, forKey: "isRegisterCompleted")
                self.goPage(name: "IntroViewController")
            }
            
        }
    }
    
    func goPage(name : String){
        if(name == "FirstMapViewController"){
            let viewController = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: name) as! FirstMapViewController
            let nav = UINavigationController(rootViewController: viewController)
            nav.setNavigationBarHidden(true, animated: false)
            nav.setToolbarHidden(true, animated: false)
            self.window?.rootViewController = nav
        }else{
            let vc : UIViewController? = self.topViewController()
            if(vc != nil){
                if(vc?.isKind(of: IntroViewController.self))!{
                    if(GlobalFields.USERNAME != "" && GlobalFields.TOKEN != "" && GlobalFields.PASSWORD != "" && GlobalFields.defaults.bool(forKey: "isRegisterCompleted")){
                        (vc as! IntroViewController).splashView.alpha = 1
                    }else{
                        (vc as! IntroViewController).splashView.alpha = 0
                    }
                }else{
                    let viewController = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: name) as! IntroViewController
                    let nav = UINavigationController(rootViewController: viewController)
                    nav.setNavigationBarHidden(true, animated: false)
                    nav.setToolbarHidden(true, animated: false)
                    self.window?.rootViewController = nav
                }
            }else{
                let viewController = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: name) as! IntroViewController
                let nav = UINavigationController(rootViewController: viewController)
                nav.setNavigationBarHidden(true, animated: false)
                nav.setToolbarHidden(true, animated: false)
                self.window?.rootViewController = nav
            }
            
            
            
        }
        
    }
    
}

