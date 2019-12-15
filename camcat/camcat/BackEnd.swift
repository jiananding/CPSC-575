//
//  BackEnd.swift
//  camcat
//
//  Created by stephen on 2019-11-03.
//  Copyright © 2019 Sophia Zhu. All rights reserved.
//

// Reference:
// developer.apple.com/videos/play/wwdc2019/234/

import UIKit
import Foundation
import Vision

struct Box {
    var position: CGRect
    var nums: [String]
}

class BackEnd {
    var box_position: [Box] = []
    var real_box_position: [Box] = []
    var value: [Double] = []
    var result: String = ""
    var mode: String = "+"
        
    let pickedImage = PickedImage.instance.get().data
    //let image = UIImage(named: "download")
   
    func read() {
        var requestHandler: VNImageRequestHandler
        print(PickedImage.camera)
        if PickedImage.camera {
            requestHandler = VNImageRequestHandler(data: pickedImage!.pngData()!, orientation: .right ,options: [:])
        } else {
            requestHandler = VNImageRequestHandler(data: pickedImage!.pngData()!,options: [:])
        }
              
        let request = VNRecognizeTextRequest { (request, error) in
            guard let results = request.results as? [VNRecognizedTextObservation] else {return}
                 
            for visionReasult in results {
                let maximumCanadiates = 1
                guard let candidate = visionReasult.topCandidates(maximumCanadiates).first else {
                    continue
                }
                
                var arr: [String] = []
                let strArr = candidate.string.split(separator: " ")
                let len = strArr.count
                for i in 0..<len {
                    if ((String(strArr[i])).isDouble()) {
                        //let k: Double! = Double(strArr[i])
                        arr.append(String(strArr[i]))
                    }
                }
                if (!arr.isEmpty) {
                    let temp_box = Box(position: visionReasult.boundingBox, nums: arr)
                    self.box_position.append(temp_box)
                }
            }
        }
        request.recognitionLevel = .accurate
        request.customWords = []
        request.minimumTextHeight = 0.0 // scale relate to image height
        request.revision = VNRecognizeTextRequestRevision1

        try? requestHandler.perform([request])
     }
    
    // Do the calculation
    func calculation(_ equation: String) {
        if equation.isEmpty {
            result = "0"
            return
        }
        
        if checkRight(equation) {
            //let numericExpression = equation
            let numericExpression = changeExpression(equation)
            let expression = NSExpression(format: numericExpression)
            let expression_result = expression.expressionValue(with: nil, context: nil) as! NSNumber
            result = expression_result.stringValue
        } else {
            result = "?"
        }
    }
    
    // Change the "÷" and "x" into "/" and the "*"
    func changeExpression(_ equation: String) -> String {
        var arr = equation.map{String($0)}
        let le = arr.count
        for i in 0..<le {
            if (arr[i] == "÷") {
                arr[i] = "/"
            }
            if (arr[i] == "\u{00D7}") {
                arr[i] = "*"
            }
        }
        let equ = arr.joined()
        return equ
    }
    
    // Check the equation is right or not
    func checkRight(_ expression: String) -> Bool {
        let expressionC = changeExpression(expression)
        if let result = ExpressionEvaluator.getValue(expressionC){
            return true
        }else{
            return false
        }
    }
    
    func check_box(pts: CGPoint) -> String{
        if real_box_position.isEmpty {
            deal_with_box()
        }

        for box in real_box_position {
            if box.position.contains(pts) {
                //return String(format: "%.2f", box.nums[0])
                return box.nums[0]
            }
        }
        return ""
    }
        
    
    func deal_with_box() {
        let imageSize = PickedImage.instance.get().data?.size

        for box in box_position {
            let rectangle = CGRect(x: box.position.origin.x * imageSize!.width, y: (CGFloat(1.0) - box.position.origin.y) * imageSize!.height - box.position.height * imageSize!.height , width: box.position.width * imageSize!.width, height: box.position.height * imageSize!.height)
            real_box_position.append(Box(position: rectangle, nums: box.nums))
        }
    }
}

extension String {
    func isDouble() -> Bool {
        return (Double(self) != nil)
    }
}
