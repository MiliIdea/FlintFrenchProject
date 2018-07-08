//
//  IntroViewController.swift
//  flint
//
//  Created by MILAD on 3/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import DCKit
import FBSDKLoginKit
import FBSDKCoreKit
import OneSignal
import Alamofire
import CodableAlamofire

class IntroViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{

    //MARK: -Fields
    @IBOutlet var splashView: UIView!
    
    @IBOutlet weak var Ititle: UILabel!
    
    @IBOutlet weak var slider: UICollectionView!
    
    @IBOutlet weak var cViaFacebook: DCBorderedButton!
    
    @IBOutlet weak var connectionButton: DCBorderedButton!
    
    var l : LoadingViewController = LoadingViewController()
    
    var fbName : String = ""
    
    var fbBirthday : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slider.register(UINib(nibName: "IntroCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "IntroCollectionViewCell")
        
        slider.dataSource = self
        slider.delegate = self
        
        slider.isScrollEnabled = false
        
        print(GlobalFields.TOKEN)

        if(GlobalFields.USERNAME != "" && GlobalFields.TOKEN != "" && GlobalFields.PASSWORD != "" && GlobalFields.defaults.bool(forKey: "isRegisterCompleted")){
            self.splashView.alpha = 1
        }else{
            self.splashView.alpha = 0
        }
        
        cViaFacebook.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        cViaFacebook.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cViaFacebook.layer.shadowOpacity = 1.0
        cViaFacebook.layer.masksToBounds = false
        
        
        connectionButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        connectionButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        connectionButton.layer.shadowOpacity = 1.0
        connectionButton.layer.masksToBounds = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(GlobalFields.USERNAME != "" && GlobalFields.TOKEN != "" && GlobalFields.PASSWORD != "" && GlobalFields.defaults.bool(forKey: "isRegisterCompleted")){
            self.splashView.alpha = 1
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            request(URLs.checkUpdate, method: .post , parameters: [:] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<CheckUpdateRes>>) in
                
                let res = response.result.value
                if(res?.status == "success"){
                    let version = Int(Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as! String)
                    let build = Int(Bundle.main.infoDictionary!["CFBundleVersion"]! as! String)
                    let ss = res?.data?.ios_current_version?.split(separator: ".")
                    let serverVersion = Int(ss![0])
                    let serverBuild = Int(ss![1])
                    if(version! < serverVersion!){
                        
                        self.view.makeToast("Une nouvelle version de l'application est disponible, veuillez la télécharger")
                        UIApplication.shared.open(URL.init(string: (res?.data?.ios_link)!)!, options: [:], completionHandler: nil)
                        
                    }else if(version! == serverVersion!){
                        if(build! < serverBuild!){
                            self.view.makeToast("Une nouvelle version de l'application est disponible, veuillez la télécharger")
                            UIApplication.shared.open(URL.init(string: (res?.data?.ios_link)!)!, options: [:], completionHandler: nil)
                        }else{
                            if(GlobalFields.PASSWORD == "FACEBOOK"){
                                (UIApplication.shared.delegate as? AppDelegate)?.loginWithFaceBook()
                            }else{
                                (UIApplication.shared.delegate as? AppDelegate)?.login()
                            }
                        }
                    }else{
                        if(GlobalFields.PASSWORD == "FACEBOOK"){
                            (UIApplication.shared.delegate as? AppDelegate)?.loginWithFaceBook()
                        }else{
                            (UIApplication.shared.delegate as? AppDelegate)?.login()
                        }
                    }
                    
                }else{
                    self.view.makeToast(res?.message)
                    self.splashView.alpha = 0
                }
                
            }
            
        }else{
            self.splashView.alpha = 0
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func connectionViaFacebook(_ sender: Any) {
        
//        LocalNotifications.sendNotify()
        l = GlobalFields.showLoading(vc: self)
        let loginManager = FBSDKLoginManager()

        if (FBSDKAccessToken.current() != nil) {
            // User is logged in, do work such as go to next view controller.
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,first_name,birthday"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET")
            req?.start(completionHandler: { (connection, result, error) -> Void in
                
                if ((error) != nil)
                {
                    self.l.disView()
                    print("Error: \(String(describing: error))")
                }
                else
                {
                    let data:[String:AnyObject] = result as! [String : AnyObject]
                    print(data)
                    self.fbName = data["first_name"] as! String
                    self.fbBirthday = data["birthday"] as! String
                    self.callLoginWithFacebook(email: data["email"] as! String, token: FBSDKAccessToken.current().tokenString)
                }
            })
            
        }else{
            var login = FBSDKLoginManager()
            login.logIn(withReadPermissions: ["public_profile"], from: self, handler: {(_ result: FBSDKLoginManagerLoginResult?, _ error: Error?) -> Void in
                if error != nil {
                    print("Process error")
//                    b.isEnabled = true
                    self.l.disView()
                } else if result?.isCancelled != nil {
                    print("Cancelled")
//                    b.isEnabled = true
                    self.l.disView()
                } else {
                    print("Logged in!")
//                    b.isEnabled = true

                    let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,first_name,birthday"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET")
                    req?.start(completionHandler: { (connection, result, error) -> Void in
                        
                        if ((error) != nil)
                        {
                            self.l.disView()
                            print("Error: \(String(describing: error))")
                        }
                        else
                        {
                            let data:[String:AnyObject] = result as! [String : AnyObject]
                            print(data)
                            self.fbName = data["first_name"] as! String
                            self.fbBirthday = data["birthday"] as! String
                            self.callLoginWithFacebook(email: data["email"] as! String, token: FBSDKAccessToken.current().tokenString)
                        }
                    })
                    
                }
            })
        }
        
    }
    
