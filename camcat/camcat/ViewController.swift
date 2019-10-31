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
    @IBOutlet var checkButton: UIButton!
    
    let defaultUser = UserDefaults.standard
    
    
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
        let imageData = photo.image?.pngData()
        defaultUser.set(imageData, forKey: "photo data")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        if defaultUser.value(forKey: "photo data") != nil{
            
        }
    }
    
    func setUp(){
        checkButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        checkButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        takePhotoButton.layer.cornerRadius = takePhotoButton.frame.size.width/2
    }
}

