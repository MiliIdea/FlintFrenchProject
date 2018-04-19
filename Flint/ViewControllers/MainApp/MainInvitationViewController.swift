//
//  MainInvitationViewController.swift
//  Flint
//
//  Created by MILAD on 4/5/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import DCKit

class MainInvitationViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var likeButton: DCBorderedButton!
    
    @IBOutlet weak var superLikeButton: DCBorderedButton!
    
    @IBOutlet weak var dislikeButton: DCBorderedButton!
    
    @IBOutlet weak var inviteTitle: UILabel!
    
    @IBOutlet weak var inviteNumber: UILabel!
    
    @IBOutlet weak var invitePosition: UILabel!
    
    @IBOutlet weak var inviteTime: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var usersList : [GetUserListForInviteRes] = [GetUserListForInviteRes]()
    
    var presentIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        collectionView.register(UINib(nibName: "FirsPageInvitationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FirsPageInvitationCollectionViewCell")
        
        collectionView.register(UINib(nibName: "PartyPageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PartyPageCollectionViewCell")
        
        collectionView.register(UINib(nibName: "DescriptionPageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DescriptionPageCollectionViewCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        self.inviteTitle.text = GlobalFields.inviteTitle
        self.inviteTitle.layer.borderWidth = 1
        self.inviteTitle.layer.borderColor = GlobalFields.inviteMoodColor?.cgColor
        self.inviteTitle.backgroundColor = UIColor.clear
        
        inviteNumber.text = (GlobalFields.inviteNumber?.description)! + " person"
        
        invitePosition.text = GlobalFields.inviteAddress
        
        let w = GlobalFields.inviteWhen
        if(w == 0){
            self.inviteTime.text = "Right now"
        }else{
            let date : Date = Date().addingTimeInterval(Double(w!) * 60.0 * 30.0)
            let dateFormatterGet : DateFormatter = DateFormatter()
            dateFormatterGet.dateFormat = "HH:mm"
            self.inviteTime.text = dateFormatterGet.string(from: date)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.inviteTitle.layer.cornerRadius = self.inviteTitle.frame.height / 2
        self.inviteTitle.layer.backgroundColor = GlobalFields.inviteMoodColor?.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goMessaging(_ sender: Any) {
    }
    
    @IBAction func goProfile(_ sender: Any) {
    }
    
    @IBAction func like(_ sender: Any) {
    }
    
    @IBAction func dislike(_ sender: Any) {
    }
    
    @IBAction func superLike(_ sender: Any) {
    }
    
    
    
    // MARK : collection delegate
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell1 : FirsPageInvitationCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirsPageInvitationCollectionViewCell", for: indexPath as IndexPath) as! FirsPageInvitationCollectionViewCell
        let cell2 : PartyPageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PartyPageCollectionViewCell", for: indexPath as IndexPath) as! PartyPageCollectionViewCell
        let cell3 : DescriptionPageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionPageCollectionViewCell", for: indexPath as IndexPath) as! DescriptionPageCollectionViewCell
        
        
        
        
        
        
        
        return cell1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func calculateCollectionPageNumber() -> Int{
        return 1
    }
    
}
