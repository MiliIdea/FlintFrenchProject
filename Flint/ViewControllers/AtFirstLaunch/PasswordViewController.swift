//
//  PasswordViewController.swift
//  flint
//
//  Created by MILAD on 3/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import Toast_Swift

class PasswordViewController: UIViewController {

    //MARK: - Fields
    
    @IBOutlet weak var topTitle: UILabel!
    
    @IBOutlet weak var Ptitle: UILabel!
    
    @IBOutlet weak var goLoginButton: UIButton!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    var isFromForgottenMode : Bool = false
    
    var activeCode : String = ""
    
    //MARK: - ViewMethodes
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(isFromForgottenMode){
            self.view.backgroundColor = UIColor("#F7F7F7")
            password.backgroundColor = UIColor("#F7F7F7")
            confirmPassword.backgroundColor = UIColor("#F7F7F7")
            self.goLoginButton.alpha = 0
        }else{
            self.view.backgroundColor = UIColor("#FFFFFF")
            password.backgroundColor = UIColor("#FFFFFF")
            confirmPassword.backgroundColor = UIColor("#FFFFFF")
            self.goLoginButton.alpha = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        if(checkEqualPassword()){
            
            if(isFromForgottenMode){
                let l = GlobalFields.showLoading(vc: self)
                request(URLs.resetPassword, method: .post , parameters: ResetPasswordRequestModel.init(userName: GlobalFields.USERNAME , password: self.password.text!, code: self.activeCode).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<ChangePassRes>>) in
                    
                    let res = response.result.value
                    l.disView()
                    if(res?.status == "success"){
                        GlobalFields.PASSWORD = self.password.text!
                        let vC : SignInViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController"))! as! SignInViewController
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else{
                        self.view.makeToast(res?.message)
                    }
                    
                }
            }else{
                let l = GlobalFields.showLoading(vc: self)
                request(URLs.changePassword, method: .post , parameters: ChangeUserPasswordRequestModel.init(userName: GlobalFields.USERNAME , password: self.password.text!, token: GlobalFields.TOKEN).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<ChangePassRes>>) in
                    
                    let res = response.result.value
                    l.disView()
                    if(res?.status == "success"){
                        GlobalFields.PASSWORD = self.password.text!
                        let vC : CreateNameViewController = (self.storyboard?.instantiateViewController(withIdentifier: "CreateNameViewController"))! as! CreateNameViewController
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else{
                        self.view.makeToast(res?.message)
                    }
                    
                }
            }
            
        }else{
            //TODO alert check password
            self.view.makeToast("Check your password")
        }
        
    }
    
    func checkEqualPassword() -> Bool{
        if(password.text == confirmPassword.text){
            return true
        }else{
            return false
        }
    }
    
    
    @IBAction func goLogin(_ sender: Any) {
        let vC : SignInViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController"))! as! SignInViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
}
