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
import OneSignal

class SignInViewController: UIViewController {

    //MARK: - Fields
    @IBOutlet weak var emailAddressOrPhone: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    // MARK: - ViewMethodes
    override func viewDidLoad() {
        super.viewDidLoad()
        emailAddressOrPhone.text = ""
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func goForgottenPage(_ sender: Any) {
        let vC : ForgottenIDViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ForgottenIDViewController"))! as! ForgottenIDViewController
        self.navigationController?.pushViewController(vC, animated: true)
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

            if(res?.status == "success" || res?.status == "5"){

                l.disView()
                //inja bayad check kard k ta koja takmil karde

                if(res?.data != nil){

                    GlobalFields.defaults.set(false, forKey: "reconfirm")

                    GlobalFields.loginResData = res?.data!

                    GlobalFields.TOKEN = res?.data?.token

                    GlobalFields.PASSWORD = self.password.text!

                    GlobalFields.USERNAME = res?.data?.username

                    GlobalFields.ID = res?.data?.id


                    let data = res?.data
                    if(data?.name == nil || data?.name == ""){
                        let vC : CreateNameViewController = (self.storyboard?.instantiateViewController(withIdentifier: "CreateNameViewController"))! as! CreateNameViewController
                        GlobalFields.defaults.set(false, forKey: "isRegisterCompleted")
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else if(data?.birthdate == nil){
                        let vC : BirthDateViewController = (self.storyboard?.instantiateViewController(withIdentifier: "BirthDateViewController"))! as! BirthDateViewController
                        GlobalFields.defaults.set(false, forKey: "isRegisterCompleted")
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else if(data?.gender == nil){
                        let vC : ManOrWomanViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ManOrWomanViewController"))! as! ManOrWomanViewController
                        GlobalFields.defaults.set(false, forKey: "isRegisterCompleted")
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else if(data?.avatar == nil || (data?.avatar?.contains("avatar.jpeg"))!){
                        let vC : ProfilePicViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ProfilePicViewController"))! as! ProfilePicViewController
                        GlobalFields.defaults.set(false, forKey: "isRegisterCompleted")
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else if(data?.selfie == nil || (data?.selfie?.contains("avatar.jpeg"))!){
                        let vC : SelfiTrustViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SelfiTrustViewController"))! as! SelfiTrustViewController
                        GlobalFields.defaults.set(false, forKey: "isRegisterCompleted")
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else if(data?.bio == nil){
                        let vC : ProfileBioViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ProfileBioViewController"))! as! ProfileBioViewController
                        GlobalFields.defaults.set(false, forKey: "isRegisterCompleted")
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else if(data?.looking_for == nil){
                        let vC : XViewController = (self.storyboard?.instantiateViewController(withIdentifier: "XViewController"))! as! XViewController
                        GlobalFields.defaults.set(false, forKey: "isRegisterCompleted")
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else if(OneSignal.getPermissionSubscriptionState().permissionStatus.status != .authorized){
                        let vC : NotificationPermissionViewController = (self.storyboard?.instantiateViewController(withIdentifier: "NotificationPermissionViewController"))! as! NotificationPermissionViewController
                        GlobalFields.defaults.set(true, forKey: "isRegisterCompleted")
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else if(!((UIApplication.shared.delegate as? AppDelegate)?.hasLocPermission())!){
                        let vC : LocationPermissionViewController = (self.storyboard?.instantiateViewController(withIdentifier: "LocationPermissionViewController"))! as! LocationPermissionViewController
                        GlobalFields.defaults.set(true, forKey: "isRegisterCompleted")
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else{
                        let vC : FirstMapViewController = (self.storyboard?.instantiateViewController(withIdentifier: "FirstMapViewController"))! as! FirstMapViewController
                        GlobalFields.defaults.set(true, forKey: "isRegisterCompleted")
                        self.navigationController?.pushViewController(vC, animated: true)
                    }
                }else{
                    GlobalFields.USERNAME = ""
                    GlobalFields.TOKEN = ""
                    GlobalFields.PASSWORD = nil
                    GlobalFields.USERNAME = nil
                    GlobalFields.TOKEN = nil
                    GlobalFields.ID = nil
                    GlobalFields.defaults.set(false, forKey: "isRegisterCompleted")
                }



            }else if(res?.errCode == -2){
                let vC : ActivationCodeViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ActivationCodeViewController"))! as! ActivationCodeViewController
                self.navigationController?.pushViewController(vC, animated: true)
            }else{
                self.view.makeToast(res?.message,position : .center)
            }


        }
        
    }
    
    @IBAction func goRegister(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}
