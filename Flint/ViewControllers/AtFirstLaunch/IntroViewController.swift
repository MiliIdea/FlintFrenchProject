//
//  IntroViewController.swift
//  flint
//
//  Created by MILAD on 3/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import DCKit
import FacebookLogin
import FacebookCore

class IntroViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate{

    //MARK: -Fields
    
    @IBOutlet weak var Ititle: UILabel!
    
    @IBOutlet weak var slider: UICollectionView!
    
    @IBOutlet weak var cViaFacebook: DCBorderedButton!
    
    @IBOutlet weak var connectionButton: DCBorderedButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slider.register(UINib(nibName: "IntroCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "IntroCollectionViewCell")
        
        slider.dataSource = self
        slider.delegate = self
     
        LocalNotifications().pushLocalNotification(info: ["mili" : "haminjuri "], title: "", subtitle: "", body: "", timeInterval: .init(10), identifier: "test")
        
        
//        if(GlobalFields.TOKEN != nil && GlobalFields.TOKEN != ""){
//            let vC : FirstMapViewController = (self.storyboard?.instantiateViewController(withIdentifier: "FirstMapViewController"))! as! FirstMapViewController
//    
//            self.navigationController?.pushViewController(vC, animated: true)
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectionViaFacebook(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile , .email], viewController: self){loginResult in
            switch loginResult {
                
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                if(true){
                    let vC : ManOrWomanViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ManOrWomanViewController"))! as! ManOrWomanViewController
                    self.navigationController?.pushViewController(vC, animated: true)
                }
            }
        }
        
        // bad az ink login shod
        // bayad api graph call she
        // bad hameye parameterharo gereft az facebook
        // bad bere b page profilepicView
        
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
            cell.introImage.image = UIImage.init(named: "Img1")
        }else if(indexPath.row == 1){
            cell.introImage.image = UIImage.init(named: "Img2")
        }else if(indexPath.row == 2){
            cell.introImage.image = UIImage.init(named: "Img3")
        }
        print(indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    
}
















