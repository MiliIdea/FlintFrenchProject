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
import TransitionTreasury

class MainProfileViewController: UIViewController ,CLLocationManagerDelegate , UINavigationControllerDelegate{
   
    

    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var jobLabel: UILabel!
    
    @IBOutlet var editButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        editButton.adjustsImageWhenHighlighted = false
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        nameLabel.text = GlobalFields.userInfo.NAME
        if(GlobalFields.userInfo.BIRTHDATE != nil){
            let now = Date()
            let birthday: Date = Date(timeIntervalSince1970: TimeInterval(GlobalFields.userInfo.BIRTHDATE!))
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
            let age = ageComponents.year!
            nameLabel.text = GlobalFields.userInfo.NAME! + " | " + age.description
        }
        self.profilePic.kf.setImage(with: URL(string: URLs.imgServer + (GlobalFields.userInfo.AVATAR)!))
        
        if(GlobalFields.userInfo.JOB != nil && GlobalFields.userInfo.JOB != ""){
            jobLabel.alpha = 1
            jobLabel.text = GlobalFields.userInfo.JOB
        }else if(GlobalFields.userInfo.STUDIES != nil && GlobalFields.userInfo.STUDIES != ""){
            jobLabel.text = GlobalFields.userInfo.STUDIES
            jobLabel.alpha = 1
        }else{
            jobLabel.alpha = 0
        }
        
        self.navigationController?.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.delegate = self
        nameLabel.text = GlobalFields.userInfo.NAME
        if(GlobalFields.userInfo.BIRTHDATE != nil){
            let now = Date()
            let birthday: Date = Date(timeIntervalSince1970: TimeInterval(GlobalFields.userInfo.BIRTHDATE!))
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
            let age = ageComponents.year!
            nameLabel.text = GlobalFields.userInfo.NAME! + " | " + age.description
        }
        self.profilePic.kf.setImage(with: URL(string: URLs.imgServer + (GlobalFields.userInfo.AVATAR)!))
        
        if(GlobalFields.userInfo.JOB != nil && GlobalFields.userInfo.JOB != ""){
            jobLabel.alpha = 1
            jobLabel.text = GlobalFields.userInfo.JOB
        }else if(GlobalFields.userInfo.STUDIES != nil && GlobalFields.userInfo.STUDIES != ""){
            jobLabel.text = GlobalFields.userInfo.STUDIES
            jobLabel.alpha = 1
        }else{
            jobLabel.alpha = 0
        }
    }
    
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if(fromVC.isKind(of: SparksViewController.self)){
            return nil
        }else if(fromVC.isKind(of: FirstMapViewController.self)){
            return nil
        }else if(toVC.isKind(of: SparksViewController.self)){
            let t = TransitionManager()
            t.coef = 1
            return t
        }else if(toVC.isKind(of: FirstMapViewController.self)){
            let t = TransitionManager()
            t.coef = 1
            return t
        }else{
            return nil
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.profilePic.frame.size.height = self.profilePic.frame.width
        self.profilePic.layer.cornerRadius = self.profilePic.frame.width / 2
        self.profilePic.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goShootingPhotoPage(_ sender: Any) {
        UIApplication.shared.open(URL.init(string: "http://iconoclastphoto.com/")!, options: [:], completionHandler: nil)

        
    }
    
    @IBAction func goEditPage(_ sender: Any) {
        
    }
    
    @IBAction func goSetting(_ sender: Any) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let lat = locationManager.location?.coordinate.latitude.description
        let long = locationManager.location?.coordinate.longitude.description
        let l = GlobalFields.showLoading(vc: self)
        request(URLs.getUserSettings, method: .post , parameters: GetUserSettingsRequestModel.init(lat : lat ?? "35.6892",long : long ?? "51.3890").getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<GetSettingsRes>>) in
            
            let res = response.result.value
            l.disView()
            if(res?.status == "success"){
                GlobalFields.settingsResData = res?.data
                
                let vC : SettingsViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController"))! as! SettingsViewController
                self.navigationController?.pushViewController(vC, animated: true)
            }else if(res?.errCode! == -1){
                GlobalFields.USERNAME = ""
                GlobalFields.TOKEN = ""
                GlobalFields.PASSWORD = ""
                GlobalFields.USERNAME = nil
                GlobalFields.TOKEN = nil
                GlobalFields.ID = nil
                GlobalFields.defaults.set(false, forKey: "isRegisterCompleted")
                
                var isInStack = false
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: IntroViewController.self) {
                        isInStack = true
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
                if(!isInStack){
                    let vC : IntroViewController = (self.storyboard?.instantiateViewController(withIdentifier: "IntroViewController"))! as! IntroViewController
                    self.navigationController?.pushViewController(vC, animated: true)
                }
            }else{
                self.view.makeToast(res?.message)
            }
            
        }
        
    }
    
    @IBAction func inviteFriend(_ sender: Any) {
        let text = " J’ai trouvé une application parfaite pour toi ! Télécharge Flint : https://www.flint- app.com/download "


        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    
    @IBAction func goMessaging(_ sender: Any) {
        var isThereBack : Bool = false
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: SparksViewController.self) {
                isThereBack = true
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        if(!isThereBack){
            let vC : SparksViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SparksViewController"))! as! SparksViewController
            self.navigationController?.pushViewController(vC, animated: true)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: FirstMapViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    

}
