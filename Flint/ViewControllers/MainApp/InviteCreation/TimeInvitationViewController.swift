//
//  TimeInvitationViewController.swift
//  Flint
//
//  Created by MILAD on 4/5/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import DCKit
import UIColor_Hex_Swift

class TimeInvitationViewController: UIViewController {
    
    var when : Int = 0
    
    @IBOutlet weak var rightNowButton: DCBorderedButton!
    
    @IBOutlet weak var titleWithMoodColorLabel: UILabel!
    
    @IBOutlet weak var b1: DCBorderedButton!
    @IBOutlet weak var b2: DCBorderedButton!
    @IBOutlet weak var b3: DCBorderedButton!
    @IBOutlet weak var b4: DCBorderedButton!
    @IBOutlet weak var b5: DCBorderedButton!
    @IBOutlet weak var b6: DCBorderedButton!
    
    var isParty : Bool = false
    
    @IBOutlet weak var partyModeView: UIView!
    
    @IBOutlet weak var rightNowButtonParty: DCBorderedButton!
    
    @IBOutlet weak var dateButton: DCBorderedButton!
    
    @IBOutlet weak var hourButton: DCBorderedButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var tikButton: UIButton!
    
    var partyIsRightNow : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setDefualtButtons()
        self.titleWithMoodColorLabel.text = GlobalFields.inviteTitle
        self.titleWithMoodColorLabel.layer.borderWidth = 1
        self.titleWithMoodColorLabel.layer.borderColor = UIColor("#707070").cgColor
        self.titleWithMoodColorLabel.layer.cornerRadius = self.titleWithMoodColorLabel.frame.height / 2
        
        
        if(isParty){
            self.partyModeView.alpha = 1
            self.datePicker.alpha = 0
            self.tikButton.alpha = 1
            self.rightNowPartyAct("")
        }else{
            self.partyModeView.alpha = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setWhen(_ sender: Any) {
        
        setDefualtButtons()
        let b : DCBorderedButton = sender as! DCBorderedButton
        b.backgroundColor = UIColor("#68A0FF")
        b.normalBackgroundColor = UIColor("#68A0FF")
        b.borderWidth = 1
        b.normalBorderColor = UIColor("#68A0FF")
        b.normalTextColor = UIColor("#FFFFFF")
        
        GlobalFields.inviteExactTime = Date().addingTimeInterval(Double(b.tag - 1) * 60.0 * 30.0)
        GlobalFields.inviteWhen = b.tag - 1
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func goProfile(_ sender: Any) {
        let vC : MainProfileViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainProfileViewController"))! as! MainProfileViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func goMessaging(_ sender: Any) {
        let vC : MainProfileViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainProfileViewController"))! as! MainProfileViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    func setDefualtButtons(){
        
        for i in 1...7 {
            let b : DCBorderedButton = self.view.viewWithTag(i) as! DCBorderedButton
            b.backgroundColor = UIColor("#FFFFFF")
            b.normalBackgroundColor = UIColor("#FFFFFF")
            b.borderWidth = 1
            b.normalBorderColor = UIColor("#707070")
            b.normalTextColor = UIColor("#707070")
        }
        
    }
    
    @IBAction func rightNowPartyAct(_ sender: Any) {
        self.rightNowButtonParty.normalTextColor = UIColor("#67A0FF")
        self.dateButton.normalTextColor = UIColor("#949494")
        self.hourButton.normalTextColor = UIColor("#949494")
        self.partyIsRightNow = true
    }
    
    @IBAction func showDatePicker(_ sender: Any) {
        self.rightNowButtonParty.normalTextColor = UIColor("#949494")
        self.dateButton.normalTextColor = UIColor("#67A0FF")
        self.hourButton.normalTextColor = UIColor("#67A0FF")
        self.datePicker.alpha = 1
        self.tikButton.alpha = 0
        self.partyIsRightNow = false
    }
    
    @IBAction func setDateAndTimeParty(_ sender: Any) {
        if(self.partyIsRightNow){
            GlobalFields.inviteExactTime = Date()
            GlobalFields.inviteWhen = 0
        }else{
            GlobalFields.inviteExactTime = self.datePicker.date
            GlobalFields.inviteWhen = 7
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        
        self.datePicker.alpha = 0
        self.tikButton.alpha = 1
        
    }
    
    @IBAction func setDatePickerParty(_ sender: Any) {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let strDate = dateFormatter.string(from: datePicker.date)
        self.dateButton.setTitle(strDate, for: .normal)
        let dateFormatter2 : DateFormatter = DateFormatter()
        dateFormatter2.dateFormat = "HH : mm"
        let strDate2 = dateFormatter.string(from: datePicker.date)
        self.hourButton.setTitle(strDate2, for: .normal)
    }
    
}









