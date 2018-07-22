
//
//  LocationPermissionViewController.swift
//  Flint
//
//  Created by MehrYasan on 6/30/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import CoreLocation

class LocationPermissionViewController: UIViewController , CLLocationManagerDelegate{

    var locManager: CLLocationManager!
    
    var timer : Timer = Timer.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        locManager = CLLocationManager()
        locManager.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func accept(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locManager.requestAlwaysAuthorization()
                timer = Timer.scheduledTimer(timeInterval: 0.5 , target: self, selector: #selector(check), userInfo: nil, repeats: true)
                break
            case .restricted, .denied:
                print("No access")
                self.goSettngs()
                break
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                let vC : FirstMapViewController = (self.storyboard?.instantiateViewController(withIdentifier: "FirstMapViewController"))! as! FirstMapViewController
                self.navigationController?.pushViewController(vC, animated: true)
                break
            }
        } else {
            print("Location services are not enabled")
            self.goSettngs()
        }
        
    }
    
    @objc func check(){
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                break
            case .restricted, .denied:
                print("No access")
                timer.invalidate()
                self.goSettngs()
                break
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                timer.invalidate()
                let vC : FirstMapViewController = (self.storyboard?.instantiateViewController(withIdentifier: "FirstMapViewController"))! as! FirstMapViewController
                self.navigationController?.pushViewController(vC, animated: true)
                break
            }
        } else {
            print("Location services are not enabled")
            
        }
    }
    

    
    @IBAction func link(_ sender: Any) {
        UIApplication.shared.open(URL.init(string: "https://www.flint-app.com/cgu")!, options: [:], completionHandler: nil)
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            let vC : FirstMapViewController = (self.storyboard?.instantiateViewController(withIdentifier: "FirstMapViewController"))! as! FirstMapViewController
            self.navigationController?.pushViewController(vC, animated: true)
            break
        case .authorizedAlways:
            // If always authorized
            let vC : FirstMapViewController = (self.storyboard?.instantiateViewController(withIdentifier: "FirstMapViewController"))! as! FirstMapViewController
            self.navigationController?.pushViewController(vC, animated: true)
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            self.goSettngs()
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            self.goSettngs()
            break
        
        }
    }

    
    func goSettngs(){
        let alertController = UIAlertController (title: "Géolocation", message: "Aller aux paramètres ?", preferredStyle: .alert)
        
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

    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
}
