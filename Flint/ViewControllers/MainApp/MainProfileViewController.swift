//
//  MainProfileViewController.swift
//  flint
//
//  Created by MILAD on 3/24/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import CodableAlamofire
import Alamofire
import CoreLocation
import Kingfisher

class MainProfileViewController: UIViewController ,CLLocationManagerDelegate{

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var jobLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profilePic.frame.size.height = self.profilePic.frame.width
        
        self.profilePic.layer.cornerRadius = self.profilePic.frame.height / 2
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.profilePic.frame.size.height = self.profilePic.frame.width
        self.profilePic.layer.cornerRadius = self.profilePic.frame.width / 2
        self.profilePic.kf.setImage(with: URL(string: URLs.imgServer + (GlobalFields.loginResData?.avatar)!))
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goShootingPhotoPage(_ sender: Any) {
    }
    
    @IBAction func goEditPage(_ sender: Any) {
    }
    
    @IBAction func goSetting(_ sender: Any) {
        
        
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let lat = locationManager.location?.coordinate.latitude.description
        let long = locationManager.location?.coordinate.longitude.description
        
        request(URLs.getUserSettings, method: .post , parameters: GetUserSettingsRequestModel.init(lat : lat!,long : long!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<GetSettingsRes>>) in
            
            let res = response.result.value
            
            GlobalFields.settingsResData = res?.data
            
            let vC : SettingsViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController"))! as! SettingsViewController
            self.navigationController?.pushViewController(vC, animated: true)
            
        }
        
    }
    
    @IBAction func inviteFriend(_ sender: Any) {
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    
    @IBAction func goMessaging(_ sender: Any) {
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
