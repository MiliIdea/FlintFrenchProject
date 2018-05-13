//
//  ForgottenIDViewController.swift
//  flint
//
//  Created by MILAD on 3/24/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire

class ForgottenIDViewController: UIViewController {

    @IBOutlet weak var inputField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func next(_ sender: Any) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.forgotPassword, method: .post , parameters: ForgotPasswordRequestModel.init(username : self.inputField.text!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            
            if(res?.status == "success"){
                let vC : ActivationCodeViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ActivationCodeViewController"))! as! ActivationCodeViewController
                vC.userNameFromForgotten = self.inputField.text!
                self.navigationController?.pushViewController(vC, animated: true)
            }
            
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
