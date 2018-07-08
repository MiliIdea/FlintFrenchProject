//
//  SettingsViewController.swift
//  flint
//
//  Created by MILAD on 3/24/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import RangeSeekSlider
import Alamofire
import CodableAlamofire
import McPicker
import Toast_Swift

class SettingsViewController: UIViewController ,UIScrollViewDelegate , RangeSeekSliderDelegate{

    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var viewInScroller: UIView!
    
    @IBOutlet weak var butSetMan: UIButton!
    @IBOutlet weak var butSetWoman: UIButton!
    
    @IBOutlet weak var seekSlider: RangeSeekSlider? = RangeSeekSlider()
    
    @IBOutlet weak var SwNewPin: UISwitch!
    @IBOutlet weak var SwInvitationAccepted: UISwitch!
    @IBOutlet weak var SwMessages: UISwitch!
    @IBOutlet weak var SwVibrations: UISwitch!
    @IBOutlet weak var SwSounds: UISwitch!
    
    @IBOutlet var community: UIButton!
    @IBOutlet var policy: UIButton!
    
    @IBOutlet var versionLabel: UILabel!
    
    
    
    var picker : McPicker = McPicker.init(data: [["Un homme", "Une femme" ,"Les deux"]])
    var looking_for : Int = 0
    var new_pin_notif : Bool = false
    var lighter : Bool = false
    var invite_accepted_notification : Bool = false
    var message_notification : Bool = false
    var vibration : Bool = false
    var sounds : Bool = false
    var min_age : Int = 0
    var max_age : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(viewInScroller.frame.height)
        self.scroller.delegate = self
        scroller.contentSize = CGSize(width: self.view.frame.width, height: 2059 * self.view.frame.height / 667)
        self.viewInScroller.frame.origin.y = 0
        // Do any additional setup after loading the view.
        
        if(GlobalFields.settingsResData != nil){
            self.updateSettings()
        }
        
        community.titleLabel?.numberOfLines = 1
        community.titleLabel?.minimumScaleFactor = 0.5
        community.titleLabel?.adjustsFontSizeToFitWidth = true
        policy.titleLabel?.numberOfLines = 1
        policy.titleLabel?.minimumScaleFactor = 0.5
        policy.titleLabel?.adjustsFontSizeToFitWidth = true
        seekSlider?.delegate = self
        
