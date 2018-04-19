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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setDefualtButtons()
        self.titleWithMoodColorLabel.text = GlobalFields.inviteTitle
        self.titleWithMoodColorLabel.layer.borderWidth = 1
        self.titleWithMoodColorLabel.layer.borderColor = UIColor("#707070").cgColor
        self.titleWithMoodColorLabel.layer.cornerRadius = self.titleWithMoodColorLabel.frame.height / 2
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

}









