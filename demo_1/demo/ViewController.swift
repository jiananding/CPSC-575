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

class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var text_image: UIImageView!
    @IBOutlet weak var text_result: UILabel!
    
    @IBOutlet weak var num_stack: UIScrollView!
    @IBOutlet weak var equation_text_field: UITextField!
    @IBOutlet weak var result: UILabel!
    
    var picked_image: UIImage = UIImage(named: "hi")!
    var box_position: [CGRect] = []
    var value: [Double] = []
    
    let image_picker = UIImagePickerController()
    
    enum Calculator_error: Error {
        case NSInvalidArguementExceprion
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        text_image.image = picked_image
        image_picker.delegate = self
        equation_text_field.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        create_num_stack()
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
    
    @IBAction func plus_action(_ sender: Any) {
        equation_text_field.text?.append("+ ")
    }
    
    @IBAction func minus_action(_ sender: Any) {
        equation_text_field.text?.append("- ")
    }
    
    @IBAction func multiply_action(_ sender: Any) {
        equation_text_field.text?.append("* ")
    }
    
    @IBAction func divide_action(_ sender: Any) {
        equation_text_field.text?.append("/ ")
    }

    @IBAction func delete_action(_ sender: Any) {
        var text = equation_text_field.text?.split(separator: " ")
        if text!.count >= 1 {
            text?.removeLast()
            var full_text = text?.joined(separator: " ")
            full_text?.append(" ")
            equation_text_field.text = full_text
            calculation()
        }
    }

    func read() {
        let requestHandler = VNImageRequestHandler(data: picked_image.pngData()!, options: [:])
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
                
                let strArr = candidate.string.split(separator: " ")
                let len = strArr.count
                for i in 0..<len {
                    if ((String(strArr[i])).isDouble()) {
                        let k: Double! = Double(strArr[i])
                        self.value.append(k)
                    }
                }
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
    
    func create_num_stack() {
        num_stack.sizeToFit()
        num_stack.layoutIfNeeded()
        num_stack.backgroundColor = .darkGray
        var contentWidth: CGFloat = 0.0
        
        let length = value.count
        let width = (num_stack.frame.width / CGFloat(5.0))
        for i in 0..<length {
            contentWidth += width
            let num_button = UIButton(type: .system)
            num_button.tag = i
            num_button.frame = CGRect(x: width * CGFloat(i) , y: 0, width: width, height: 50)
            num_button.setTitle(String(value[i]), for: .normal)
            num_button.addTarget(self, action: #selector(buttonAction), for: .touchDown)
            num_button.backgroundColor = UIColor.darkGray
            num_stack.addSubview(num_button)
        }
        num_stack.contentSize = CGSize(width: contentWidth, height: 50)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        equation_text_field.text?.append(sender.titleLabel!.text! + " ")
        calculation()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        calculation()
        self.view.endEditing(true)
        return false;
    }
    
    func calculation() {
        if checkRight(equation_text_field.text!) {
            let numericExpression = equation_text_field.text
            let expression = NSExpression(format: numericExpression!)
            let expression_result = expression.expressionValue(with: nil, context: nil) as! NSNumber
            result.text = expression_result.stringValue
        } else {
            result.text = "Error"
        }
    }
    
    func checkRight(_ expression: String) -> Bool {
        let arr = expression.split(separator: " ")
        let le = arr.count
        // the first place cannot be the operator except minus operator and the last place cannot be the operator either.
        if (le == 0) {
            return false
        } else if (le == 1) {
            if (arr[0] == "*" || arr[0] == "/" || arr[0] == "+" ) {
                return false
            }
        } else if (le == 2) { //the first place must be minus operator
            if (arr[0] == "-"){
                if (arr[le - 1] == "*" || arr[le - 1] == "/" || arr[le - 1] == "-" || arr[le - 1] == "+") {
                    return false
                }
            } else {
                return false
            }
        } else if (le >= 3) {
            if (arr[le - 1] == "+" || arr[le - 1] == "-" || arr[le - 1] == "*" || arr[le - 1] == "/") {
                return false
            }
            if (arr[0] == "+" || arr[0] == "*" || arr[0] == "/") {
                return false
            }
            for i in 1..<(le-1) {
                if (arr[i] == "*" || arr[i] == "/" || arr[i] == "+" || arr[i] == "-") {
                    if (arr[i-1] == "*" || arr[i-1] == "/" || arr[i-1] == "+" || arr[i-1] == "-" || arr[i+1] == "*" || arr[i+1] == "/" || arr[i+1] == "+" || arr[i+1] == "-") {
                        return false
                    }
                } else {
                    if ((arr[i-1] != "*" && arr[i-1] != "/" && arr[i-1] != "+" && arr[i-1] != "-") || (arr[i+1] != "*" && arr[i+1] != "/" && arr[i+1] != "+" && arr[i+1] != "-")) {
                        return false
                    }
                }
            }
        }
        return true
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
        equation_text_field.text = ""
        read()
        create_num_stack()
    }
}

extension String {
    func isDouble() -> Bool {
        return (Double(self) != nil)
    }
}
