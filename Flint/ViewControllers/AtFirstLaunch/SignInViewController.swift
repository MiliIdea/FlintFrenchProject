//
//  SignInViewController.swift
//  flint
//
//  Created by MILAD on 3/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire

class SignInViewController: UIViewController {

    //MARK: - Fields
    @IBOutlet weak var emailAddressOrPhone: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    // MARK: - ViewMethodes
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func goForgottenPage(_ sender: Any) {
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let l = GlobalFields.showLoading(vc: self)
        request(URLs.login, method: .post , parameters: LoginRequestModel.init(userName: self.emailAddressOrPhone.text! ,password : self.password.text! ).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            l.disView()
            
            if(res?.data != nil){
                
                GlobalFields.loginResData = res?.data!
                
                GlobalFields.TOKEN = res?.data?.token
                
                GlobalFields.USERNAME = res?.data?.username
                
                let vC : FirstMapViewController = (self.storyboard?.instantiateViewController(withIdentifier: "FirstMapViewController"))! as! FirstMapViewController
                
                
                self.navigationController?.pushViewController(vC, animated: true)
                
            }else{
                //error
            }
            
        }
        
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}
