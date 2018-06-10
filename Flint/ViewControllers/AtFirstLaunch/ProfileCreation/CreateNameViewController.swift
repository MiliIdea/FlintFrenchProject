//
//  CreateNameViewController.swift
//  flint
//
//  Created by MILAD on 3/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Toast_Swift

class CreateNameViewController: UIViewController{

    
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.addTarget(self, action: "textFieldDidChange:", for: UIControlEvents.editingChanged)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func next(_ sender: Any) {
        
        if(name.text == ""){
            self.view.makeToast("please fill input field!")
            return
        }
        
        GlobalFields.userInfo.NAME = self.name.text
        
        let vC : BirthDateViewController = (self.storyboard?.instantiateViewController(withIdentifier: "BirthDateViewController"))! as! BirthDateViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if(name.text?.contains(" "))!{
            name.text?.removeLast()
        }
    }
    

}
