//
//  SelfiTrustViewController.swift
//  flint
//
//  Created by MILAD on 3/23/18.
//  Copyright © 2018 MILAD. All rights reserved.
//

import UIKit
import Gallery
import Alamofire
import CodableAlamofire

class SelfiTrustViewController: UIViewController , GalleryControllerDelegate{
    

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var uploadImage: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func goTakeSelfie(_ sender: Any) {
        
        if(self.uploadImage.title(for: .normal) == "Next"){
            let vC : ProfileBioViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ProfileBioViewController"))! as! ProfileBioViewController
            self.navigationController?.pushViewController(vC, animated: true)
        }else if(uploadImage.title(for: .normal)! == "UPLOAD"){
            uploadSelfieImage()
        }else{
            let gallery = GalleryController()
            gallery.delegate = self
            
            Config.Camera.recordLocation = false
            Config.tabsToShow = [.cameraTab]
            present(gallery, animated: true, completion: nil)
        }
        
    }
    
    func uploadSelfieImage(){
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImagePNGRepresentation(self.image.image!)!, withName: Date().description, fileName: Date().description + ".png", mimeType: "image/png")
        }, to: URLs.uploadImage)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                upload.responseDecodableObject(decoder: decoder) { (response : DataResponse<ResponseModel<UploadImageRes>>) in
                    
                    let res = response.result.value
                    
                    if(res?.status == "success"){
                        GlobalFields.userInfo.SELFIE_IMAGE = res?.data?.name
                        self.uploadImage.setTitle("NEXT", for: .normal)
                    }
                    
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
            }
            
        }
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
        print("select image")
        
        images[0].resolve{ image in
            self.image.image = image
            self.uploadImage.setTitle("UPLOAD", for: .normal)
        }
        
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    

}
