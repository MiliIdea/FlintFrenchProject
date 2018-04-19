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

class DetermineInvitationViewController: UIViewController {

    
    @IBOutlet weak var activityNameLabel: UILabel!
    
    @IBOutlet weak var positionButton: UIButton!
    
    @IBOutlet weak var timeButton: UIButton!
    
    @IBOutlet weak var numberOfPersonButton: UIButton!
    
    @IBOutlet weak var letsSeeButton: UIButton!
    
    @IBOutlet weak var friendlyButton: UIButton!
    
    @IBOutlet weak var businessButton: UIButton!
    
    
    
    var isParty : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(isParty){
            //button party mood bayad namayesh dade beshe
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
        
        if(GlobalFields.inviteWhen != nil){
           
            let w = GlobalFields.inviteWhen
            if(w == 0){
                self.timeButton.setTitle("Right now", for: .normal)
            }else{
                let date : Date = Date().addingTimeInterval(Double(w!) * 60.0 * 30.0)
                let dateFormatterGet : DateFormatter = DateFormatter()
                dateFormatterGet.dateFormat = "HH:mm"
                self.timeButton.setTitle(dateFormatterGet.string(from: date), for: .normal)
            }
            
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
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func goSetNumOfPersons(_ sender: Any) {
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
        if(self.timeButton.title(for: .normal) == "" || self.numberOfPersonButton.title(for: .normal) == "" || self.positionButton.title(for: .normal) == ""){
            return
        }
        
        let vC : SetEmojiViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SetEmojiViewController"))! as! SetEmojiViewController
        self.navigationController?.pushViewController(vC, animated: true)
        
    }
    
    
    

}
















