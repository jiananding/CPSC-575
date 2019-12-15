//
//  ViewController.swift
//  camcat
//
//  Created by Sophia Zhu on 2019-10-29.
//  Copyright © 2019 Sophia Zhu. All rights reserved.
//  References: https://stackoverflow.com/questions/39450124/swift-programmatically-navigate-to-another-view-controller-scene/39450328
//  https://freakycoder.com/ios-notes-8-how-to-show-hide-navigation-bar-in-vc-e3df5c0f0c6e
//  https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E6%95%99%E5%AE%A4/%E9%97%9C%E6%96%BCswift%E9%A0%81%E9%9D%A2%E5%82%B3%E5%80%BC%E7%9A%84%E9%82%A3%E4%BA%9B%E4%BA%8B-fdeff54f31e4
//

import UIKit

class PickedImage{
    var data:UIImage?
    static let instance = PickedImage()
    static var camera = Bool()
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
    @IBOutlet var activityView: UIActivityIndicatorView!
    
    var count = 1
    var camera = Bool() // true for camera, fasle for library
    
    @IBAction func useCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
            camera = true
        }
    }
    
    @IBAction func useLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
            camera = false
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        imgPreview.contentMode = UIView.ContentMode.scaleAspectFit
        imgPreview.image = info[.originalImage] as? UIImage
        let pickedImage = PickedImage.instance.get()
        pickedImage.data = info[.originalImage] as? UIImage
        PickedImage.camera = camera
    }
    
    @IBAction func calculation(_ sender: Any) {
        let pickedImage = PickedImage.instance.get()
        if(pickedImage.data == nil){
            let alert = UIAlertController(title: "Alert", message: "You have to pick an image first!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.view.bringSubviewToFront(activityView);
            activityView.isHidden = false
            activityView.startAnimating()
            var seconds = 0.1
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                let mainView = self.storyboard?.instantiateViewController(withIdentifier: "mainView") as! MainViewController
                self.navigationController?.pushViewController(mainView, animated: true)
            }
            
            seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.activityView.isHidden = true
                self.activityView.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if count == 1{
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = false
                present(imagePicker, animated: true, completion: nil)
                camera = true
                }
            self.count = 0
        }
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
        activityView.color = .systemOrange
        activityView.transform = CGAffineTransform.init(scaleX: 2, y: 2)
        activityView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}

