//
//  ViewController.swift
//  demo
//
//  Created by stephen on 2019-10-26.
//  Copyright © 2019 Stephen. All rights reserved.
//

import UIKit
import Vision
import Photos

class ViewController: UIViewController{

    @IBOutlet weak var text_image: UIImageView!
    @IBOutlet weak var text_result: UILabel!
    @IBOutlet weak var croped_section: UIImageView!
    
    var picked_image: UIImage = UIImage(named: "hello")!
    var box_position: [CGRect] = []
    
    let image_picker = UIImagePickerController()
    
    var imageView: UIImageView = UIImageView.init(image: UIImage.init(named: "hello"))
    
    // initial swipe point
    var swipe_start: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var swipe_end: CGPoint = CGPoint(x:0.0, y: 0.0)
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        text_image.image = picked_image
        image_picker.delegate = self

        // gesture sample: swipe, pan, pinch, rotate
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwip(sender:)))
        rightSwipe.direction = .right
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwip(sender:)))
        leftSwipe.direction = .left
        
        let pinchMethod = UIPinchGestureRecognizer(target: self, action: #selector(pinchImage(sender:)))
        
        let panMethod = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        panMethod.minimumNumberOfTouches = 2
//        rightSwipe.require(toFail: panMethod)
//        leftSwipe.require(toFail: panMethod)
//        panMethod.require(toFail: rightSwipe)
//        panMethod.require(toFail: leftSwipe)
        
        text_image.isUserInteractionEnabled = true
        //text_image.addGestureRecognizer(rightSwipe)
        //text_image.addGestureRecognizer(leftSwipe)
        text_image.addGestureRecognizer(pinchMethod)
        text_image.addGestureRecognizer(panMethod)
    }

    @IBAction func select_photo(_ sender: Any) {
        text_result.text = "Result: "
        box_position = []
        image_picker.sourceType = .photoLibrary
        present(image_picker, animated: true, completion: nil)
    }
    @IBAction func take_photo(_ sender: Any) {
        text_result.text = "Result: "
        box_position = []
        image_picker.sourceType = .camera
        present(image_picker, animated: true, completion: nil)
    }
    
    func read(image: UIImage) {
        let requestHandler = VNImageRequestHandler(data: image.pngData()!, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            guard let results = request.results as? [VNRecognizedTextObservation] else {return}
                
            for visionReasult in results {
                let maximumCanadiates = 1
                guard let candidate = visionReasult.topCandidates(maximumCanadiates).first else {
                    continue
                }
                print(candidate.string)
                self.text_result.text?.append(candidate.string + "\n")
                self.box_position.append(visionReasult.boundingBox)
            }
        }
        request.recognitionLevel = .accurate
        request.customWords = []
        request.minimumTextHeight = 0.0 // scale relate to image height
        request.revision = VNRecognizeTextRequestRevision1
        
        try? requestHandler.perform([request])
        //text_image.image = drawRectangleOnImage(image: self.text_image.image!)
    }
    
    
    func drawRectangleOnImage(image: UIImage) -> UIImage {
        let imageSize = image.size
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)

        image.draw(at: CGPoint.zero)

        for position in box_position {
            
            let rectangle = CGRect(x: position.origin.x * imageSize.width, y: (CGFloat(1.0) - position.origin.y) * imageSize.height - position.height * imageSize.height , width: position.width * imageSize.width, height: position.height * imageSize.height)

            UIColor.cyan.setFill()
            UIRectFill(rectangle)
        }

        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    // screen touch position (first touch position)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            print("touch began: \(touch.location(in: self.view))")
            swipe_start = touch.location(in: self.view)
            // do crop image here
            //crop_image(location: touch_location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            //print("touch moved: \(touch.location(in: self.view))")
            //swipe_end = touch.location(in: self.view)
            // do crop image here
            //crop_image(location: touch_location)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            print("touch end: \(touch.location(in: self.view))")
            swipe_end = touch.location(in: self.view)
            // do crop image here
            crop_image()
        }
    }
    
    // siwpe gesture handling
    @objc func handleSwip(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .right:
                view.backgroundColor = .red
            case .left:
                view.backgroundColor = .yellow
            default:
                break
            }
        }
    }
    
    // zoom in or out for text image
    @objc func pinchImage(sender: UIPinchGestureRecognizer) {
        if let scale = (sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)) {
            guard scale.a > 1.0 else {return}
            guard scale.d > 1.0 else {return}
            sender.view?.transform = scale
            sender.scale = 1.0
        }
    }
    
    // handle pan gesture
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let gview = sender.view
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: gview?.superview)
            gview?.center = CGPoint(x: (gview?.center.x)! + translation.x, y: (gview?.center.y)! + translation.y)
            sender.setTranslation(CGPoint.zero, in: gview?.superview)
        }
    }
    
    func crop_image() {
        let screen_shot: UIImage = take_shot()
        let cg_image = screen_shot.cgImage!
        
        var temp = CGRect(x: swipe_start.x, y: swipe_start.y - 50, width: abs(swipe_end.x - swipe_start.x), height: 100)
        var croppedCGImage = cg_image.cropping(to: CGRect(x: swipe_start.x, y: swipe_start.y - 25, width: abs(swipe_end.x - swipe_start.x), height: 50))!
        
        croped_section.image = UIImage(cgImage: croppedCGImage)
        
        //read(image: UIImage(cgImage: croppedCGImage))
    }
    
    func take_shot() -> UIImage {
        var image: UIImage?
        let currentLayer = UIApplication.shared.keyWindow!.layer
        let currentScale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale)
        guard let currentContext = UIGraphicsGetCurrentContext() else {return image!}
        currentLayer.render(in: currentContext)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        picked_image = (info[.originalImage] as? UIImage)!
        text_image.image = picked_image
        // read()
    }
}
