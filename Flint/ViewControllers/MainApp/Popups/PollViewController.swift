//
//  PollViewController.swift
//  Flint
//
//  Created by MILAD on 4/30/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire

class PollViewController: UIViewController {

    var invite : InviteInfoRes?
    var inviteID : Int?
    
    @IBOutlet var reportButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(invite != nil){
            if(invite?.main?.type == 1 && (invite?.main?.owner?.description)! == (GlobalFields.ID.description)){
                reportButton.alpha = 0
                reportButton.isEnabled = false
            }
        }
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if(invite != nil){
            if(invite?.main?.type == 1 && (invite?.main?.owner?.description)! == (GlobalFields.ID.description)){
                reportButton.alpha = 0
                reportButton.isEnabled = false
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goMessaging(_ sender: Any) {
        let vC : SparksViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SparksViewController"))! as! SparksViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func goProfile(_ sender: Any) {
        let vC : MainProfileViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainProfileViewController"))! as! MainProfileViewController
        self.navigationController?.pushViewController(vC, animated: true)
    }
    
    @IBAction func setPoll(_ sender: Any) {
        // 1:amazing 2:cool 3:notThatGreate
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.afterDatePoll, method: .post , parameters: AfterDatePollRequestModel.init(invite: inviteID!, answer: (sender as! UIButton).tag).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            if(res?.status == "success"){
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    @IBAction func report(_ sender: Any) {
        if(self.invite?.main?.type != nil && self.invite?.main?.type == 1){
            self.navigationController?.popViewController(animated: true)
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        var target : Int = 0
        if(GlobalFields.ID == invite?.main?.owner){
            target = (invite?.users![0].user)!
        }else{
            target = (invite?.main?.owner)!
        }
        
        request(URLs.reportUser, method: .post , parameters: ReportUserRequestModel.init(targetUser: target, reason: 2, txt: "report poll" ).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            if(res?.status == "success"){
                self.navigationController?.popViewController(animated: true)
            }else{
                self.view.makeToast(res?.message)
            }
            
        }
    }

    
}
