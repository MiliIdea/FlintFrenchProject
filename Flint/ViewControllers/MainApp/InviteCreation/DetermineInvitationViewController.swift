//
//  DetermineInvitationViewController.swift
//  Flint
//
//  Created by MILAD on 4/5/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import CoreLocation
import Alamofire
import CodableAlamofire
import AFDateHelper

class DetermineInvitationViewController: UIViewController {

    
    @IBOutlet weak var activityNameLabel: UILabel!
    
    @IBOutlet weak var positionButton: UIButton!
    
    @IBOutlet weak var timeButton: UIButton!
    
    @IBOutlet weak var numberOfPersonButton: UIButton!
    
    @IBOutlet weak var letsSeeButton: UIButton!
    
    @IBOutlet weak var friendlyButton: UIButton!
    
    @IBOutlet weak var businessButton: UIButton!
    
    @IBOutlet weak var partyButton: UIButton!
    
    
    var isParty : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if(isParty){
            //button party mood bayad namayesh dade beshe
            self.partyButton.alpha = 1
            GlobalFields.inviteMood = "Party"
            GlobalFields.inviteMoodColor = UIColor("#0035CF")
        }else{
            self.partyButton.alpha = 0
            GlobalFields.inviteNumber = 1
        }
        
        
        self.activityNameLabel.layer.borderWidth = 1
        self.activityNameLabel.layer.borderColor = UIColor("#707070").cgColor
        self.activityNameLabel.layer.cornerRadius = self.activityNameLabel.frame.height / 2
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(GlobalFields.inviteAddress != nil){
            positionButton.setTitle(GlobalFields.inviteAddress, for: .normal)
        }else if(GlobalFields.inviteLocation != nil){
            positionButton.setTitle(String(describing: GlobalFields.inviteLocation), for: .normal)
        }
        if(GlobalFields.inviteTitle != nil){
            activityNameLabel.text = GlobalFields.inviteTitle
        }
        
        if(GlobalFields.inviteExactTime != nil  && !self.isParty){
           
            let w = GlobalFields.inviteExactTime
            
            self.timeButton.setTitle(w?.toStringWithRelativeTime(strings : [.nowPast: "Right now" ,.secondsPast: "Right now"]), for: .normal)
            
        }else{
            GlobalFields.inviteExactTime = Date()
            GlobalFields.inviteWhen = 0
        }
        
        if(GlobalFields.inviteExactTime != nil && self.isParty){
//            let dateFormatterGet : DateFormatter = DateFormatter()
//            dateFormatterGet.dateFormat = "dd MMM yyyy - HH:mm"
//            self.timeButton.setTitle(dateFormatterGet.string(from: GlobalFields.inviteExactTime!), for: .normal)
            self.timeButton.setTitle((GlobalFields.inviteExactTime)?.toStringWithRelativeTime(strings : [.nowPast: "Right now" ,.secondsPast: "Right now"]), for: .normal)
        }else{
            GlobalFields.inviteExactTime = Date()
            GlobalFields.inviteWhen = 0
        }
        
