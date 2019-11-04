//
//  ViewController.swift
//  camcat
//
//  Created by Sophia Zhu on 2019-10-29.
//  Copyright © 2019 Sophia Zhu. All rights reserved.
//

import UIKit

class PickedImage{
    var data:UIImage?
    static let instance = PickedImage()

    func get() -> PickedImage {
        return .instance
    }
    
    private init(){
        // Do nothing
    }
}

class PickerViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet var imgPreview: UIImageView!
    @IBOutlet var calculateButton: UIButton!
    @IBOutlet var libraryButton: UIButton!
    @IBOutlet var cameraButton: UIButton!
    
    @IBAction func useCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func useLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        imgPreview.contentMode = UIView.ContentMode.scaleAspectFit
        imgPreview.image = info[.originalImage] as? UIImage
        let pickedImage = PickedImage.instance.get()
        pickedImage.data = info[.originalImage] as? UIImage
    }
    
    @IBAction func calculation(_ sender: Any) {
        let pickedImage = PickedImage.instance.get()
        if(pickedImage.data == nil){
            let alert = UIAlertController(title: "Alert", message: "You have to pick an image first!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let mainView = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as! MainViewController
            self.navigationController?.pushViewController(mainView, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        let pickedImage = PickedImage.instance.get()
        if(pickedImage.data == nil){
            imgPreview.contentMode = UIView.ContentMode.center;
            imgPreview.image = UIImage(named: "no_img_indicator.png")!
        }
        calculateButton.layer.borderWidth = 2
        calculateButton.layer.cornerRadius = 10
        calculateButton.layer.borderColor = UIColor.gray.cgColor
        libraryButton.layer.borderWidth = 1
        libraryButton.layer.cornerRadius = 5
        libraryButton.layer.borderColor = UIColor.gray.cgColor
        cameraButton.layer.borderWidth = 1
        cameraButton.layer.cornerRadius = 5
        cameraButton.layer.borderColor = UIColor.gray.cgColor

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}

