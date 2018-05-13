//
//  SignUpViewController.swift
//  flint
//
//  Created by MILAD on 3/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {

    //MARK: -Fields
    
    @IBOutlet weak var titleNumbOrEmail: UILabel!
    
    @IBOutlet weak var preNumLabel: UILabel!
    
    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var Sdescription: UILabel!
    
    @IBOutlet weak var goAnotherSignUpButton: UIButton!
    
    
    //MARK: -View Methodes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -Methodes

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goAnotherSignUp(_ sender: Any) {
        if( self.titleNumbOrEmail.text == "Enter your phone number" ){
            setEmailMode()
        }else{
            setMobileNumberMode()
        }
    }
    
    @IBAction func next(_ sender: Any) {
        //send data to server and go to activation view
        
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.register, method: .post , parameters: RegisterRequestModel.init(userName: self.inputField.text , password: "123456").getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<RegisterRes>>) in
            
            let res = response.result.value
            
            GlobalFields.USERNAME = res?.data?.username
            
            let vC : ActivationCodeViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ActivationCodeViewController"))! as! ActivationCodeViewController
            
            self.navigationController?.pushViewController(vC, animated: true)
            
        }
        
        
    }
    
    @IBAction func goLoginPage(_ sender: Any) {
        let vC : SignInViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController"))! as! SignInViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    func setMobileNumberMode(){
        self.preNumLabel.alpha = 0
        self.titleNumbOrEmail.text = "Enter your phone number"
        self.inputField.placeholder = "Phone number"
        self.Sdescription.text = "A tdxt confirmation will be sent to you. This phone number will allow you to connect or reset your password if need be"
        self.goAnotherSignUpButton.setTitle("Use your e-mail adress", for: .normal)
    }
    
    func setEmailMode(){
        self.preNumLabel.alpha = 0
        self.titleNumbOrEmail.text = "Enter your e-mail adress"
        self.inputField.placeholder = "E-mail adress"
        self.Sdescription.text = "An e-mail of confirmation will be sent to you. This e-mail adress will allow you to connect or reset your password if need be."
        self.goAnotherSignUpButton.setTitle("Use your phone number", for: .normal)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}
