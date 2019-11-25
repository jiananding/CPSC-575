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

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var text_result: UILabel!
    @IBOutlet weak var croped_section: UIImageView!
    
    var imgData: UIImage = UIImage(named: "hello")!
    var box_position: [CGRect] = []
    
    let image_picker = UIImagePickerController()
    
    var imageView: UIImageView = UIImageView.init(image: UIImage.init(named: "hello"))
    
    // initial swipe point
    var swipe_start: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var swipe_end: CGPoint = CGPoint(x:0.0, y: 0.0)
  
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = imgData
        image_picker.delegate = self
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
    }
    
    // screen touch position (first touch position)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            print("touch began1: \(touch.location(in: imgView))")
            swipe_start = touch.location(in: imgView)
            swipe_start = (self.imgView?.convert(swipe_start, to: self.view))!
            swipe_start = getTappedPointOnImg(tappedPoint: swipe_start)
            print("touch began2: \(touch.location(in: self.view))")

        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            print("touch end: \(touch.location(in: self.view))")
            swipe_end = touch.location(in: self.view)
            swipe_end.y -= 20
            swipe_end = getTappedPointOnImg(tappedPoint: swipe_end)
            // do crop image here
            crop_image()
        }
    }
    
    func getTappedPointOnImg(tappedPoint: CGPoint) -> CGPoint{  //Get the coordinates of tapped point on image
        var x,y :CGFloat
        if (imgView.frame.size.height/imgView.frame.size.width > imgData.size.height/imgData.size.width){
            let imgX = imgView.frame.origin.x
            let imgY = imgView.frame.origin.y + (imgView.frame.height - (imgView.frame.width / imgData.size.width)*imgData.size.height) / 2
            let imgWidth = imgView.frame.width
            let imgHeight = imgView.frame.height - (imgView.frame.width / imgData.size.width)*imgData.size.height
            x = imgData.size.width*(tappedPoint.x - imgX)/imgWidth
            y = imgData.size.height*(tappedPoint.y - imgY)/imgHeight
        }
        else{
            let imgX = imgView.frame.origin.x + (imgView.frame.width - (imgView.frame.height / imgData.size.height)*imgData.size.width) / 2
            let imgY = imgView.frame.origin.y
            let imgWidth = imgView.frame.width - (imgView.frame.height / imgData.size.height)*imgData.size.width
            let imgHeight = imgView.frame.height
            x = imgData.size.width*(tappedPoint.x - imgX)/imgWidth
            y = imgData.size.height*(tappedPoint.y - imgY)/imgHeight
        }
        let tapped = CGPoint(x: x, y: y)
        return tapped
    }
    
    
    func crop_image() {
        let screen_shot: UIImage = imgData
        let cg_image = screen_shot.cgImage!
    
        if swipe_start != swipe_end {
            let croppedCGImage = cg_image.cropping(to: CGRect(x: swipe_start.x, y: swipe_start.y - 25, width: abs(swipe_end.x - swipe_start.x), height: 50))!
            croped_section.image = UIImage(cgImage: croppedCGImage)
            read(image: UIImage(cgImage: croppedCGImage))
        }
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
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        imgData = (info[.originalImage] as? UIImage)!
        imgView.image = imgData
        // read()
    }
}
