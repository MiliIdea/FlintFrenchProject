//
//  ActivationCodeViewController.swift
//  flint
//
//  Created by MILAD on 3/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import Alamofire
import CodableAlamofire

class ActivationCodeViewController: UIViewController, UITextFieldDelegate {

    //MARK : - Fields
    
    @IBOutlet weak var topTitle: UILabel!
    
    @IBOutlet weak var Adescription: UILabel!
    
    @IBOutlet weak var goLoginButton: UIButton!
    
    var actCode : String = ""
    
    var isForgottenMode : Bool = false
    
    var userNameFromForgotten : String = ""
    
    //MARK : - View Methodes
    override func viewDidLoad() {
        super.viewDidLoad()

        setTargetForAllView(view: view)
        
        if(isForgottenMode){
            self.topTitle.text = "Reset"
            self.Adescription.alpha = 0
            self.goLoginButton.alpha = 0
            self.view.backgroundColor = UIColor("#FFFFFF")
            self.view.viewWithTag(1)?.backgroundColor = UIColor("#F7F7F7")
            self.view.viewWithTag(2)?.backgroundColor = UIColor("#F7F7F7")
            self.view.viewWithTag(3)?.backgroundColor = UIColor("#F7F7F7")
            self.view.viewWithTag(4)?.backgroundColor = UIColor("#F7F7F7")
            self.view.viewWithTag(5)?.backgroundColor = UIColor("#F7F7F7")
            self.view.viewWithTag(6)?.backgroundColor = UIColor("#F7F7F7")
        }else{
            self.topTitle.text = "Inscription"
            self.Adescription.alpha = 1
            self.goLoginButton.alpha = 1
            self.view.backgroundColor = UIColor("#F7F7F7")
            self.view.viewWithTag(1)?.backgroundColor = UIColor("#FFFFFF")
            self.view.viewWithTag(2)?.backgroundColor = UIColor("#FFFFFF")
            self.view.viewWithTag(3)?.backgroundColor = UIColor("#FFFFFF")
            self.view.viewWithTag(4)?.backgroundColor = UIColor("#FFFFFF")
            self.view.viewWithTag(5)?.backgroundColor = UIColor("#FFFFFF")
            self.view.viewWithTag(6)?.backgroundColor = UIColor("#FFFFFF")
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
  
    
    @IBAction func resendCode(_ sender: Any) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        var use : String = ""
        if(isForgottenMode){
            use = self.userNameFromForgotten
        }else{
            use = GlobalFields.USERNAME
        }
        request(URLs.resendActivationCode, method: .post , parameters: ForgotPasswordRequestModel.init(username : use).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            
            if(res?.status == "success"){

                self.view.makeToast(res?.message)
            }
            
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let l = GlobalFields.showLoading(vc: self)
        var use : String = ""
        if(isForgottenMode){
            use = self.userNameFromForgotten
        }else{
            use = GlobalFields.USERNAME
        }
        request(URLs.activeUser, method: .post , parameters: ActiveUserRequestModel.init(userName: use, code: actCode).getParams(), headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<ActivationRes>>) in
            l.disView()
            let res = response.result.value
            if(res?.status == "success"){
                GlobalFields.TOKEN = res?.data?.token
                let vC : PasswordViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PasswordViewController"))! as! PasswordViewController
                if(self.isForgottenMode){
                    vC.isFromForgottenMode = true
                    vC.activeCode = self.actCode
                }else{
                    vC.isFromForgottenMode = false
                }
                self.navigationController?.pushViewController(vC, animated: true)
            }else{
                self.view.makeToast(res?.message)
            }
            
            
        }
        
        
        
    }
    
    @IBAction func goLogin(_ sender: Any) {
        let vC : SignInViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController"))! as! SignInViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    
    //MARK : - ActivationCode Methodes

    @objc func textChanged(sender: Any!) {
        
        print("changed")
        
        let t = (sender as! UITextField)
        
        if(t.tag < 6){
            
            t.backgroundColor = UIColor("#FFFFFF")
            (self.view.viewWithTag(t.tag + 1) as! UITextField).becomeFirstResponder()
            
        }else if(t.tag == 6){
            
            self.view.endEditing(true)
            
            //send code
            t.backgroundColor = UIColor("#FFFFFF")
            
            var code : String = ""
            
            for i in 1...6 {
                
                code.append((self.view.viewWithTag(i) as! UITextField).text!)
                
                self.actCode = code
                self.view.endEditing(true)
                
            }
            
            next("")
            
        }
        
    }
    
    @objc func textSelected(sender: Any!) {
        
        print("changed")
        
        let t = (sender as! UITextField)
        
        t.text = ""
        
        t.backgroundColor = UIColor("#FFD964")
        
    }
    
    
    func setTargetForAllView(view : UIView){
        
        for v in view.subviews{
            
            if(v is UITextField){
                
                var t: UITextField = v as! UITextField
                
                t.delegate = self
                
                t.addTarget(
                    nil,
                    action: #selector(self.textChanged(sender:)),
                    for: UIControlEvents.editingChanged
                )
                
                t.addTarget(
                    nil,
                    action: #selector(self.textSelected(sender:)),
                    for: UIControlEvents.editingDidBegin
                )
            }
            
            if(v.subviews.count != 0){
                
                self.setTargetForAllView(view: v)
                
            }else{
                
                if(v is UITextField){
                    
                    var t: UITextField = v as! UITextField
                    
                    t.delegate = self
                    
                    t.addTarget(
                        nil,
                        action: #selector(self.textChanged(sender:)),
                        for: UIControlEvents.editingChanged
                    )
                    
                    t.addTarget(
                        nil,
                        action: #selector(self.textSelected(sender:)),
                        for: UIControlEvents.editingDidBegin
                    )
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.view.endEditing(true)
    }
    

}