        self.versionLabel.text = "V" + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)  + "." + (Bundle.main.infoDictionary?["CFBundleVersion"] as! String)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func setSettings(_ sender: Any) {
        
        self.invite_accepted_notification = self.SwInvitationAccepted.isOn
        
//        self.lighter = self.SwHaveLighter.isOn
       
        if(butSetMan.title(for: .normal) == "Un homme"){
            looking_for = 0
        }else if(butSetMan.title(for: .normal) == "Une femme"){
            looking_for = 1
        }else if(butSetMan.title(for: .normal) == "Les deux"){
            looking_for = 2
        }
        
        self.message_notification = self.SwMessages.isOn
        
        self.new_pin_notif = self.SwNewPin.isOn
        
        self.sounds = self.SwSounds.isOn
        
        self.vibration = self.SwVibrations.isOn
        
        self.min_age = Int((self.seekSlider?.selectedMinValue)!)
        
        self.max_age = Int((self.seekSlider?.selectedMaxValue)!)

        let l = GlobalFields.showLoading(vc: self)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.changeUserSettings, method: .post , parameters: ChangeUserSettingsRequestModel.init(LF: looking_for, NPN: new_pin_notif, L: lighter, IAN: invite_accepted_notification, MN: message_notification, V: vibration, S: sounds, MINA: min_age, MAXA: max_age).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            l.disView()
            let res = response.result.value
            if(res?.status == "success"){
                self.navigationController?.popViewController(animated: true)
            }else{
                self.view.makeToast(res?.message)
            }
            
        }
        
        
    }
    
    @IBAction func setSex(_ sender: Any) {
        
        
        
        if(sender is String){
            if(sender as! String == "0"){
                
                butSetMan.setTitle("Un homme", for: .normal)
                picker.pickerSelectRowsForComponents = [0 : [0 : false]]
                
            }else if(sender as! String == "1" ){
                
                butSetMan.setTitle("Une femme", for: .normal)
                picker.pickerSelectRowsForComponents = [0 : [1 : false]]
                
            }else if(sender as! String == "2" ){
                
                butSetMan.setTitle("Les deux", for: .normal)
                picker.pickerSelectRowsForComponents = [0 : [2 : false]]
            }
        }else{
            
            picker.show() {  [weak self] (selections: [Int : String]) -> Void in
                
                if let male = selections[0] {
                    self?.butSetMan.setTitle(male, for: .normal)
                }
                
                if let female = selections[1] {
                    self?.butSetMan.setTitle(female, for: .normal)
                }
                
                if let together = selections[2] {
                    self?.butSetMan.setTitle(together, for: .normal)
                }
                
            }
        }
        
        
    }
    
    @IBAction func setSwitches(_ sender: Any) {
    }
    
    
    @IBAction func openLink(_ sender: Any) {
        
        let b : UIButton = sender as! UIButton
        
        switch b.tag {
            
        case 11:
             UIApplication.shared.open(URL.init(string: "https://www.flint-app.com/help")!, options: [:], completionHandler: nil)
        case 12:
             UIApplication.shared.open(URL.init(string: "https://www.flint-app.com/regles-de-la-communaute")!, options: [:], completionHandler: nil)
        case 13:
            UIApplication.shared.open(URL.init(string: "https://www.flint-app.com/cgu")!, options: [:], completionHandler: nil)
        case 14:
             UIApplication.shared.open(URL.init(string: "https://www.flint-app.com/cgu")!, options: [:], completionHandler: nil)
        case 15:
             UIApplication.shared.open(URL.init(string: "https://itunes.apple.com/us/app/flint/id1377334495?ls=1&mt=8")!, options: [:], completionHandler: nil)
            
        default:
             UIApplication.shared.open(URL.init(string: "https://itunes.apple.com/us/app/flint/id1377334495?ls=1&mt=8")!, options: [:], completionHandler: nil)
        }
        
    }
    
    @IBAction func logout(_ sender: Any) {

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let l = GlobalFields.showLoading(vc: self)
        request(URLs.logout, method: .post , parameters: UploadImageRequestModel.init().getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            l.disView()
            let res = response.result.value
            if(res?.status == "success"){
                GlobalFields.USERNAME = ""
                GlobalFields.TOKEN = ""
                GlobalFields.PASSWORD = nil
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
                    
                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    var homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
                    var nav = UINavigationController(rootViewController: homeViewController)
                    nav.setNavigationBarHidden(true, animated: false)
                    nav.setToolbarHidden(true, animated: false)
                    appdelegate.window!.rootViewController = nav
                }
            }else{
                self.view.makeToast(res?.message)
            }
            
        }
        
    }

    @IBAction func deleteMyAccount(_ sender: Any) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let l = GlobalFields.showLoading(vc: self)
        request(URLs.deleteAccount, method: .post , parameters: DeleteAccountRequestModel.init().getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            l.disView()
            let res = response.result.value
            
            if(res?.status == "success"){
                
                GlobalFields.USERNAME = ""
                GlobalFields.TOKEN = ""
                GlobalFields.PASSWORD = nil
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
                    
                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    var homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
                    var nav = UINavigationController(rootViewController: homeViewController)
                    nav.setNavigationBarHidden(true, animated: false)
                    nav.setToolbarHidden(true, animated: false)
                    appdelegate.window!.rootViewController = nav
                }
            }else{
                self.view.makeToast(res?.message)
            }
            
        }
        
    }
    
    
    func updateSettings(){
        
        let settings = GlobalFields.settingsResData
        
        self.SwInvitationAccepted.isOn = (settings?.invite_accepted_notification)!
        
//        self.SwHaveLighter.isOn = (settings?.lighter)!
        //0 mard 1 zan 2 joftesh
        if(settings?.looking_for == 0){
            self.setSex("0")
        }else if(settings?.looking_for == 1){
            self.setSex("1")
        }else{
            self.setSex("2")
        }
        
        self.SwMessages.isOn = (settings?.message_notification)!
        
        self.SwNewPin.isOn = (settings?.new_pin_notif)!
        
        self.SwSounds.isOn = (settings?.sounds)!
        
        self.SwVibrations.isOn = (settings?.vibration)!
        
        let minAge = settings?.min_age
        let maxAge = settings?.max_age
        
        self.seekSlider?.selectedMinValue = CGFloat.init(minAge!)
        self.seekSlider?.selectedMaxValue = CGFloat.init(maxAge!)
        
        
    }
    
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMaxValue maxValue: CGFloat) -> String? {
        if(slider.selectedMaxValue < 55){
            return Int(slider.selectedMaxValue).description
        }else{
            return "+55"
        }
        
    }
    
}











