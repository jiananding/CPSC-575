//
//  ViewController.swift
//  camcat
//
//  Created by Sophia Zhu on 2019-10-29.
//  Copyright © 2019 Sophia Zhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet var photo: UIImageView!
    @IBOutlet var takePhotoButton: UIButton!
    
    
    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            print("inside")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
        print("out")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        photo.image = info[.originalImage] as? UIImage
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let photo = UIImagePickerController()
//        photo.delegate = self
//        photo.sourceType = UIImagePickerController.SourceType.camera
//        photo.allowsEditing = true
//        self.present(photo, animated: true){}
    }
    
    


}

