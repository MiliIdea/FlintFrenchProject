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

    var invite : Int?
    var targetUser : Int?
    var type : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.getInviteInfo()
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
        request(URLs.afterDatePoll, method: .post , parameters: AfterDatePollRequestModel.init(invite: invite!, answer: (sender as! UIButton).tag).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            if(res?.status == "success"){
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    @IBAction func report(_ sender: Any) {
        if(self.type != nil && self.type == 1){
            self.navigationController?.popViewController(animated: true)
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.reportUser, method: .post , parameters: ReportUserRequestModel.init(targetUser: targetUser!, reason: 6, txt: "datePoll" ).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<LoginRes>>) in
            
            let res = response.result.value
            if(res?.status == "success"){
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
    func getInviteInfo(){
        let l = GlobalFields.showLoading(vc: self)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        request(URLs.getInviteInfo, method: .post , parameters: GetInviteInfoRequestModel.init(invite: invite!).getParams() , headers : ["Content-Type": "application/x-www-form-urlencoded"] ).responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<InviteInfoRes>>) in
            
            let res = response.result.value
            l.disView()
            if(res?.data != nil){
                if(res?.data?.main?.type == 1){
                    self.type = res?.data?.main?.type
                }else{
                    if((res?.data?.main?.owner?.description)! != GlobalFields.ID.description){
                        self.targetUser = (res?.data?.main?.owner)!
                    }else{
                        self.targetUser = res?.data?.users![0].user
                    }
                }
            }
            
        }
    }
    
}