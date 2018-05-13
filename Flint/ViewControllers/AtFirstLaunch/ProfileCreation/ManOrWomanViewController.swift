//
//  ManOrWomanViewController.swift
//  flint
//
//  Created by MILAD on 3/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class ManOrWomanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func man(_ sender: Any) {
        
        GlobalFields.userInfo.GENDER = "male"
        let vC : ProfilePicViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ProfilePicViewController"))! as! ProfilePicViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func woman(_ sender: Any) {
        GlobalFields.userInfo.GENDER = "female"
        let vC : ProfilePicViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ProfilePicViewController"))! as! ProfilePicViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    

}
