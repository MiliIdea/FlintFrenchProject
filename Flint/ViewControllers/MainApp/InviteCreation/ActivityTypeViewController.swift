//
//  ActivityTypeViewController.swift
//  Flint
//
//  Created by MILAD on 4/5/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class ActivityTypeViewController: UIViewController  , UITextFieldDelegate{

    
    @IBOutlet weak var activityNameTextView: UITextField!
    
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet var extraCharacterPopupView: UIView!
    
    @IBOutlet var flintL: UILabel!
    
    var emoji : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editButtons(v: self.view)
        
        activityNameTextView.delegate = self
        
        nextButton.titleLabel?.numberOfLines = 1
        nextButton.titleLabel?.minimumScaleFactor = 0.5
        nextButton.titleLabel?.adjustsFontSizeToFitWidth = true
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ActivityTypeViewController.tapFunction))
        flintL.isUserInteractionEnabled = true
        flintL.addGestureRecognizer(tap)
    }

    @objc func tapFunction(sender:UITapGestureRecognizer) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: FirstMapViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickOnActivityType(_ sender: Any) {
        var button : UIButton = sender as! UIButton
        
        self.activityNameTextView.text = (self.view.viewWithTag(button.tag + 1) as! UILabel).text
        self.emoji = button.title(for: .normal)!
        GlobalFields.inviteEmoji = self.emoji
        
    }
    
    
    @IBAction func next(_ sender: Any) {
        if(emoji == "" || self.activityNameTextView.text == ""){
            self.view.makeToast("pls fill all fields")
            return
        }else if((self.activityNameTextView.text?.count)! > 30){
            return
        }
        let vC : DetermineInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "DetermineInvitationViewController"))! as! DetermineInvitationViewController
        GlobalFields.inviteEmoji = emoji
        GlobalFields.inviteTitle = self.activityNameTextView.text!
        if(emoji == "🎉"){
            vC.isParty = true
        }else{
            vC.isParty = false
        }
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func goProfile(_ sender: Any) {
        let vC : MainProfileViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainProfileViewController"))! as! MainProfileViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func goMessaging(_ sender: Any) {
        let vC : MainProfileViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainProfileViewController"))! as! MainProfileViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    func editButtons(v : UIView){
        if( v.tag == 1 || v.tag == 3 || v.tag == 5 || v.tag == 7 || v.tag == 9 || v.tag == 11 || v.tag == 13 || v.tag == 15){
            (v as! UIButton).titleLabel?.numberOfLines = 1
            (v as! UIButton).titleLabel?.minimumScaleFactor = 0.5
            (v as! UIButton).titleLabel?.adjustsFontSizeToFitWidth = true
        }
        for sv in v.subviews {
            editButtons(v: sv)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print(activityNameTextView.text!.count)
        if(activityNameTextView.text!.count > 30){
            self.extraCharacterPopupView.alpha = 1
        }else{
            self.extraCharacterPopupView.alpha = 0
        }
    }
    
}
