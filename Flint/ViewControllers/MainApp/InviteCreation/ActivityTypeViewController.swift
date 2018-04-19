//
//  ActivityTypeViewController.swift
//  Flint
//
//  Created by MILAD on 4/5/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class ActivityTypeViewController: UIViewController {

    
    @IBOutlet weak var activityNameTextView: UITextField!
    
    var emoji : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickOnActivityType(_ sender: Any) {
        var button : UIButton = sender as! UIButton
        
        self.activityNameTextView.text = (self.view.viewWithTag(button.tag + 1) as! UILabel).text
        self.emoji = button.title(for: .normal)!
        
    }
    
    
    @IBAction func next(_ sender: Any) {
        if(emoji == "" || self.activityNameTextView.text == ""){
            return
        }
        let vC : DetermineInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "DetermineInvitationViewController"))! as! DetermineInvitationViewController
        GlobalFields.inviteEmoji = emoji
        GlobalFields.inviteTitle = self.activityNameTextView.text!
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
    
}
