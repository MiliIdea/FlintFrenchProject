//
//  NotificationPermissionViewController.swift
//  Flint
//
//  Created by MehrYasan on 6/30/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import OneSignal
import Alamofire
import CodableAlamofire

class NotificationPermissionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func accept(_ sender: Any) {
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
            if(accepted){
                OneSignal.idsAvailable({(_ userId, _ pushToken) in
                    GlobalFields.oneSignalId = userId
                    if(GlobalFields.USERNAME != nil && GlobalFields.USERNAME != "" && GlobalFields.TOKEN != nil && GlobalFields.TOKEN != ""){
                        self.updateOneSignal(id : userId)
                    }
                })
                if((UIApplication.shared.delegate as? AppDelegate)?.hasLocPermission())!{
                    let vC : FirstMapViewController = (self.storyboard?.instantiateViewController(withIdentifier: "FirstMapViewController"))! as! FirstMapViewController
                    self.navigationController?.pushViewController(vC, animated: true)
                }else{
                    let vC : LocationPermissionViewController = (self.storyboard?.instantiateViewController(withIdentifier: "LocationPermissionViewController"))! as! LocationPermissionViewController
                    self.navigationController?.pushViewController(vC, animated: true)
                }
                
            }else{
                print("che koniiiim??")
                let alertController = UIAlertController (title: "Notifications", message: "Aller aux paramètres ?", preferredStyle: .alert)
                
                let settingsAction = UIAlertAction(title: "Paramètres", style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "Annuler", style: .default, handler: nil)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }

    
    
    @IBAction func link(_ sender: Any) {
        UIApplication.shared.open(URL.init(string: "https://www.flint-app.com/cgu")!, options: [:], completionHandler: nil)
    }
    
    func updateOneSignal(id : String!){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.updateOneSignal, method: .post , parameters: UpdateOneSignalRequestModel.init(PLAYER_ID: id).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            
            
        }
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
