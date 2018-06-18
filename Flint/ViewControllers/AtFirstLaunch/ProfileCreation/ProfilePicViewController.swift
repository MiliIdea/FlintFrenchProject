//
//  ProfilePicViewController.swift
//  flint
//
//  Created by MILAD on 3/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Gallery
import IGRPhotoTweaks
import Alamofire
import CodableAlamofire

class ProfilePicViewController: UIViewController ,GalleryControllerDelegate , IGRPhotoTweakViewControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    var cropVC = IGRPhotoTweakViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadButton.setTitle("CHOISISSEZ IMAGE", for: .normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        
        if(uploadButton.title(for: .normal)! == "SUIVANT"){
            let vC : SelfiTrustViewController = (self.storyboard?.instantiateViewController(withIdentifier: "SelfiTrustViewController"))! as! SelfiTrustViewController
            self.navigationController?.pushViewController(vC, animated: true)
        }else if(uploadButton.title(for: .normal)! == "UPLOAD"){
            uploadImage()
        }else if(uploadButton.title(for: .normal)! == "CHOISISSEZ IMAGE"){
            let gallery = GalleryController()
            gallery.delegate = self
            
            Config.Camera.recordLocation = false
            Config.tabsToShow = [.imageTab]
            present(gallery, animated: true, completion: nil)
        }
        
    }
    
    
    func uploadImage(){
        
        let l = GlobalFields.showLoading(vc: self)
        var parameters = Dictionary<String , String>()
        parameters = ["token" : GlobalFields.TOKEN , "username" : GlobalFields.USERNAME ]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if  let imageData = GlobalFields.compressImage(image: self.imageView.image!) {
                multipartFormData.append(imageData, withName: "submit", fileName: Date().timeIntervalSince1970.description + ".png", mimeType: "image/png")
            }
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to: URLs.uploadImage , method : .post , headers : parameters)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                upload.responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<UploadImageRes>>) in
                    
                    l.disView()
                    let res = response.result.value
                    
                    if(res?.status == "success"){
                        GlobalFields.userInfo.AVATAR = res?.data?.name
                        self.uploadButton.setTitle("SUIVANT", for: .normal)
                    }
                    
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
            }
            
        }
    }
    
    
    
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        print("cancel")
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
        print("select image")
        
        images[0].resolve{ image in
            let cropViewController = IGRPhotoTweakViewController()
            cropViewController.image = image
            cropViewController.delegate = self
            self.cropVC.delegate = self
            cropViewController.setCropAspectRect(aspect: "200:200")
            cropViewController.lockAspectRatio(true)
            let button = UIButton(type: .system) // let preferred over var here
            button.frame = CGRect.init(x: self.view.frame.width - 100, y: self.view.frame.height - 100, width: 100, height: 100)
            button.layer.cornerRadius = 50
            button.backgroundColor = UIColor.white
            button.setTitle("", for: .normal)
            button.setBackgroundImage(UIImage.init(named: "Groupe 1484"), for: .normal)
            button.tag = 777
            button.addTarget(self, action: #selector(self.cropAction), for: UIControlEvents.touchUpInside)
            cropViewController.view.addSubview(button)
            self.cropVC = cropViewController
            self.navigationController?.pushViewController(self.cropVC, animated: true)
        }
        
    }
    
    @objc func cropAction(){
        self.cropVC.cropAction()
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        print("request light box")
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        print("select video")
        
    }
    
    
    
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage) {
        self.imageView?.image = croppedImage
        uploadButton.setTitle("UPLOAD", for: .normal)
        _ = controller.navigationController?.popViewController(animated: true)
        
    }
    
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController) {
        _ = controller.navigationController?.popViewController(animated: true)
    }

}
