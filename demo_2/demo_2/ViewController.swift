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
    
    var picked_image: UIImage = UIImage(named: "hello")!
    var box_position: [CGRect] = []
    
    let image_picker = UIImagePickerController()
    
    var imageView: UIImageView = UIImageView.init(image: UIImage.init(named: "hello"))
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        text_image.image = picked_image
        image_picker.delegate = self
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan")
        self.text_image.addGestureRecognizer(gestureRecognizer)
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
    
    func read() {
        let requestHandler = VNImageRequestHandler(data: text_image.image!.pngData()!, options: [:])
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
        text_image.image = drawRectangleOnImage(image: self.text_image.image!)
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
            //print(touch.location(in: view))
        }
    }
    
    func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began {
            print(gestureRecognizer.translation(in: self.text_image))
        }
        
        if gestureRecognizer.state == .changed {
            print(gestureRecognizer.translation(in: self.text_image))
        }
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
