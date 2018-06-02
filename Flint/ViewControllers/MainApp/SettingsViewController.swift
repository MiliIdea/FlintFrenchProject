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

class SettingsViewController: UIViewController ,UIScrollViewDelegate{

    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var viewInScroller: UIView!
    
    @IBOutlet weak var butSetMan: UIButton!
    @IBOutlet weak var butSetWoman: UIButton!
    
    @IBOutlet weak var seekSlider: RangeSeekSlider? = RangeSeekSlider()
    
    @IBOutlet weak var SwHaveLighter: UISwitch!
    @IBOutlet weak var SwNewPin: UISwitch!
    @IBOutlet weak var SwInvitationAccepted: UISwitch!
    @IBOutlet weak var SwMessages: UISwitch!
    @IBOutlet weak var SwVibrations: UISwitch!
    @IBOutlet weak var SwSounds: UISwitch!
    
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
        // Do any additional setup after loading the view.
        
        if(GlobalFields.settingsResData != nil){
            self.updateSettings()
        }
        
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
        
        self.lighter = self.SwHaveLighter.isOn
       
        if(butSetMan.titleColor(for: .normal) == UIColor("#0A0A0A")){
            looking_for = 1
        }else{
            looking_for = 0
        }
        
        self.message_notification = self.SwMessages.isOn
        
        self.new_pin_notif = self.SwNewPin.isOn
        
        self.sounds = self.SwSounds.isOn
        
        self.vibration = self.SwVibrations.isOn
        
        self.min_age = Int((self.seekSlider?.selectedMinValue)!)
        
        self.max_age = Int((self.seekSlider?.selectedMaxValue)!)

        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.changeUserSettings, method: .post , parameters: ChangeUserSettingsRequestModel.init(LF: looking_for, NPN: new_pin_notif, L: lighter, IAN: invite_accepted_notification, MN: message_notification, V: vibration, S: sounds, MINA: min_age, MAXA: max_age).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            
            
        }
        
        
    }
    
    @IBAction func setSex(_ sender: Any) {
        if(sender is String){
            if(sender as! String == "man"){
                
                butSetMan.setTitleColor(UIColor("#0A0A0A"), for: .normal)
                
                butSetWoman.setTitleColor(UIColor("#BFBFBF"), for: .normal)
            }else if(sender as! String == "woman"){
                
                butSetMan.setTitleColor(UIColor("#BFBFBF"), for: .normal)
                
                butSetWoman.setTitleColor(UIColor("#0A0A0A"), for: .normal)
            }
        }else{
            if(sender as! UIButton == butSetMan){
                
                butSetMan.setTitleColor(UIColor("#0A0A0A"), for: .normal)
                
                butSetWoman.setTitleColor(UIColor("#BFBFBF"), for: .normal)
            }else if(sender as! UIButton == butSetWoman){
                butSetMan.setTitleColor(UIColor("#BFBFBF"), for: .normal)
                
                butSetWoman.setTitleColor(UIColor("#0A0A0A"), for: .normal)
            }
        }
        
        
    }
    
    @IBAction func setSwitches(_ sender: Any) {
    }
    
    
    @IBAction func openLink(_ sender: Any) {
    }
    
    @IBAction func logout(_ sender: Any) {
        let vC : IntroViewController = (self.storyboard?.instantiateViewController(withIdentifier: "IntroViewController"))! as! IntroViewController
        GlobalFields.USERNAME = ""
        GlobalFields.TOKEN = ""
        GlobalFields.USERNAME = nil
        GlobalFields.TOKEN = nil
        GlobalFields.ID = nil
        GlobalFields.defaults.set(false, forKey: "isRegisterCompleted")
        self.navigationController?.pushViewController(vC, animated: true)
    }

    @IBAction func deleteMyAccount(_ sender: Any) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.deleteAccount, method: .post , parameters: DeleteAccountRequestModel.init().getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            
            if(res?.status == "success"){
                let vC : IntroViewController = (self.storyboard?.instantiateViewController(withIdentifier: "IntroViewController"))! as! IntroViewController
                self.navigationController?.pushViewController(vC, animated: true)
            }
            
        }
        
    }
    
    
    func updateSettings(){
        
        let settings = GlobalFields.settingsResData
        
        self.SwInvitationAccepted.isOn = (settings?.invite_accepted_notification)!
        
        self.SwHaveLighter.isOn = (settings?.lighter)!
        
        if(settings?.looking_for == 1){
            self.setSex("man")
        }else{
            self.setSex("woman")
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
    
    
    
    
}