    func callLoginWithFacebook(email : String , token : String){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        request(URLs.loginWithFacebook, method: .post , parameters: LoginWithFacebookRequestModel.init(email: email, token: token).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            if(res?.status == "success" || res?.status == "5"){
                self.l.disView()
                //inja bayad check kard k ta koja takmil karde
                
                if(res?.data != nil){
                    
                    GlobalFields.loginResData = res?.data!
                    
                    GlobalFields.TOKEN = res?.data?.token
                    
                    GlobalFields.PASSWORD = "FACEBOOK"
                    
                    GlobalFields.USERNAME = res?.data?.username
                    
                    GlobalFields.ID = res?.data?.id
                    
                    //inja bayad birthday va nameo khodemun por konim
                    GlobalFields.userInfo.NAME = self.fbName
                    
                    let isoDate = self.fbBirthday
                    
                    let dateFormatter = DateFormatter()
                    
                    dateFormatter.dateFormat = "MM/DD/YYYY"
                    
                    let date = dateFormatter.date(from:isoDate)!
                    
                    GlobalFields.userInfo.BIRTHDATE = Int(date.timeIntervalSince1970)
                    
                    let data = res?.data
                    if(data?.gender == nil){
                        let vC : ManOrWomanViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ManOrWomanViewController"))! as! ManOrWomanViewController
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else if(data?.avatar == nil || (data?.avatar?.contains("avatar.jpeg"))!){
                        let vC : ProfilePicViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ProfilePicViewController"))! as! ProfilePicViewController
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else if(data?.selfie == nil || (data?.selfie?.contains("avatar.jpeg"))!){
                        let vC : SelfiTrustViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SelfiTrustViewController"))! as! SelfiTrustViewController
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else if(data?.bio == nil){
                        let vC : ProfileBioViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ProfileBioViewController"))! as! ProfileBioViewController
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else if(data?.looking_for == nil){
                        let vC : XViewController = (self.storyboard?.instantiateViewController(withIdentifier: "XViewController"))! as! XViewController
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else if(OneSignal.getPermissionSubscriptionState().permissionStatus.status != .authorized){
                        let vC : NotificationPermissionViewController = (self.storyboard?.instantiateViewController(withIdentifier: "NotificationPermissionViewController"))! as! NotificationPermissionViewController
                        GlobalFields.defaults.set(true, forKey: "isRegisterCompleted")
                        self.navigationController?.pushViewController(vC, animated: true)
                    }else {
                        let vC : FirstMapViewController = (self.storyboard?.instantiateViewController(withIdentifier: "FirstMapViewController"))! as! FirstMapViewController
                        
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
                
                
                
            }else if (res?.errCode == -2){
                GlobalFields.USERNAME = email
                let vC : ActivationCodeViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ActivationCodeViewController"))! as! ActivationCodeViewController
                self.navigationController?.pushViewController(vC, animated: true)
            }else{
                //inja yani bayad register kone
                self.callRegisterWithFacebook(email: email, token: token)
            }
            
        }
    }
    
    
    func callRegisterWithFacebook(email : String , token : String){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        print(RegisterWithFacebookRequestModel.init(email: email, token: token).getParams())
        request(URLs.registerWithFacebook, method: .post , parameters: RegisterWithFacebookRequestModel.init(email: email, token: token).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<RegisterWithFacebookRes>>) in
            self.l.disView()
            let res = response.result.value
            if(res?.status == "success"){
                
                GlobalFields.TOKEN = res?.data?.token
                
                GlobalFields.USERNAME = res?.data?.username
                
                GlobalFields.ID = res?.data?.id
                
                //inja bayad birthday va nameo khodemun por konim
                GlobalFields.userInfo.NAME = self.fbName
                
                let isoDate = self.fbBirthday
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/DD/YYYY"
                let date = dateFormatter.date(from:isoDate)!
                GlobalFields.userInfo.BIRTHDATE = Int(date.timeIntervalSince1970)
                
                //inja login karde mire dakhel
                let vC : ManOrWomanViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ManOrWomanViewController"))! as! ManOrWomanViewController
                self.navigationController?.pushViewController(vC, animated: true)
            }else{
                //bayad dobare talash kone
            }
            
        }
    }
    
    @IBAction func connection(_ sender: Any) {
        let vC : SignUpViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController"))! as! SignUpViewController
//        let dataSource = DemoChatDataSource(count: 0, pageSize: 50)
//        let viewController = DemoChatViewController()
//        viewController.dataSource = dataSource
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : IntroCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroCollectionViewCell", for: indexPath as IndexPath) as! IntroCollectionViewCell
        
        if(indexPath.row == 0){
            cell.introImage.image = UIImage.init(named: "splash")
        }else if(indexPath.row == 1){
            cell.introImage.image = UIImage.init(named: "Img2")
        }else if(indexPath.row == 2){
            cell.introImage.image = UIImage.init(named: "Img3")
        }
        print(indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width, height: self.slider.frame.height)
    }
    
    
    @IBAction func openLink(_ sender: Any) {
        UIApplication.shared.open(URL.init(string: "https://www.flint-app.com/cgu")!, options: [:], completionHandler: nil)

    }
    
    
}
