        if(GlobalFields.inviteNumber != nil){
            self.numberOfPersonButton.setTitle((GlobalFields.inviteNumber?.description)! + " person", for: .normal)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goSetPosition(_ sender: Any) {
        let vC : SearchViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController"))! as! SearchViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func goSetTime(_ sender: Any) {
        let vC : TimeInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "TimeInvitationViewController"))! as! TimeInvitationViewController
        vC.isParty = self.isParty
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func goSetNumOfPersons(_ sender: Any) {
        if(!isParty){
            return
        }
        let vC : PersonNumberInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PersonNumberInvitationViewController"))! as! PersonNumberInvitationViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func setActivityMood(_ sender: Any) {
        
        var selectedButton : UIButton = sender as! UIButton
        
        if(selectedButton.tag == 1){
            let button2 : UIButton = self.view.viewWithTag(2) as! UIButton
            let button3 : UIButton = self.view.viewWithTag(3) as! UIButton
            selectedButton.backgroundColor = UIColor("#FC8A88")
            button2.backgroundColor = UIColor("#FFF1C6")
            button3.backgroundColor = UIColor("#D0C2A3")
            GlobalFields.inviteMood = "LetsSeeWhatHappens"
            GlobalFields.inviteMoodColor = UIColor("#FC8A88")
        }else if(selectedButton.tag == 2){
            let button2 : UIButton = self.view.viewWithTag(1) as! UIButton
            let button3 : UIButton = self.view.viewWithTag(3) as! UIButton
            selectedButton.backgroundColor = UIColor( "#FFC000")
            button2.backgroundColor = UIColor("#FFBEBE")
            button3.backgroundColor = UIColor("#D0C2A3")
            GlobalFields.inviteMood = "Friendly"
            GlobalFields.inviteMoodColor = UIColor("#FFC000")
        }else if(selectedButton.tag == 3){
            let button2 : UIButton = self.view.viewWithTag(2) as! UIButton
            let button3 : UIButton = self.view.viewWithTag(1) as! UIButton
            selectedButton.backgroundColor = UIColor( "#707070")
            button2.backgroundColor = UIColor( "#FFF1C6")
            button3.backgroundColor = UIColor("#FFBEBE")
            GlobalFields.inviteMood = "Business"
            GlobalFields.inviteMoodColor = UIColor("#707070")
        }
        
    }
    
    
    
    @IBAction func next(_ sender: Any) {
        
        //ag hame chi ok bud ejaze midim bere marhale bad
        if(self.timeButton.title(for: .normal) == "" || self.numberOfPersonButton.title(for: .normal) == "" || self.positionButton.title(for: .normal) == "" || self.positionButton.title(for: .normal) == "Your Position"){
            return
        }
        
        if(!isParty){
            let vC : SetEmojiViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SetEmojiViewController"))! as! SetEmojiViewController
            self.navigationController?.pushViewController(vC, animated: true)
        }else{
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            var type : Int = 1
            
            switch GlobalFields.inviteMood! {
            case "LetsSeeWhatHappens":
                type = 3
                break
            case "Friendly":
                type = 4
                break
            case "Business":
                type = 2
                break
            default:
                type = 1
            }
            
            let date : Date = GlobalFields.inviteExactTime!
            
            request(URLs.createInvitation, method: .post , parameters: CreateInvitationRequestModel.init(type: type, lat: (GlobalFields.inviteLocation?.latitude.description)!, long: (GlobalFields.inviteLocation?.longitude.description)!, peopleCount: GlobalFields.inviteNumber!, exactTime: Int(date.timeIntervalSince1970), when: GlobalFields.inviteWhen!, emoji: GlobalFields.inviteEmoji!, title: GlobalFields.inviteTitle!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<CreateInviteRes>>) in
                
                let res = response.result.value
                
                if(res?.status == "success"){
                    GlobalFields.defaults.set(false, forKey: "reconfirm")
                    GlobalFields.invite = (res?.data?.invite)!
                    
                    request(URLs.getUsersListForInvite, method: .post , parameters: GetUsersListForInviteRequestModel.init(invite: (res?.data?.invite)!, page: 1, perPage: 10, lat: (GlobalFields.inviteLocation?.latitude.description)!, long: (GlobalFields.inviteLocation?.longitude.description)!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<[GetUserListForInviteRes]>>) in
                        
                        let res = response.result.value
                        
                        let vC : MainInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainInvitationViewController"))! as! MainInvitationViewController
                        vC.inviteID = GlobalFields.invite
                        if(res?.data != nil && (res?.data?.count)! > 0){
                            vC.usersList = (res?.data)!
                            vC.viewType = .AddPersonToInvite
                            self.navigationController?.pushViewController(vC, animated: true)
                        }else{
                            //TODO : bayad alert bedim k kasi nis doret
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: FirstMapViewController.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                            return
                        }
                    }
                    
                }else{
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: FirstMapViewController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
            }
        }
    }
    
    
    

}
















