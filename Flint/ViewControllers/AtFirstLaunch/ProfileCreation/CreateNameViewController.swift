//
//  CreateNameViewController.swift
//  flint
//
//  Created by MILAD on 3/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit

class CreateNameViewController: UIViewController {

    
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func next(_ sender: Any) {
        
        GlobalFields.userInfo.NAME = self.name.text
        
        let vC : BirthDateViewController = (self.storyboard?.instantiateViewController(withIdentifier: "BirthDateViewController"))! as! BirthDateViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    

}
