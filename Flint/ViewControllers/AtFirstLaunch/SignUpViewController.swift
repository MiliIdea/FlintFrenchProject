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
        if( self.titleNumbOrEmail.text == "Entrez votre numéro de téléphone" ){
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
            
            if(res?.status == "success"){
            
                GlobalFields.USERNAME = res?.data?.username
            
                let vC : ActivationCodeViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ActivationCodeViewController"))! as! ActivationCodeViewController
            
                vC.isForgottenMode = false
                
                self.navigationController?.pushViewController(vC, animated: true)
                
            }else{
                self.view.makeToast(res?.message)
                
                if(res?.errCode! == -5){
                    
                    GlobalFields.USERNAME = self.inputField.text
                    
                    let vC : ActivationCodeViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ActivationCodeViewController"))! as! ActivationCodeViewController
                    
                    vC.isForgottenMode = false
                    
                    self.navigationController?.pushViewController(vC, animated: true)
                }
                
            }
            
        }
        
        
    }
    
    @IBAction func goLoginPage(_ sender: Any) {
        let vC : SignInViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController"))! as! SignInViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    func setMobileNumberMode(){
        self.preNumLabel.alpha = 0
        self.titleNumbOrEmail.text = "Entrez votre numéro de téléphone"
        self.inputField.placeholder = "Numéro téléphone"
        self.Sdescription.text = "Un texto de confirmation vous sera envoyé.Ce numéro vous permettra de vous connectez et de réinitialiser  votre mot de passe le cas échéant."
        self.goAnotherSignUpButton.setTitle("Utilisez votre adresse e-mail", for: .normal)
    }
    
    func setEmailMode(){
        self.preNumLabel.alpha = 0
        self.titleNumbOrEmail.text = "Entrez votre adresse e-mail"
        self.inputField.placeholder = "Adresse e-mail"
        self.Sdescription.text = "Un e-mail de confirmation vous sera envoyé.Cette adresse e-mail vous permettra de vous connectez et de réinitialiser  votre mot de passe le cas échéant."
        self.goAnotherSignUpButton.setTitle("Utilisez votre numéro de téléphone", for: .normal)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}
