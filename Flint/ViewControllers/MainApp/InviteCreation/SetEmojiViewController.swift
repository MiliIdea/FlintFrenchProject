//
//  SetEmojiViewController.swift
//  Flint
//
//  Created by MILAD on 4/19/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import ISEmojiView
import Alamofire
import CodableAlamofire
import AFDateHelper
import Toast_Swift


class SetEmojiViewController: UIViewController ,ISEmojiViewDelegate{

    @IBOutlet weak var inviteTitle: UILabel!
    
    @IBOutlet weak var inviteNumber: UILabel!
    
    @IBOutlet weak var invitePosition: UILabel!
    
    @IBOutlet weak var inviteTime: UILabel!
    
    @IBOutlet weak var emojiTextView: UITextView!
    
    @IBOutlet weak var pinImage: UIImageView!
    
    var page : Int = 1
    
    @IBOutlet var flintL: UILabel!
    
    let emojiView = ISEmojiView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emojiView.delegate = self
        
        emojiTextView.inputView = emojiView
        
        self.inviteTitle.text = GlobalFields.inviteTitle
        self.inviteTitle.layer.borderWidth = 1
        self.inviteTitle.layer.borderColor = GlobalFields.inviteMoodColor?.cgColor
        self.inviteTitle.backgroundColor = UIColor.clear
        
        inviteNumber.text = (GlobalFields.inviteNumber?.description)! + " personne"
        
        invitePosition.text = GlobalFields.inviteAddress
        
        let w = GlobalFields.inviteExactTime
        
        self.inviteTime.text = w?.toStringWithRelativeTime(strings: [.nowPast : "maintenant ",.secondsPast: "Maintenant",.minutesPast: "Maintenant"])
        
        
        switch GlobalFields.inviteMood! {
        case "LetsSeeWhatHappens":
            self.pinImage.image = UIImage.init(named: "pin_pink")
        case "Friendly":
            self.pinImage.image = UIImage.init(named: "pin_yellow")
        case "Business":
            self.pinImage.image = UIImage.init(named: "pin_gray")
        default:
            self.pinImage.image = UIImage.init(named: "pin_blue")
        }
        
        if(GlobalFields.inviteEmoji != nil && GlobalFields.inviteEmoji != ""){
            self.emojiTextView.text = GlobalFields.inviteEmoji!
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SetEmojiViewController.tapFunction))
        flintL.isUserInteractionEnabled = true
        flintL.addGestureRecognizer(tap)
        
        self.emojiTextView.frame.size = CGSize.init(width: (93 / 115) * self.pinImage.frame.width, height: (93 / 168) * self.pinImage.frame.height)
        
        self.emojiTextView.frame.origin.x = self.pinImage.frame.origin.x + (self.pinImage.frame.width / 2) - (self.emojiTextView.frame.width / 2)
        
        self.emojiTextView.frame.origin.y = self.pinImage.frame.origin.y + ((8 / 168) * self.pinImage.frame.height)
        
        self.emojiTextView.tintColor = UIColor.clear
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: FirstMapViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.inviteTitle.layer.cornerRadius = self.inviteTitle.frame.height / 2
        self.inviteTitle.layer.backgroundColor = GlobalFields.inviteMoodColor?.cgColor
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func next(_ sender: Any) {
        
        if(emojiTextView.text == ""){
            self.view.makeToast("Veuillez sélectionner un emoji.")
            return
        }
        
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
        
//        var diff : Int = 7
//
//        if(Date().timeIntervalSince(date) < 30 * 60 * 6){
//           diff = Int(Date().timeIntervalSince(date) / (60 * 30))
//        }
        if(GlobalFields.inviteLocation == nil){
//            self.view.makeToast("pls check your location settings")
            self.view.makeToast("s'il vous plaît vérifier vos paramètres de localisation")
            
        }else{
            request(URLs.createInvitation, method: .post , parameters: CreateInvitationRequestModel.init(type: type, lat: (GlobalFields.inviteLocation?.latitude.description)!, long: (GlobalFields.inviteLocation?.longitude.description)!, peopleCount: GlobalFields.inviteNumber!, exactTime: Int(date.timeIntervalSince1970), when: GlobalFields.inviteWhen!, emoji: GlobalFields.inviteEmoji!, title: GlobalFields.inviteTitle!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<CreateInviteRes>>) in
                
                let res = response.result.value
                
                if(res?.status == "success"){
                    GlobalFields.defaults.set(false, forKey: "reconfirm")
                    GlobalFields.invite = (res?.data?.invite)!
                    
                    request(URLs.getUsersListForInvite, method: .post , parameters: GetUsersListForInviteRequestModel.init(invite: (res?.data?.invite)!, page: 1, perPage: 100, lat: (GlobalFields.inviteLocation?.latitude.description)!, long: (GlobalFields.inviteLocation?.longitude.description)!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<[GetUserListForInviteRes]>>) in
                        
                        let res = response.result.value
                        
                        let vC : MainInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainInvitationViewController"))! as! MainInvitationViewController
                        vC.inviteID = GlobalFields.invite
                        if(res?.data != nil && (res?.data?.count)! > 0){
                            vC.usersList = (res?.data)!
                            vC.viewType = .AddPersonToInvite
                            self.navigationController?.pushViewController(vC, animated: true)
                        }else{
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
    
    @IBAction func goProfile(_ sender: Any) {
        let vC : MainProfileViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainProfileViewController"))! as! MainProfileViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func goMessaging(_ sender: Any) {
        let vC : MainProfileViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainProfileViewController"))! as! MainProfileViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    // callback when tap a emoji on keyboard
    func emojiViewDidSelectEmoji(emojiView: ISEmojiView, emoji: String) {
        emojiTextView.text = ""
        emojiTextView.insertText(emoji)
        GlobalFields.inviteEmoji = emojiTextView.text
        dismiss("")
    }
    
    // callback when tap delete button on keyboard
    func emojiViewDidPressDeleteButton(emojiView: ISEmojiView) {
        emojiTextView.deleteBackward()
    }
    
    @IBAction func backToDetermine(_ sender: Any) {
        GlobalFields.inviteMood == ""
        self.navigationController?.popViewController(animated: true)
    }
}
