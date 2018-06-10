//
//  ProfileBioViewController.swift
//  flint
//
//  Created by MILAD on 3/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Toast_Swift

class ProfileBioViewController: UIViewController , UITextViewDelegate{

    
    @IBOutlet weak var bioText: UITextView!
    
    @IBOutlet weak var charController: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bioText.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        if(!checkValidation()){
            return
        }
        GlobalFields.userInfo.BIO = self.bioText.text
        let vC : XViewController = (self.storyboard?.instantiateViewController(withIdentifier: "XViewController"))! as! XViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    func checkValidation() -> Bool{
        if(self.bioText.text.isEmpty){
            self.view.makeToast("pls write more than 10 characters")
            return false
        }else if(self.bioText.text.characters.count < 10){
            self.view.makeToast("pls write more than 10 characters")
            return false
        }else{
            return true
        }        
        
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.view.endEditing(true)
    }
    

    func textViewDidChange(_ textView: UITextView) {
        print(bioText.text!.count)
        if(bioText.text!.count > 450){
            bioText.text?.removeLast(bioText.text!.count - 450)
        }
        self.charController.text = (450 - bioText.text!.count).description
    }
    

}
