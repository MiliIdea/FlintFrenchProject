//
//  BigPinViewController.swift
//  Flint
//
//  Created by MILAD on 4/22/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import UIColor_Hex_Swift

class BigPinViewController: UIViewController , UITableViewDelegate ,UITableViewDataSource{

    
    @IBOutlet weak var table: UITableView!
    
    var invites : [MyInvites] = [MyInvites]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: "BigPinTableViewCell", bundle: nil), forCellReuseIdentifier: "BigPinTableViewCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goMessaging(_ sender: Any) {
    }
    
    @IBAction func goProfile(_ sender: Any) {
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: -tableView delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(Int(invites.count / 3) * 3 == invites.count){
            return Int(invites.count / 3)
        }else{
            return Int(invites.count / 3) + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116 / 675 * self.view.frame.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "BigPinTableViewCell" , for: indexPath) as! BigPinTableViewCell
        
        cell.b1.tag = indexPath.row * 3 + 0
        cell.b2.tag = indexPath.row * 3 + 1
        cell.b3.tag = indexPath.row * 3 + 2
        
        cell.b1.frame.size.height = cell.b1.frame.width
        cell.b1.layer.cornerRadius = cell.b1.frame.height / 2
        cell.b2.frame.size.height = cell.b1.frame.width
        cell.b2.layer.cornerRadius = cell.b1.frame.height / 2
        cell.b3.frame.size.height = cell.b1.frame.width
        cell.b3.layer.cornerRadius = cell.b1.frame.height / 2
        
        cell.b1.borderWidth = 2
        cell.b2.borderWidth = 2
        cell.b3.borderWidth = 2
        
        if(indexPath.row * 3 + 0 < invites.count){
            cell.b1.alpha = 1
            cell.b1.setTitle(String(UnicodeScalar(Int(invites[indexPath.row * 3 + 0].emoji!.split(separator: "{")[1].split(separator: "}")[0], radix: 16)!)!) , for: .normal)
            cell.b1.normalBorderColor = UIColor(getColorBorder(type: indexPath.row * 3 + 0))
            cell.b1.addTarget(self, action:  #selector(self.connected(sender:)), for: .touchUpInside)
        }else{
            cell.b1.alpha = 0
        }
        
        if(indexPath.row * 3 + 1 < invites.count){
            cell.b2.alpha = 1
            cell.b2.setTitle(String(UnicodeScalar(Int(invites[indexPath.row * 3 + 1].emoji!.split(separator: "{")[1].split(separator: "}")[0], radix: 16)!)!) , for: .normal)
            cell.b2.normalBorderColor = UIColor(getColorBorder(type: indexPath.row * 3 + 1))
            cell.b2.addTarget(self, action: #selector(self.connected(sender:)), for: .touchUpInside)
        }else{
            cell.b2.alpha = 0
        }
        
        if(indexPath.row * 3 + 2 < invites.count){
            cell.b3.alpha = 1
            cell.b3.setTitle(String(UnicodeScalar(Int(invites[indexPath.row * 3 + 2].emoji!.split(separator: "{")[1].split(separator: "}")[0], radix: 16)!)!) , for: .normal)
            cell.b3.normalBorderColor = UIColor(getColorBorder(type: indexPath.row * 3 + 2))
            cell.b3.addTarget(self, action: #selector(self.connected(sender:)), for: .touchUpInside)
        }else{
            cell.b3.alpha = 0
        }
        
        return cell
    }
    
    func getColorBorder(type : Int) -> String{
        switch type {
        case 1:
            return "#0035CF"
        case 2://fr
            return "#FFBE00"
        case 3://love
            return "#FF7877"
        case 4://bus
            return "#858585"
        default:
            return "#FF7877"
        }
    }

    @objc func connected(sender: UIButton){
        
        let p = invites[sender.tag]
        let vC : MainInvitationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "MainInvitationViewController"))! as! MainInvitationViewController
        
        if(p.type == 1){
            vC.viewType = .PartyInviteAcception
        }else{
            vC.viewType = .NormalInviteAcception
        }
        GlobalFields.myInvite = p
        self.navigationController?.pushViewController(vC, animated: true)
        
    }
    
    

}










